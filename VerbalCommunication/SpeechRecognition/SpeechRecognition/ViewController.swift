//
//  ViewController.swift
//  SpeechRecognition
//
//  Created by Rick Wierenga on 07/01/2020.
//  Copyright © 2020 Rick Wierenga. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    
    public private(set) var isRecording = false

    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var audioSession: AVAudioSession!

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        checkPermissions()
    }
    
    // MARK: - User interface
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if isRecording { stopRecording() } else { startRecording() }
        isRecording.toggle()
        sender.setTitle((isRecording ? "Stop" : "Start") + " recording", for: .normal)
    }

    private func handleError(withMessage message: String) {
        // Present an alert.
        let ac = UIAlertController(title: "An error occured", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)

        // Disable record button.
        recordButton.setTitle("Not available.", for: .normal)
        recordButton.isEnabled = false
    }
    
    // MARK: - Speech recognition
    private func startRecording() {
        // MARK: 1. Create a recognizer.
        guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
            handleError(withMessage: "Speech recognizer not available.")
            return
        }

        // MARK: 2. Create a speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest!.shouldReportPartialResults = true

        recognizer.recognitionTask(with: recognitionRequest!) { (result, error) in
            guard error == nil else { self.handleError(withMessage: error!.localizedDescription); return }
            guard let result = result else { return }

            print("got a new result: \(result.bestTranscription.formattedString), final : \(result.isFinal)")
            if result.isFinal {
                DispatchQueue.main.async {
                    self.updateUI(withResult: result)
                }
            }
        }

        // MARK: 3. Create a recording and classification pipeline.
        audioEngine = AVAudioEngine()

        inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }

        // Build the graph.
        audioEngine.prepare()

        // MARK: 4. Start recognizing speech.
        do {
            // Activate the session.
            audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            // Start the processing pipeline.
            try audioEngine.start()
        } catch {
            handleError(withMessage: error.localizedDescription)
        }
    }

    private func updateUI(withResult result: SFSpeechRecognitionResult) {
        // Update the UI: Present an alert.
        let ac = UIAlertController(title: "You said:",
                                   message: result.bestTranscription.formattedString,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }

    private func stopRecording() {
        // End the recognition request.
        recognitionRequest?.endAudio()
        recognitionRequest = nil

        // Stop recording.
        audioEngine.stop()
        inputNode.removeTap(onBus: 0) // Call after audio engine is stopped as it modifies the graph.

        // Stop our session.
        try? audioSession.setActive(false)
        audioSession = nil
    }

    // MARK: - Privacy
    private func checkPermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized: break
                default: self.handlePermissionFailed()
                }
            }
        }
    }

    private func handlePermissionFailed() {
        // Present an alert asking the user to change their settings.
        let ac = UIAlertController(title: "This app must have access to speech recognition to work.",
                                   message: "Please consider updating your settings.",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Open settings", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        })
        ac.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(ac, animated: true)

        // Disable the record button.
        recordButton.isEnabled = false
        recordButton.setTitle("Speech recognition not available.", for: .normal)
    }
}
