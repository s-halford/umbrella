//
//  ForecastService.swift
//  Umbrella
//
//  Created by Scott Halford on 4/17/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

struct ForecastService {
    
    
    //Perform network operation, create Forecast objects
    func getForecast(URL: NSURL, completion: ((Forecast?)-> Void)) {
        let networkOperation = NetworkOperation(url: URL)
   
        networkOperation.downloadJSONFromURL {
            (let JSONDictionary) in
            let forecast = Forecast(weatherDictionary: JSONDictionary)
            completion(forecast)
            
        }
        
        
    }
    
}