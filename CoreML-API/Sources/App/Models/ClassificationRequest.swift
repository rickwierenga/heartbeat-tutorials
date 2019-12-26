//
//  ClassificationRequest.swift
//  App
//
//  Created by Rick Wierenga on 20/11/2019.
//

import Vapor

struct ClassificationRequest: Content {
    let image: File
}
