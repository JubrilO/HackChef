//
//  Recipe.swift
//  HackChef
//
//  Created by Jubril on 9/18/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import Foundation
struct Recipe {
    var chefName: String
    var chefNotes: String
    var difficulty: String
    var durationMinutes: Int
    var title: String
    
    var dictionary: [String:Any] {
        return [
            "chefName" : chefName,
            "chefNotes" : chefNotes
        ]
    }
}
