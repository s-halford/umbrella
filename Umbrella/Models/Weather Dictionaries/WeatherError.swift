//
//  ZipError.swift
//  Umbrella
//
//  Created by Scott Halford on 4/19/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

struct WeatherError {
    
    let errorType: String?
    let errorDescription: String?
    
    // Retrieve any error messages from the API in case of invalid ZIP code
    init(errorDictionary: [String: AnyObject]) {
        errorType = errorDictionary["error"]?["type"] as? String
        errorDescription = errorDictionary["error"]?["description"] as? String
    }
}