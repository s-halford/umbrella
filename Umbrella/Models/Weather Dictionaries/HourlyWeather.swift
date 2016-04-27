//
//  HourlyForecast.swift
//  Umbrella
//
//  Created by Scott Halford on 4/16/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
import UIKit

struct HourlyWeather {
    let timeStamp: String?
    let icon: String?
    let icon_url: String?
    let temp_english: String?
    let temp_metric: String?
    
    
    // Set hourly weather properties from hourly weather dictionarie
    init(hourlyWeatherDict: [String: AnyObject]) {
        
        timeStamp = hourlyWeatherDict["FCTTIME"]?["civil"] as? String
        icon = hourlyWeatherDict["icon"] as? String
        icon_url = hourlyWeatherDict["icon_url"] as? String
        temp_english = hourlyWeatherDict["temp"]?["english"] as? String
        temp_metric = hourlyWeatherDict["temp"]?["metric"] as? String
    }
}