//
//  MainViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentConditionsLabel: UILabel?
    @IBOutlet weak var currentCityStateLabel: UILabel?
    @IBOutlet weak var settingsButton: UIImageView?
    
    @IBOutlet weak var collectionView: UICollectionView?
    
    var hourlyWeather: [HourlyWeather] = []
    var dailyWeather: [[HourlyWeather]] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        retrieveWeatherForecast()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func returnFromSettingsSegue(_: UIStoryboardSegue) {
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Set the popover presentation style delegate to always force a popover
    }
    
    // MARK: - Weather Fetching
    
    func retrieveWeatherForecast() {
        var weatherRequest = WeatherRequest(APIKey: "fe607001f7266360")
        
        // Set the zip code
        weatherRequest.zipCode = "90293"
        
        // Here's your URL. Marshall this to the internet however you please.
        let url = weatherRequest.URL
        

        let forecastService = ForecastService()
        forecastService.getForecast(url!) {
        
        //weatherRequest.getForecast() {
            (let forecast) in
            if let weatherForecast = forecast,
                let currentWeather = weatherForecast.currentWeather {
                
                dispatch_async(dispatch_get_main_queue()) {
                    if let temp_f = currentWeather.temp_f {
                        self.currentTemperatureLabel?.text = "\(temp_f)º"
                    }

                    if let cityState = currentWeather.cityState {
                        self.currentCityStateLabel?.text = "\(cityState)"
                    }
                    
                    if let currentConditions = currentWeather.currentConditions {
                        self.currentConditionsLabel?.text = "\(currentConditions)"
                    }
                    
                    self.hourlyWeather = weatherForecast.hourly
                    
                    self.setupDaily()
                    
                    self.collectionView?.reloadData()
                    
                }
            }
        }
        
    }
    
    func setupDaily() {
        var tempWeather: [HourlyWeather] = []
        
        for item in self.hourlyWeather {
            
            if item.timeStamp == "12:00 AM" {
                self.dailyWeather.append(tempWeather)
                tempWeather = []
            }
            tempWeather.append(item)
            
        }
        
        self.dailyWeather.append(tempWeather)

    }
}

extension UIImageView {
    func downloadFromURL(URL:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: URL)
            else {return}
        contentMode = mode
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        let dataTask = session.dataTaskWithURL(url) {
            (let data, let response, let error) in
            
            guard
                let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200,
                let data = data where error == nil,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) {
                self.image = image
            }
            
        }
        
        dataTask.resume()
        
    }
}



// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dailyWeather.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dailyWeather[section].count
        //return hourlyWeather.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //fatalError()
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("hourlyCell", forIndexPath: indexPath) as! HourlyCell
        
        //let hourWeather = hourlyWeather[indexPath.row]
        
        let hourWeather = dailyWeather[indexPath.section][indexPath.row]
        
        if let timeStamp = hourWeather.timeStamp {
            cell.hourlyCellTimeLabel?.text = "\(timeStamp)"
        }
        
        if let icon = hourWeather.icon {
            let icon_url = "\(icon)".nrd_weatherIconURL()!
            cell.hourlyCellIcon?.downloadFromURL("\(icon_url)", contentMode: .ScaleAspectFit)
        }
        
        if let temp_english = hourWeather.temp_english {
            cell.hourlyCellTemperatureLabel?.text = "\(temp_english)º"
            
        }
        
        return cell
        
    }
    
   
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath) as! SectionHeader
        
        switch indexPath.section {
            case 0:
                header.headerTItle?.text = "Today"
            case 1:
                header.headerTItle?.text = "Tomorrow"
            default:
                header.headerTItle?.text = "Day After Tomorrow"
        }
        
        return header
        
    }
}
