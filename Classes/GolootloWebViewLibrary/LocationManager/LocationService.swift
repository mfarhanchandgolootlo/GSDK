//
//  LocationManager.swift
//  GolootloWebViewLibrary
//
//  Created by Asad Khan on 22/05/2019.
//  Copyright © 2019 Decagon. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
    
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    
    //static let sharedInstance = LocationService()
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    let locationManagertmp = CLLocationManager()

    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization // Apple can reject build if they deemed it does not require it
            // 2. requestWhenInUseAuthorization
            
            
            locationManager.requestWhenInUseAuthorization()
        }else if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted{
            
            print("Location permission asked")
            //GolootloWebController.showAlert()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 10 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
        
       
    }
    
    // CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        // singleton for get last location
        self.lastLocation = location
        
        // use for real time update location
        updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // do on error
        updateLocationDidFailWithError(error: error as NSError)
    }
    
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
    func requestLocationPermission() {
        self.locationManagertmp.delegate = self  // Make sure to conform to CLLocationManagerDelegate
        self.locationManagertmp.requestWhenInUseAuthorization()  // Request "When In Use" permission
        // Or use requestAlwaysAuthorization() for "Always" permission
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Location permission not determined yet.")
        case .restricted:
            print("Location access is restricted.")
        case .denied:
            print("Location permission denied.")
        case .authorizedWhenInUse:
            print("Location permission granted for 'When In Use'.")
            self.locationManagertmp.startUpdatingLocation()  // Start updating location if needed
        case .authorizedAlways:
            print("Location permission granted for 'Always'.")
            self.locationManagertmp.startUpdatingLocation()  // Start updating location if needed
        @unknown default:
            print("Unknown authorization status.")
        }
    }
}
