//
//  ForecastService.swift
//  Umbrella
//
//  Created by Scott Halford on 4/17/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation

enum ForecastResult {
    case Success(Forecast)
    case Error(NSError)
}

struct ForecastService {
    
    
    //Perform network operation, create Forecast objects
    func getForecast(URL: NSURL, completion: (ForecastResult) -> Void) -> Void {
        let networkOperation = NetworkOperation(url: URL)
   
        networkOperation.downloadJSONFromURL { (result: NetworkResult) -> Void in
            
            switch result {
                case .Success(let f):
                    let forecast = Forecast(weatherDictionary: f)
                    completion(ForecastResult.Success(forecast))
                case .Error(let e):
                    completion(ForecastResult.Error(e))
            }
        }
        
        
        
    }
    
}