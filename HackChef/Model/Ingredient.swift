//
//  Ingredient.swift
//  HackChef
//
//  Created by Jubril on 14/10/2018.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import Foundation
import Firebase

struct Ingredient {
    var documentID: String!
    var name: String
    var quantity: String
}

extension Ingredient: FirestoreModel {
    init?(modelData: FirestoreModelData) {
        try? self.init(documentID: modelData.documentID, name: modelData.value(forKey: "name"), quantity: modelData.value(forKey: "quantity"))
    }
}
