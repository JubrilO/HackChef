//
//  ViewController.swift
//  HackChef
//
//  Created by Jubril on 8/11/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit
import Firebase

class RecipeOverviewVC: UIViewController, UINavigationControllerDelegate, CookingStepChild {
    
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var chefNameLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var chefNotesLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollableView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    var recipeID: String = "cXH71H2cb2dicN4eX5rk"
    var steps = [CookingStep]()
    var ingredients = [Ingredient]()
    var navVC = CookingStepNavController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipe()
        getSteps()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentViewTopConstraint.constant = mainImageView.bounds.height
        view.layoutIfNeeded()
    }
    
    @IBAction func onIngredientsButtonTap(_ sender: UITapGestureRecognizer) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.IngredientVC) as? IngredientViewController {
            vc.recipeID = recipeID
            vc.steps = steps
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onStartCookingButtonTap(_ sender: UITapGestureRecognizer) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.CountDownVC ) {
            if steps.count > 0 {
                if let navVC =  self.navigationController as? CookingStepNavController {
                    navVC.steps = steps
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    func getRecipe() {
        let db = Firestore.firestore()
        db.collection(StringConstants.recipes).document(recipeID).getModel(Recipe.self){
            recipe, err in
            if let err = err {
                print("error stuff r")
                print(err.localizedDescription)
            }
            else {
                if let recipe = recipe{
                    self.chefNameLabel.text = recipe.chefName + "'s"
                    self.recipeNameLabel.text = recipe.title
                    self.difficultyLabel.text = recipe.difficulty.capitalized
                    self.durationLabel.text = String(recipe.durationMinutes) + " Minutes"
                    self.chefNotesLabel.text = recipe.chefNotes
                    
                }
            }
        }
    }
    
    func getSteps() {
        let db = Firestore.firestore()
        db.collection("recipes").document(recipeID).collection("steps").getModels(CookingStep.self) {
            steps, error in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                if let steps = steps {
                    print(steps.count)
                    self.steps = steps
                }
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if toVC.isMember(of: CountDownViewController.self) {
            return FadeInAnimator(isPresenting: true)
        }
        return nil
    }
}

protocol CookingStepChild {
    var navVC: CookingStepNavController {get set}
}
