//
//  CookingStep.swift
//  HackChef
//
//  Created by Jubril on 13/10/2018.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import Foundation
import Firebase

struct CookingStep {
    var documentID: String!
    var images: [String]
    var durationSeconds: TimeInterval
    var instruction: String
    var tasteNote: String?
    var chefName: String
    var dishName: String
    var heat: String
    var heatLevel: HeatLevel {
        get {
            if heat == "low" {
                return .low
            }
            else if heat == "medium" {
                return .medium
            }
            else {
                return .high
            }
        }
    }
    
    enum HeatLevel: String {
        case low
        case medium
        case high
    }
    
}

extension CookingStep: FirestoreModel {
    init?(modelData: FirestoreModelData) {
        try? self.init(documentID: modelData.documentID, images: modelData.value(forKey: "images"), durationSeconds: modelData.value(forKey: "durationSeconds"), instruction: modelData.value(forKey: "instruction"), tasteNote: modelData.value(forKey: "tasteNote"), chefName: modelData.value(forKey: "chefName"), dishName: modelData.value(forKey: "dishName"), heat: modelData.value(forKey: "heat"))
    }
}
