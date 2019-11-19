//
//  RCLParsingByJSON.swift
//  Recycler
//
//  Created by Володимир Смульський on 3/13/18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreLocation

struct TrashFromJson {
    var nameInJson:String = ""
    var longitudeInJson:Double = 0
    var latitudeInJson:Double = 0
    var numberOfRaffleInJson:Double = 1
    var idInJson: Double = 0
}


extension TrashFromJson {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitudeInJson, longitude: self.longitudeInJson)
    }
}

class RLCParsingByJSON {
    
    let idIndex = 0
    let latitudeIndex = 4
    let longitudeIndex = 5
    let numberOfraffleIndex = 6
    let url = "https://firebasestorage.googleapis.com/v0/b/recycler032.appspot.com/o/lvivTrashMap.json?alt=media&token=127f7355-e63d-48c6-bf18-2018bcb15677"
    var tempDict = [TrashFromJson]()
    
    func temp(_ completion: @escaping (_ trashList: [TrashFromJson]?, _ error: String?)->Void ) {
        
        func executeCompletion(_ trashList: [TrashFromJson]?, _ error: String?) {
            DispatchQueue.main.async {
                completion(trashList, error)
            }
        }
        
        Alamofire.request(url).response { response in
            DispatchQueue.global().async {
                guard response.error == nil else {
                    executeCompletion(nil, response.error?.localizedDescription)
                    return
                }
                
                guard let data = response.data else {
                    executeCompletion(nil, "No data")
                    return
                }
                
                do {
                    let json = try JSON.init(data: data)
                    
                    var result = [TrashFromJson]()
                    for trashJson in json["Placemark"].arrayValue {
                        var trash = TrashFromJson()
                        trash.nameInJson = trashJson["name"].string ?? ""
                        
                        if let lat = trashJson["ExtendedData"]["Data"][self.latitudeIndex]["value"].string {
                            trash.latitudeInJson = Double(lat) ?? 0
                        }
                        if let long = trashJson["ExtendedData"]["Data"][self.longitudeIndex]["value"].string {
                            trash.longitudeInJson = Double(long) ?? 0
                        }
                        
                        if let numberOfRaffle = trashJson["ExtendedData"]["Data"][self.numberOfraffleIndex ]["value"].string {
                            trash.numberOfRaffleInJson = Double(numberOfRaffle) ?? 0
                        }
                        
                        if let id = trashJson["ExtendedData"]["Data"][self.idIndex]["value"].string {
                            trash.idInJson = Double(id) ?? 0
                        }
                        
                        result.append(trash)
                    }
                    executeCompletion(result, nil)
                } catch {
                    executeCompletion(nil, error.localizedDescription)
                }
            }
        }
    }
}
