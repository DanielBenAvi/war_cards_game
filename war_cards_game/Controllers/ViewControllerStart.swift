//
//  ViewControllerStart.swift
//  war_cards_game
//
//  Created by דניאל בן אבי on 24/07/2024.
//

import Foundation
import UIKit
import CoreLocation

class ViewControllerStart: UIViewController {
    
    @IBOutlet weak var label_title: UILabel!
    
    @IBOutlet weak var UITextField_name: UITextField!
    
    @IBOutlet weak var UIButton_setName: UIButton!
    
    @IBOutlet weak var UIButton_startGame: UIButton!
    
    @IBOutlet weak var UIStackView_inputStack: UIStackView!
    
    @IBOutlet weak var UIImageView_leftErath: UIImageView!
    
    @IBOutlet weak var UIImageView_rightErath: UIImageView!
    
    var name: String = ""
    
    let locationManager = CLLocationManager()
    
    var locationValue: CLLocationCoordinate2D? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentLocation()
        
        
        // check if the name is saved in the user defaults
        if let name = UserDefaults.standard.string(forKey: "name") {
            self.name = name
            label_title.text = "Hello, \(name)"
            
            // hide the input stack
            UIStackView_inputStack.isHidden = true
            
        }
    }
    
    
    @IBAction func UIButton_setName(_ sender: Any) {
        if UITextField_name.text != "" {
            name = UITextField_name.text!
            label_title.text = "Hello, \(UITextField_name.text!)"
        }
    }
    
    @IBAction func UIButton_startGame(_ sender: Any) {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let ViewControllerGame = storyboard.instantiateViewController(withIdentifier: "ViewControllerGame") as? ViewControllerGame {
            // Present the view controller
            
            if name.isEmpty {
                // popup an error alert to the user to enter a name
                let alert = UIAlertController(title: "Error", message: "Please enter a name", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
            if locationValue == nil {
                // popup an error alert to the user to enter a name
                let alert = UIAlertController(title: "Error", message: "Please enable location services", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
            // save the name of the player with user defaults
            UserDefaults.standard.set(name, forKey: "name")
            
            // save the longitude of the player with user defaults
            UserDefaults.standard.set(locationValue?.longitude, forKey: "longitude")
            
            self.present(ViewControllerGame, animated: false, completion: nil)
        }
    }
    
    
    func getCurrentLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        let myQueue = DispatchQueue(label:"myOwnQueue")
        myQueue.async {
          if CLLocationManager.locationServicesEnabled() {
              self.locationManager.delegate = self
              self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
              self.locationManager.startUpdatingLocation()
          }
        }

    }
}

extension ViewControllerStart: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValie: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationValue = locationValie
        
        
        if locationValue!.longitude > CENTER_Y_CONSTRAINT {
            UIImageView_leftErath.isHidden = true
            UIImageView_rightErath.isHidden = false
        } else {
            UIImageView_leftErath.isHidden = false
            UIImageView_rightErath.isHidden = true
        }
        
        
        print("locations = \(locationValie.latitude) \(locationValie.longitude)")
        
    }
}
