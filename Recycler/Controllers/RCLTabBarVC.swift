//
//  RCLTabBarVC.swift
//  Recycler
//
//  Created by Artem Rieznikov on 06.03.18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import UIKit

var currentUser = User()

class RCLTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUserEmail = RCLAuthentificator.email()
        FirestoreService.shared.getUserBy(email: currentUserEmail, completion: { (user) in
            if let tempUser = user {
                currentUser = tempUser
            }
        })
        
        setupUI()
    }
    
    func setupUI() {
        self.tabBar.tintColor = UIColor.TabBar.tint
        self.tabBar.barTintColor = UIColor.TabBar.barTint
    }

}
