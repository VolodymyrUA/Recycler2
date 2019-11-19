//
//  RCLMapVC.swift
//  Recycler
//
//  Created by Artem Rieznikov on 02.03.18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import UIKit
import GoogleMaps

class RCLMapVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mapView: GMSMapView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 49.838138, longitude: 24.044102, zoom: 18.0)
       let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "RCLMapStyle", withExtension: "json")
            {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        view = mapView
        
        addMarkers()
        addTitleLabel(text: "Public trash cans")
    }
    
    func addMarkers(){
        let parsed = RLCParsingByJSON()
        parsed.temp { (trashList, error) in
            if error == nil {
                for trash in trashList! {
                    let markerImage = #imageLiteral(resourceName: "smallPin")
                    let marker = GMSMarker()
                    marker.position = trash.coordinate
                    marker.title = trash.nameInJson
                    marker.snippet = "Кількість смітників: \(trash.numberOfRaffleInJson)"
                    marker.icon = markerImage//GMSMarker.markerImage(with: .red)
                    marker.map = self.view as? GMSMapView
                    
                }
            }
            
            print("TrashCount \(String(describing: trashList?.count)) error: \(String(describing: error))")
}
    }

    
}
