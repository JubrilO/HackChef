//
//  File.swift
//  HackChef
//
//  Created by Jubril on 8/12/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import Foundation
struct Constants {
    struct CellIdentifiers {
        static let IngredientCell = "IngredientCell"
        static let IngredientLinkCell = "IngredientLinkCell"
        static let CommentCell = "CommentCell"
        static let ReplyCell = "ReplyCell"
    }
    struct StoryboardIDs {
        static let IngredientVC = "IngredientVC"
        static let CookingStepVC = "CookingStepVC"
        static let IngredientDetailVC = "IngredientDetailVC"
        static let RecipeOverviewVC = "RecipeOverviewVC"
    }
    
}

func delay(_ delay: Double, closure: @escaping () -> ()) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
