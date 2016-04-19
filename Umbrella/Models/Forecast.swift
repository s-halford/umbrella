//
//  Forecast.swift
//  Umbrella
//
//  Created by Scott Halford on 4/16/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

struct Forecast {
    var currentWeather: CurrentWeather?
    var hourly: [HourlyWeather] = []
    
    init(weatherDictionary: [String: AnyObject]?) {
        if let currentWeatherDictionary = weatherDictionary?["current_observation"] as? [String: AnyObject] {
            currentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
        }
        
        if let hourlyWeatherArray = weatherDictionary?["hourly_forecast"] as? [[String: AnyObject]] {
            for hourlyWeather in hourlyWeatherArray {
                let hour = HourlyWeather(hourlyWeatherDict: hourlyWeather)
                hourly.append(hour)
            }
        }
    }
    
}
