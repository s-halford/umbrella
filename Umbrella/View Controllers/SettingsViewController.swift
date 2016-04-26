//
//  SettingsViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    var currentZip = ""
    var tempScale = TempScales.f
    
    @IBAction func tempScaleChanged(sender: AnyObject) {
        tempScale = TempScales(rawValue: sender.selectedSegmentIndex)!
    }
    
    @IBOutlet weak var tempScaleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var zipTextField: UITextField!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if(zipTextField.isFirstResponder()) {
            self.view.endEditing(true)
        } else {
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        zipTextField.text = currentZip
        tempScaleSegmentedControl.selectedSegmentIndex = tempScale.rawValue
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
