//
//  ViewController.swift
//  SunriseSunsetApp
//
//  Created by Konstantin Kalivod on 11/26/18.
//  Copyright © 2018 Kostya Kalivod. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var matchSunriseLabel: UILabel!
    @IBOutlet weak var matchSunsetLabel: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    
    // MARK: - Properties
    var locationManager = CLLocationManager()

    // MARK: - Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: UIColor.yellow, colorTwo: UIColor.white)
        setLocationManager()
    }
    
    //MARK: - IBActions
    @IBAction func didTapView(_ sender: UIGestureRecognizer) {
        view.endEditing(false)
    }
    
    // MARK: - Functions
    private func setLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - CCLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue = manager.location!.coordinate
        
        let latitude = locValue.latitude
        let longitude = locValue.longitude
        
        APIManager.getSunInfoFrom(lat: latitude, long: longitude) { (sunset, sunrise) in
            self.sunsetLabel.text = sunset
            self.sunriseLabel.text = sunrise
        }
        
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard  let text = textField.text else { return false }
        APIManager.getSunInfoIn(place: text) { (sunset, sunrise) in
            self.matchSunsetLabel.text = sunset
            self.matchSunriseLabel.text = sunrise
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
}
