//
//  Forecast.swift
//  Umbrella
//
//  Created by Scott Halford on 4/16/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

struct Forecast {
    var errors: WeatherError?
    var currentWeather: CurrentWeather?
    var hourly: [HourlyWeather] = []
    
    // Create appropriate weather Dictionaries based on keys
    init(weatherDictionary: [String: AnyObject]?) {
        if let responseDictionary = weatherDictionary?["response"] as? [String: AnyObject] {
            errors = WeatherError(errorDictionary: responseDictionary)
        }
        
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
