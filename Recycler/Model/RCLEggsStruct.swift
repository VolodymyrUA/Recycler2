//
//  EggsStruct.swift
//  Recycler
//
//  Created by David on 3/15/18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import Foundation
import UIKit

struct EggsStruct {
    var baseEggs: [UIImage]  {
        get {
            return [#imageLiteral(resourceName: "okay"), #imageLiteral(resourceName: "trash_metal"), #imageLiteral(resourceName: "trash_paper"), #imageLiteral(resourceName: "trash_glass"), #imageLiteral(resourceName: "trash_plastic"), #imageLiteral(resourceName: "profile_edit"), #imageLiteral(resourceName: "trash_organic")].shuffled()
        }
    }
    func getEggs(number: Int) -> [UIImage] {
        let newArr = Array(baseEggs[0..<number])
        return  newArr
    }
}
