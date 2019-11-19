//
//  RCLIssuesCell.swift
//  Recycler
//
//  Created by Roman Shveda on 3/13/18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import UIKit

class RCLIssuesCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var button: UIButton!
    @IBAction func btn(_ sender: UIButton) {
        
    }
    var trashCan = TrashCan()
    var trash = Trash()
    var user = User()
    
    func configureCell(forCan: TrashCan, forTrash: Trash, forUser: User) {
        colorsSetup()
        self.trashCan = forCan
        self.trash = forTrash
        self.user = forUser

        switch trashCan.type {
        case "plastic" :
            self.icon.image = #imageLiteral(resourceName: "trash_plastic")
        case "metal" :
            self.icon.image = #imageLiteral(resourceName: "trash_metal")
        case "organic" :
            self.icon.image = #imageLiteral(resourceName: "trash_organic")
        case "battaries" :
            self.icon.image = #imageLiteral(resourceName: "battery")
        default:
            self.icon.image = #imageLiteral(resourceName: "trash_other")
        }
        var sizeName = ""
        switch trashCan.size {
        case 1:
            sizeName = "S"
        case 2:
            sizeName = "M"
        case 3:
            sizeName = "L"
        case 4:
            sizeName = "XL"
        default:
            sizeName = "M"
        }
//        viewContainer.backgroundColor = UIColor.Backgrounds.GrayLighter
        self.location.text = forCan.address
        self.size.text = sizeName
        self.phoneNumber.text = forUser.phoneNumber
        self.button.backgroundColor = UIColor.Backgrounds.GrayLight
        self.button.layer.cornerRadius = CGFloat.Design.CornerRadius
    }
    
    func colorsSetup() {
        viewContainer.backgroundColor = UIColor.Backgrounds.GrayLighter
        location.textColor = UIColor.Font.Gray
        size.textColor = UIColor.Font.White
        viewContainer.layer.cornerRadius = CGFloat.Design.CornerRadius
        size.textColor = UIColor.Font.White
        backgroundColor = UIColor.clear
//            UIColor.Backgrounds.GrayDark
    }
    
}
