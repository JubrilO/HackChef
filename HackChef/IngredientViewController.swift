//
//  IngredientViewController.swift
//  HackChef
//
//  Created by Jubril on 8/12/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit
import Firebase

class IngredientViewController: UIViewController {

    @IBOutlet weak var commentsButtonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var chefNameHeaderLabel: UILabel!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var commentsVC = CommentsViewController()
    var ingredients = [Ingredient]()
    var steps = [CookingStep]()

    var recipeID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listButton.isHidden = true
        commentCountLabel.text = "200"
        commentCountLabel.isHidden = true
        getIngredients()
    }

    @IBAction func onCommentsButtonTap(_ sender: UITapGestureRecognizer) {
        sender.view?.isHidden = true
        listButton.isHidden = false
        let comment1  = Comment(text: "Does anyone know where I can get a Wok in Ibadan?", author: "allidoiscook", reply: false)
        let comment2 = Comment(text: "I'm not so sure if they sell wok, but check Challenge market, they sell cooking utensils there.", author: "TheApprentice", reply: true)
        let comments = [comment1, comment2]
        commentsVC = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
        commentsVC.comments = comments
        chefNameHeaderLabel.text = "\(comments.count) notes on Tobi Smith's"
        addChildViewController(commentsVC)
        view.addSubview(commentsVC.view)
        commentsVC.view.frame = tableView.frame
        commentsVC.didMove(toParentViewController: self)
    }
    
    @IBAction func onListButtonTap(_ sender: UIButton) {
        sender.isHidden = true
        commentsButtonView.isHidden = false
         chefNameHeaderLabel.text = "Ingredients for Tobi Smith’s"
        commentsVC.willMove(toParentViewController: nil)
        commentsVC.view.removeFromSuperview()
        commentsVC.removeFromParentViewController()
    }
    
    @IBAction func onStartCookingButtonTap(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.CountDownVC )  as? CountDownViewController{
            if !steps.isEmpty {
                vc.cookingSteps = steps
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func onBackButtonTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func getIngredients() {
        let db = Firestore.firestore()
        db.collection(StringConstants.recipes).document(recipeID).collection(StringConstants.ingredients).getModels(Ingredient.self) {
            ingredients, error in

            if let error = error {
                print(error.localizedDescription)
            }
            else {
                if let ingredients = ingredients {
                    self.ingredients = ingredients
                    self.tableView.reloadData()
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
}

extension IngredientViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredient = ingredients[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.IngredientCell) as! SwipeableTableCell
        cell.ingredient.text = ingredient.name
        cell.quantity.text = ingredient.quantity
        return cell
    }
}
