//
//  PageContainerVC.swift
//  HackChef
//
//  Created by Jubril on 26/10/2018.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit
import Pageboy

class PageContainerVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var cookingSteps = [CookingStep]()
    var addedPageVC = false
    let pageVC = PageVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.bounces = false
        pageVC.transition = PageboyViewController.Transition(style: .push, duration: 0.3)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !addedPageVC {
            addedPageVC = true
            addChildViewController(pageVC)
            pageVC.view.frame = containerView.frame
            view.addSubview(pageVC.view)
            pageVC.didMove(toParentViewController: self)
        }
    }
    
    
    @IBAction func onBackButtonTap(_ sender: UIButton) {
        pageVC.scrollToPage(.previous, animated: true)
        
    }
    
    @IBAction func onNextButtonTap(_ sender: Any) {
        pageVC.scrollToPage(.next, animated: true)
    }
    
}

extension PageContainerVC: PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return cookingSteps.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        guard let recipeStepVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.RecipeStepVC) as? RecipeStepVC else {return nil}
        recipeStepVC.cookingStep = cookingSteps[index]
        guard let pageCount = pageboyViewController.pageCount else {
            return nil
        }
        //pageCountLabel.text = "\(index+1) / \(pageCount)"
//                if index == 0 {
//                    backButton.isHidden = true
//                }
//                else {
//                    backButton.isHidden = false
//                }
//                if (index+1) == pageCount {nextButton.isHidden = true } else { nextButton.isHidden = false }
        
        return recipeStepVC
        
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollTo position: CGPoint, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        var integral: Double = 0.0
        let percentage = CGFloat(modf(Double(position.x), &integral))
        guard let index = pageboyViewController.currentIndex, let pageCount = pageboyViewController.pageCount else {
            return
        }
        guard percentage > 0 else {return}

        print(percentage)
        
        print("Current index \(index)")
        if index == 0 {
            backButton.alpha = percentage
        }
        else {
            backButton.alpha = percentage
        }
        if (index+1) == pageCount {
            nextButton.alpha = 1 - percentage
            
        } else {
            nextButton.alpha = 1 - percentage
            
        }
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        guard let pageCount = pageboyViewController.pageCount else {
            return
        }
        pageCountLabel.text = "\(index+1) / \(pageCount)"
        
        if index == 0 {
            backButton.alpha = 0
        }
        else {
            backButton.alpha = 1
        }
        print("currentIndex\(index)")
        if (index+1) == pageCount {
            nextButton.alpha = 0
            
        } else {
             nextButton.alpha = 1
            
        }
        
    }
}
