//
//  UIImageView+Umbrella.swift
//  Umbrella
//
//  Created by Scott Halford on 4/25/16.
//  Copyright © 2016 The Nerdery. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadFromURL(URL:String, contentMode mode: UIViewContentMode) {
        
        //Validate URL String
        guard
            let url = NSURL(string: URL)
            else {return}
        
        //Set contentMode
        contentMode = mode
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        let dataTask = session.dataTaskWithURL(url) {
            (let data, let response, let error) in
            
            guard
                //Check the data task returned valid image data
                let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200,
                let data = data where error == nil,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) {
                //Set the image
                self.image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            }
            
        }
        
        //Start the data task
        dataTask.resume()
        
    }
}
