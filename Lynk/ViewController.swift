//
//  ViewController.swift
//  Lynk
//
//  Created by Vathsav on 16/12/16.
//  Copyright © 2016 Vathsav Harikrishnan. All rights reserved.
//

import UIKit
import ParticleSDK
import ParticleDeviceSetupLibrary

class ViewController: UIViewController {

    // UI Components
    @IBOutlet weak var segmentedControlSelector: UISegmentedControl!
    @IBOutlet weak var labelPinStatus: UILabel!
    @IBOutlet weak var buttonPinZero: UIButton!
    @IBOutlet weak var buttonPinOne: UIButton!
    @IBOutlet weak var buttonPinTwo: UIButton!
    @IBOutlet weak var buttonPinThree: UIButton!
    @IBOutlet weak var buttonPinFour: UIButton!
    @IBOutlet weak var buttonPinFive: UIButton!
    @IBOutlet weak var buttonPinSix: UIButton!
    @IBOutlet weak var buttonPinSeven: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sliderAnalogValue: UISlider!
    
    // Globals
    var myCore : SparkDevice?
    let toggleFuntion = "togglePin"
    let analogFuntion = "analogWrite"
    let deviceName = "ruthless_dynamite"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Particle Device login wizard - super convinient!
        if let setupController = SparkSetupMainController(authenticationOnly: true) {
            self.present(setupController, animated: true, completion: nil)
        }
        
        // Get my Particle Core
        SparkCloud.sharedInstance().getDevices { (particleDevice:[Any]?, error:Error?) -> Void in
            if let _ = error {
                print("Unable to connect to the internet")
            } else {
                if let listOfDevices = particleDevice as? [SparkDevice]{
                    for device in listOfDevices {
                        if device.name == self.deviceName {
                            self.myCore = device
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControlPinSelector(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            buttonPinZero.setTitle("Analog Pin 0", for: .normal)
            buttonPinOne.setTitle("Analog Pin 1", for: .normal)
            buttonPinTwo.setTitle("Analog Pin 2", for: .normal)
            buttonPinThree.setTitle("Analog Pin 3", for: .normal)
            buttonPinFour.setTitle("Analog Pin 4", for: .normal)
            buttonPinFive.setTitle("Analog Pin 5", for: .normal)
            buttonPinSix.setTitle("Analog Pin 6", for: .normal)
            buttonPinSeven.setTitle("Analog Pin 7", for: .normal)
            sliderAnalogValue.isHidden = false
            sliderAnalogValue.setValue(200, animated: true)
            labelPinStatus.text = ""
        } else {
            buttonPinZero.setTitle("Digital Pin 0", for: .normal)
            buttonPinOne.setTitle("Digital Pin 1", for: .normal)
            buttonPinTwo.setTitle("Digital Pin 2", for: .normal)
            buttonPinThree.setTitle("Digital Pin 3", for: .normal)
            buttonPinFour.setTitle("Digital Pin 4", for: .normal)
            buttonPinFive.setTitle("Digital Pin 5", for: .normal)
            buttonPinSix.setTitle("Digital Pin 6", for: .normal)
            buttonPinSeven.setTitle("Digital Pin 7", for: .normal)
            sliderAnalogValue.isHidden = true
            labelPinStatus.text = ""
        }
    }
    
    @IBAction func valueSlider(_ sender: UISlider) {
        labelPinStatus.text = "\(lroundf(sender.value))"
    }
    
    @IBAction func buttonPinsToggled(_ sender: UIButton) {
        // self.activityIndicator.startAnimating()
        self.labelPinStatus.text = nil
        
        if self.segmentedControlSelector.selectedSegmentIndex == 0 {
            // Analog Pins
            let arguments : [Any] = ["A\(sender.currentTitle!.characters.last!)", lroundf(self.sliderAnalogValue.value)]
            print("Executing: \(arguments)")
            self.myCore?.callFunction(analogFuntion, withArguments: arguments, completion: { (resultCode : NSNumber?, error : Error?) in
                if error == nil {
                    print("Set \(sender.currentTitle!)")
                    self.labelPinStatus.text = "Toggled \(sender.currentTitle!) with value \(lroundf(self.sliderAnalogValue.value))"
                } else {
                    self.labelPinStatus.text = "Unable to set value"
                }
            })
        } else {
            // Digital Pins
            let argument : [Any] = ["\(sender.currentTitle!.characters.last!)"]
            self.myCore?.callFunction(toggleFuntion, withArguments : argument, completion: { (resultCode : NSNumber?, error : Error?) in
                if error == nil {
                    print("Toggled \(sender.currentTitle!)")
                    self.labelPinStatus.text = "Toggled \(sender.currentTitle!)"
                } else {
                    print(error.debugDescription)
                    self.labelPinStatus.text = "Unable to toggle"
                }
            })
        }
    }
    
}
