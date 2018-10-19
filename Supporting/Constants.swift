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
        static let CountDownVC = "CountDownVC"
        static let ShareImageVC = "ShareImageVC"
        static let RatingVC = "RatingVC"
    }
    
}

struct StringConstants {
    static let recipes = "recipes"
    static let ingredients = "ingredients"
}

func delay(_ delay: Double, closure: @escaping () -> ()) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

func timeString(time:TimeInterval) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    if hours == 0 {
        return String(format:"%02i:%02i", minutes, seconds)
    }
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
}
