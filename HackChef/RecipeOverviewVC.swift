//
//  ViewController.swift
//  HackChef
//
//  Created by Jubril on 8/11/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit

class RecipeOverviewVC: UIViewController {

    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollableView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentViewTopConstraint.constant = mainImageView.frame.height
        view.layoutIfNeeded()
        scrollView.scrollRectToVisible(view.bounds, animated: false)
    }
    
    @IBAction func onIngredientsButtonTap(_ sender: UITapGestureRecognizer) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.IngredientVC) as? IngredientViewController {
            present(vc, animated: true)
        }
    }
    
    @IBAction func onStartCookingButtonTap(_ sender: UITapGestureRecognizer) {
        
    }
}

