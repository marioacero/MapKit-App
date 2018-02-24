//
//  LocationManager.swift
//  CLLocation-App
//
//  Created by Mario Acero on 2/23/18.
//  Copyright © 2018 Mario Acero. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

protocol LocationManagerDelegate: class {
    func didUpdateLocation(_ location: CLPlacemark)
}

enum TrackingState {
    case Foreground
    case Background
    case Combined
    case None
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // Singleton
    static let shared = LocationManager()
    
    weak var delegate: LocationManagerDelegate?
    let manager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = 1000 // update  every
        manager.distanceFilter = 10 // Update every 10
        requestPermission()
    }
    
    func updateTrackingMethod(_ type: TrackingState) {
        switch type {
        case .Foreground:
            stopBackgroundTracking()
            beginForegroundTracking()
        case .Background:
            stopForegroundTracking()
            beginBackgroundTracking()
        case .Combined:
            beginBackgroundTracking()
            beginForegroundTracking()
        default:
            stopBackgroundTracking()
        }
    }
    
    //MARK - Private Methods
    
    private func beginForegroundTracking() {
        manager.startUpdatingLocation()
    }
    
    private func stopForegroundTracking() {
        manager.stopUpdatingLocation()
    }
    
    private func beginBackgroundTracking() {
        manager.startMonitoringSignificantLocationChanges()
    }
    
    private func stopBackgroundTracking() {
        manager.stopMonitoringSignificantLocationChanges()
    }
    
    private func requestPermission()-> Void {
        checkAuth(CLLocationManager.authorizationStatus())
    }
    
    private func checkAuth(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("Tracking Authorized")
        case .authorizedWhenInUse:
            print("Tracking Authorized while using")
        case .denied:
            print("Tracking deneid")
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .restricted:
            print("Tracking Restricted")
        }
    }
    
    //Mark - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuth(status)
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("Resume Updates")
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("Pause Updates")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location update \(locations)")
        decodeLocation(locations[0])
    }
    
    func decodeLocation(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {[weak self] (placemark, error) in
            guard let strogSelf = self else { return }
            if error != nil {
                print("reverse geocoding failed whit error \(String(describing: error))")
            }
            if placemark == nil {
                print("No Location Obtained")
                return
            }
            
            let pms = placemark! as [CLPlacemark]
            
            if pms.count > 0 {
                let place = pms[0]
                print("Decoded Location: \(String(describing: place.location?.coordinate))")
                strogSelf.delegate?.didUpdateLocation(place)
            }
        }
    }
}
//Region Monitoring Extension
extension LocationManager {
    
    public func monitorRegion(_ region: CLRegion) {
        manager.startMonitoring(for: region)
    }
    
    public func stopMonitoringRegion(_ region: CLRegion) {
        manager.stopMonitoring(for: region)
    }
    
    //MARK - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered Regions \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit Region \(region)")
    }
    
}
