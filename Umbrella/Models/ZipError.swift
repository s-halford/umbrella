//
//  ZipError.swift
//  Umbrella
//
//  Created by Scott Halford on 4/19/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

struct ZipError {
    
    let errorType: String?
    let errorDescription: String?
    
    init(weatherDictionary: [String: AnyObject]) {
        errorType = weatherDictionary["error"]?["type"] as? String
        errorDescription = weatherDictionary["error"]?["description"] as? String
    }
}