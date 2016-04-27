//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Pasan Premaratne on 5/12/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import Foundation

struct CurrentWeather {
    
    let temp_c: Double?
    let temp_f: Double?
    let cityState: String?
    let currentConditions: String?
    
    
    // Retrieve current weather data to display in UI
    init(weatherDictionary: [String: AnyObject]) {
        temp_f = weatherDictionary["temp_f"] as? Double
        temp_c = weatherDictionary["temp_c"] as? Double
        cityState = weatherDictionary["display_location"]?["full"] as? String
        currentConditions = weatherDictionary["weather"] as? String
    }
}
