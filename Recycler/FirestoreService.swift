//
//  FirestoreService.swift
//  Recycler
//
//  Created by Roman Shveda on 3/2/18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore


class FirestoreService {
    
    private init(){}
    static let shared = FirestoreService()
    
    
    
    func configure() {
        FirebaseApp.configure()
        
        // todo remove bellow
        
//        let email = "testmail@mail.com"
//        let password = "111111"
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            // ...
//            print(error)
//            print(user)
//        }
//
//
//        Auth.auth().
    }
    
    func create() {
        let parameters: [String : Any] = ["firstName" : "Roman",
                                          "lastName" : "Shveda"
                                        ]
        let userReference = Firestore.firestore().collection("users")
        userReference.addDocument(data: parameters)
    }
    
    func read() {
        let userReference = Firestore.firestore().collection("users")
        
        userReference.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("\(error.debugDescription)")
                return
            }
            for document in snapshot.documents{
                print(document.data())
            }
        }
        
    }
    
    func update() {
        let userReference = Firestore.firestore().collection("users")
        userReference.document("h9I8GfLZrO6UntpzhYc6").setData(["firstName" : "Ed", "lastName" : "Seel"])
    }
    
    func delete() {
        let userReference = Firestore.firestore().collection("users")
        userReference.document("").delete()
    }
    
}
