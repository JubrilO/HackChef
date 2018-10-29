//
//  CookingStepNavController.swift
//  HackChef
//
//  Created by Jubril on 09/09/2018.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit

class CookingStepNavController: UINavigationController, UIGestureRecognizerDelegate {
    var steps = [CookingStep]() {
        didSet {
            steps.reverse()
        }
    }
    var index = 0
    
    var prvsViewController: UIViewController?{
        let controllersOnNavStack = viewControllers
        let n = controllersOnNavStack.count
        guard let visibleVC = visibleViewController else {
            return nil
        }
        //if self is still on Navigation stack
        if controllersOnNavStack.last === visibleVC, n > 1{
            return controllersOnNavStack[n - 2]
        }else if n > 0{
            return controllersOnNavStack[n - 1]
        }
        return nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: true)
        interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _  = prvsViewController as? CountDownViewController {
            return false
        }
        else if let _ = prvsViewController as? CookingStepViewController {
            if index > 0 {
            index -= 1
            }
            return true
        }
        else {
            return viewControllers.count > 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
