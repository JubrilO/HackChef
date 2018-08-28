//
//  IngredientViewController.swift
//  HackChef
//
//  Created by Jubril on 8/12/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit

class IngredientViewController: UIViewController {

    @IBOutlet weak var commentsButtonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var chefNameHeaderLabel: UILabel!
    @IBOutlet weak var listButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listButton.isHidden = true
    }

    @IBAction func onCommentsButtonTap(_ sender: UITapGestureRecognizer) {
        sender.view?.isHidden = true
        listButton.isHidden = false
    }
    
    @IBAction func onListButtonTap(_ sender: UIButton) {
        sender.isHidden = true
        commentsButtonView.isHidden = false
    }
    
    @IBAction func onStartCookingButtonTap(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.CookingStepVC ) {
            present(vc, animated: true)
        }
    }
    
    @IBAction func onBackButtonTap(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension IngredientViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.IngredientCell) as! SwipeableTableCell
        return cell
    }
}
