//
//  RCLAddTrashLocationVC.swift
//  Recycler
//
//  Created by Yurii Tsymbala on 09.03.18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation

class RCLAddTrashLocationVC: UIViewController {
    
    private var locationManager = CLLocationManager()
    private var userLocation = CLLocation()
    private var trashLocation = TrashLocation()
    private var marker = GMSMarker()
    private var geocoder = GMSGeocoder()
    private let defaultCamera = GMSCameraPosition.camera(withLatitude: 49.8383,longitude: 24.0232, zoom: 12.0)
    var trashLocationDelegate: TrashLocationDelegate?
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var addLocationBtn: UIButton!
    
    @IBAction func addLocationBtn(_ sender: UIButton) {
        geocoder.reverseGeocodeCoordinate(marker.position) { (response, error) in
            guard error == nil else { return }
            if let result = response?.firstResult()?.lines?.first {
                self.trashLocation.name = result
                self.trashLocation.latitude = self.marker.position.latitude
                self.trashLocation.longitude = self.marker.position.longitude
                self.completeAddingLocation()
                print(self.trashLocation)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func myLocationBtn(_ sender: UIButton) {
        marker.position = userLocation.coordinate
        animateCameraTo(coordinate: userLocation.coordinate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        customizeMap()
        mapView.delegate = self
        animateCameraTo(coordinate: userLocation.coordinate)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        if let locationOfMarker = locationManager.location {
            userLocation = locationOfMarker
            animateCameraTo(coordinate: userLocation.coordinate)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateCameraTo(coordinate: userLocation.coordinate)
        marker.position = userLocation.coordinate
        marker.map = mapView
        mapView.isMyLocationEnabled = true
    }
    
    private func viewDesign(){
        addLocationBtn.backgroundColor = UIColor.darkModeratePink
        addLocationBtn.layer.cornerRadius = CGFloat.Design.CornerRadius
    }
    
    private func customizeMap() {
        do {
            if let styleURL = Bundle.main.url(forResource: "RCLMapStyle", withExtension: "json")
            {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    private func animateCameraTo(coordinate: CLLocationCoordinate2D, zoom: Float = 14.0) {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoom)
        mapView.animate(to: camera)
    }
    
    private func completeAddingLocation() {
        trashLocationDelegate?.setLocation(location: trashLocation)
    }
}

extension RCLAddTrashLocationVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        marker.position = coordinate
        animateCameraTo(coordinate: coordinate, zoom: 14.0)
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        animateCameraTo(coordinate: userLocation.coordinate)
        return true
    }
}

extension RCLAddTrashLocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
}
