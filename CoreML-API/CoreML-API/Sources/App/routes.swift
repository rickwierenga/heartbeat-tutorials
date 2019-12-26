import CoreImage
import Vapor
import Vision

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("/") { _ in 
        return "Classifier!"
    }

    if #available(OSX 10.13, *) {
        router.post(ClassificationRequest.self, at: "/classify") { (request, classificationRequest) -> String in
            let image = classificationRequest.image
            let ciImage = CIImage(data: image.data)!
            let results = Classifier.classify(image: ciImage)
            if let encodedResults = try? JSONEncoder().encode(results),
                let response = String(data: encodedResults, encoding: .utf8) {
                return response
            } else { abort() }
        }
    }
}
