//
//  DailyWeather.swift
//  Umbrella
//
//  Created by Scott Halford on 4/21/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

struct DailyWeather {
    var headerTitle: String?
    var dailyHigh: String?
    var dailyLow: String?
    var lowIndex: Int?
    var highIndex: Int?
    var hourlyWeather: [HourlyWeather] = []
}