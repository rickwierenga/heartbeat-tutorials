//
//  ViewController.swift
//  SpeechSynthesis
//
//  Created by Rick Wierenga on 07/01/2020.
//  Copyright © 2020 Rick Wierenga. All rights reserved.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let utterance = AVSpeechUtterance(string: "Hello from Heartbeat! How are you?")
        utterance.rate = 0.5
        AVSpeechSynthesizer().speak(utterance)
    }
}
