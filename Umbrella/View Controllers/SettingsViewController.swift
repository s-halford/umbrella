//
//  SettingsViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    var tempScale = ""
    var currentZip = ""
    
    @IBAction func tempScaleChanged(sender: AnyObject) {
        let index = sender.selectedSegmentIndex
        let title = sender.titleForSegmentAtIndex(index)!
        tempScale = title
    }
    
    @IBOutlet weak var zipCodeBackground: UIView!
    @IBOutlet weak var tempScaleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var zipTextField: UITextField!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if(zipTextField.isFirstResponder()) {
            self.view.endEditing(true)
        } else {
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // zipTextField.becomeFirstResponder()
        zipTextField.text = currentZip
        setupSegmentedControl()
        
        // Do any additional setup after loading the view.
    }
    
    func setupSegmentedControl() {
        if(tempScale == "Fahrenheit") {
            tempScaleSegmentedControl.selectedSegmentIndex = 0
        } else {
            tempScaleSegmentedControl.selectedSegmentIndex = 1
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let mvc = segue.destinationViewController as? MainViewController
        mvc?.tempScale = tempScale
        mvc?.currentZip = zipTextField.text!
        mvc?.retrieveWeatherForecast()
        
    }
    

}
