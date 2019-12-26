//
//  VNClassificationObservation+Encodable.swift
//  App
//
//  Created by Rick Wierenga on 26/11/2019.
//

import Vision

@available(OSX 10.13, *)
extension VNClassificationObservation: Encodable {
    enum CodingKeys: String, CodingKey {
        case label
        case score
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(confidence as Float, forKey: .score)
        try container.encode(identifier, forKey: .label)
    }
}
