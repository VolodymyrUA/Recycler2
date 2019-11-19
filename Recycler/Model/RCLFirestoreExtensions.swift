//
//  RCLFirestoreExtensions.swift
//  Recycler
//
//  Created by Roman Shveda on 3/5/18.
//  Copyright © 2018 softserve.univercity. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension Encodable {
    func toJson(excluding keys: [String] = [String]()) throws -> [String: Any]{
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var json = jsonObject as? [String: Any] else {throw myEncodingError.encodingError}
        for key in keys {
            json[key] = nil
        }
        return json
    }
}

extension DocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T {
        var documentJson = data() ?? [String: Any]() 
        if includingId {
            documentJson["id"] = documentID
        }
        let documentData = try JSONSerialization.data(withJSONObject: documentJson, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        
        return decodedObject
    }
}

enum myEncodingError: Error {
    case encodingError
}
