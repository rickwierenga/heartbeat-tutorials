//
//  Product.swift
//  BarcodeScanner
//
//  Created by Rick Wierenga on 19/07/2019.
//  Copyright © 2019 Rick Wierenga. All rights reserved.
//

import Foundation

struct Product {
    let name: String?

    init(data: [String: AnyObject]) {
        if let name = data["name"] as? String {
            self.name = name
        } else { self.name = nil }
    }
}
