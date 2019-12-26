//
//  Controllers.swift
//  App
//
//  Created by Rick Wierenga on 21/11/2019.
//

import CoreImage
import Vision

@available(OSX 10.13, *)
struct Classifier {
    private static func convertCIImageToCGImage(image: CIImage) -> CGImage {
        let context = CIContext(options: nil)
        return context.createCGImage(image, from: image.extent)!
    }

    public static func classify(image: CIImage) -> [VNClassificationObservation] {
        var results = [VNClassificationObservation]()

        // Load the model.
        let model = try! VNCoreMLModel(for: Resnet50().model)

        // Prepare a ml request and wait for results before continuing.
        let semaphore = DispatchSemaphore(value: 1)
        semaphore.wait()
        let request = VNCoreMLRequest(model: model, completionHandler: { request, error in
            results = request.results as! [VNClassificationObservation]
            semaphore.signal()
        })

        // Make the request.
        let handler = VNImageRequestHandler(cgImage: convertCIImageToCGImage(image: image), options: [:])
        try? handler.perform([request])

        return results
    }
}
