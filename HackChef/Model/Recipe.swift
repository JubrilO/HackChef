//
//  Recipe.swift
//  HackChef
//
//  Created by Jubril on 9/18/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import Foundation
import Firebase
struct Recipe {
    var documentID: String!
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

extension Recipe: FirestoreModel {
    init?(modelData: FirestoreModelData) {
        try? self.init(documentID: modelData.documentID, chefName: modelData.value(forKey: "chefName"), chefNotes: modelData.value(forKey: "chefNotes"), difficulty: modelData.value(forKey: "difficulty"), durationMinutes: modelData.value(forKey: "durationMinutes"), title: modelData.value(forKey: "title"))
    }
}
