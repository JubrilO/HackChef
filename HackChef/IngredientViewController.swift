//
//  IngredientViewController.swift
//  HackChef
//
//  Created by Jubril on 8/12/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit

class IngredientViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var chefNameHeaderLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onCommentsButtonTap(_ sender: UIButton) {
        
    }
    
    @IBAction func onBackButtonTap(_ sender: UIButton) {
        
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
