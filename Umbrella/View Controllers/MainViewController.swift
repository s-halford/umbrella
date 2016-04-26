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
    @IBOutlet weak var backgroundBox: UIView!
    @IBOutlet weak var collectionView: UICollectionView?
    
    var dailyWeather: [DailyWeather] = []
    
    let apiKey = "fe607001f7266360"
    let warmColor = UIColor(0xFF9800)
    let coolColor = UIColor(0x03A9F4)
    var tempScale = TempScales.f
    var currentZip = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Initialize settings and values
        currentTemperatureLabel?.text = " "
        currentConditionsLabel?.text = " "
        currentCityStateLabel?.text = " "
        backgroundBox.layer.backgroundColor = warmColor.CGColor
        retrieveWeatherForecast(validateZip: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func returnFromSettingsSegue(segue: UIStoryboardSegue) {
        
        // Retrieve updated values from the Settings View Controlloer
        if let svc = segue.sourceViewController as? SettingsViewController {
            tempScale = svc.tempScale
            currentZip = svc.zipTextField.text!
            retrieveWeatherForecast(validateZip: true)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let svc = segue.destinationViewController as? SettingsViewController
        svc?.tempScale = tempScale
        svc?.currentZip = currentZip
    }
    
    // MARK: - Weather Fetching
    
    func retrieveWeatherForecast(validateZip validateZip: Bool) {
        // Clear daily weather
        dailyWeather = []
        
        var weatherRequest = WeatherRequest(APIKey: apiKey)
        
        // Set the zip code
        weatherRequest.zipCode = currentZip
        
        // Here's your URL. Marshall this to the internet however you please.
        let url = weatherRequest.URL
        
        // Use ForecastService to retrieve current weather data
        let forecastService = ForecastService()
        
        forecastService.getForecast(url!) {
            
            (let forecast) in
            
            //Handle any errors related to Zip Code Entry
            if let weatherError = forecast!.errors where
                weatherError.errorDescription != nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if(validateZip) {
                        
                        //Configure an alert with any errors in weather fetching
                        let alert = UIAlertController(title: nil, message: weatherError.errorDescription?.capitalizedString, preferredStyle: .Alert)
                       
                        //Display a more user-friendly message if no zip code has been entered
                        if(weatherError.errorType == "invalidquery") {
                            alert.message = "Please Enter a ZIP Code Location"
                        }
                        
                        //Take users to the settings screen if no ZIP code exists or the one they entered is invalid
                        let action = UIAlertAction(title: "OK", style: .Default, handler: { (a) in
                            self.performSegueWithIdentifier("settingsSegue", sender: nil)
                        })
                        
                        //Present the Alert View
                        alert.addAction(action)
                        self.presentViewController(alert, animated: true, completion: nil)
                   }
                }
            }
            
            //Set up weather data
            if let weatherForecast = forecast,
                
                //Display current weather data in UI
                let currentWeather = weatherForecast.currentWeather {
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if let temp_f = currentWeather.temp_f,
                        let temp_c = currentWeather.temp_c {
                        
                        //Set background box color to warm or cool dependent on current temperature value
                        if(temp_f >= 60) {
                            self.backgroundBox.layer.backgroundColor = self.warmColor.CGColor
                        } else {
                            self.backgroundBox.layer.backgroundColor = self.coolColor.CGColor
                        }
                        
                        //Round the current temperature value and display it in the UI
                        if(self.tempScale == TempScales.f) {
                            self.currentTemperatureLabel?.text = "\(Int(round(temp_f)))º"
                        } else {
                            self.currentTemperatureLabel?.text = "\(Int(round(temp_c)))º"
                        }
                        
                        
                    }
                    
                    //Display City/State Info
                    if let cityState = currentWeather.cityState {
                        self.currentCityStateLabel?.text = "\(cityState)"
                    }
                    
                    //Display Current Conditons Info
                    if let currentConditions = currentWeather.currentConditions {
                        self.currentConditionsLabel?.text = "\(currentConditions)"
                    }
                    
                    //Retrieve the returned hourly forecast info, and convert the results to the daily data models
                    let dailyRequest = DailyRequest(weatherForecast.hourly)
                    self.dailyWeather = dailyRequest.Daily!
                    
                    //Refresh the view with the current data
                    self.collectionView?.reloadData()
                
                }
            }
        }
        
    }
    
    
}


// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dailyWeather.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyWeather[section].hourlyWeather.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //fatalError()
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("hourlyCell", forIndexPath: indexPath) as! HourlyCell
        
        let hourWeather = dailyWeather[indexPath.section].hourlyWeather[indexPath.row]
        
        if let timeStamp = hourWeather.timeStamp {
            cell.hourlyCellTimeLabel?.text = "\(timeStamp)"
        }
        
        if let icon = hourWeather.icon {
            
            var icon_url = "\(icon)".nrd_weatherIconURL()!
            
            //Set a cells items to black initially
            cell.hourlyCellIcon?.tintColor = .blackColor()
            cell.hourlyCellTimeLabel?.textColor = .blackColor()
            cell.hourlyCellTemperatureLabel?.textColor = .blackColor()
            
            //If the high and the low for the day are equal, skip don't apply any tint
            if(dailyWeather[indexPath.section].highIndex != dailyWeather[indexPath.section].lowIndex) {
                
                //If this cell is the high for the day, tint the cell's items to the warm color
                if(indexPath.row == dailyWeather[indexPath.section].highIndex) {
                    icon_url = "\(icon)".nrd_weatherIconURL(highlighted: true)!
                    cell.hourlyCellIcon?.tintColor = warmColor
                    cell.hourlyCellTimeLabel?.textColor = warmColor
                    cell.hourlyCellTemperatureLabel?.textColor = warmColor
                }
                
                //If this cell is the low for the day, tint the cell's items to the cool color
                if(indexPath.row == dailyWeather[indexPath.section].lowIndex) {
                    icon_url = "\(icon)".nrd_weatherIconURL(highlighted: true)!
                    cell.hourlyCellIcon?.tintColor = coolColor
                    cell.hourlyCellTimeLabel?.textColor = coolColor
                    cell.hourlyCellTemperatureLabel?.textColor = coolColor
                }
            }
            
            cell.hourlyCellIcon?.downloadFromURL("\(icon_url)", contentMode: .ScaleAspectFit)
        }
        
        if let temp_english = hourWeather.temp_english,
            let temp_metric = hourWeather.temp_metric {
            
            //Set temperature display to fahrenheit or celsius depending on what the user currently has selected
            if(self.tempScale == TempScales.f) {
                cell.hourlyCellTemperatureLabel?.text = "\(temp_english)º"
            } else {
                cell.hourlyCellTemperatureLabel?.text = "\(temp_metric)º"
            }
            
        }
        
        return cell
        
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        //Initialize header cell
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath) as! SectionHeader
        
        //Add section header
        header.headerTItle?.text = dailyWeather[indexPath.section].headerTitle

        return header
        
    }
}
