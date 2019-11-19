//
//  RCLTrashCan.swift
//  Recycler
//
//  Created by Roman Shveda on 3/2/18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import Foundation

struct TrashCan: Codable, Identifiable {
    var id: String?
    var userId: String
    var address: String
    var isFull: Bool = false
    var type: String
    var size: Int
    
    init(userId: String, address: String, type: RCLTrashType, size: RCLTrashSize) {
        self.userId = userId
        self.address = address
        self.type = type.rawValue
        self.size = size.rawValue
    }
    init() {
        self.userId = ""
        self.address = ""
        self.type = ""
        self.size = 0
    }
}
