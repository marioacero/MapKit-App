//
//  MapViewController.swift
//  CLLocation-App
//
//  Created by Mario Acero on 2/23/18.
//  Copyright © 2018 Mario Acero. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView.delegate = self
    }
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        let userLocation = myMapView.userLocation

        if let coordinates = userLocation.location?.coordinate {
            let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            myMapView.setRegion(region, animated: true)
        }
    }
}
