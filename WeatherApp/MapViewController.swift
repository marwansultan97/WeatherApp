//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Marwan Osama on 11/16/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let vc = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    func render() {
        guard let myLocation = vc.locationManager.location else {
            print("No Location")
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        
    }


}
