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
    var durationSeconds: TimeInterval
    var instruction: String
    var tasteNote: String
}

extension CookingStep: FirestoreModel {
    init?(modelData: FirestoreModelData) {
        try? self.init(documentID: modelData.documentID, durationSeconds: modelData.value(forKey: "durationSeconds"), instruction: modelData.value(forKey: "durationSeconds"), tasteNote: modelData.value(forKey: "tasteNote"))
    }
}
