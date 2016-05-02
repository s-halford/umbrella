//
//  NetworkOperation.swift
//  Umbrella
//
//  Created by Scott Halford on 4/13/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import Foundation
import UIKit

enum NetworkResult {
    case Success([String : AnyObject])
    case Error(NSError)
}

class NetworkOperation {
    
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    var errorMsg: String?
    
    typealias JSONDictionaryCompletion = ([String: AnyObject]?) -> String
    
    init(url: NSURL) {
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: (result: NetworkResult) -> Void) -> Void {
        
        // Perform the network request
        let request: NSURLRequest = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            //Checek for valid httpResponse
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200 :
                        do {
                            //Serialize JSON data
                            let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
                            completion(result: NetworkResult.Success(jsonDictionary))
                        } catch let error {
                            print("JSON Serialization failed. Error: \(error)")
                        }
                    default:
                        print("GET request not successful.  HTTP status code: \(httpResponse.statusCode)")
                }
            } else {
                completion(result: NetworkResult.Error(error!))
            }
        }
        
        //Start data task
        dataTask.resume()
        
    }
    
}