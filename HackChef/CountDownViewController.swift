//
//  CountDownViewController.swift
//  HackChef
//
//  Created by Jubril on 08/10/2018.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit

class CountDownViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var verticalConstriant: NSLayoutConstraint!
    
    var timer = Timer()
    var cookingSteps = [CookingStep]()
    var seconds =  3
    let translateTransform = CGAffineTransform(translationX: 0, y: -20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        seconds = 3
        setupInitialState()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func setupInitialState() {
        //view.alpha = 0
        //countdownLabel.alpha = 0
        logoImageView.alpha = 0
        logoImageView.transform = translateTransform
        //countdownLabel.transform = translateTransform
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate([
            view.animate([.fadeIn()]),
            logoImageView.animate(inParallel: [.fadeIn(), .transformToOriginal()]),
            countdownLabel.animate(inParallel: [.fadeIn()])
            ])
           self.runTimer()
        
    }
    
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds == 1 {
            timer.invalidate()
            //Send alert to indicate time's up.
            presentCookingSteps()
        } else {
            seconds -= 1
            countdownLabel.text = String(seconds)
        }
    }
    
    func presentCookingSteps() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.PageContainerVC ) as? PageContainerVC {
            animate([
                countdownLabel.animate(inParallel: [.fadeOut(), .transform(to: translateTransform)]),
                logoImageView.animate(inParallel: [.fadeOut(), .transform(to: translateTransform)])
                ])
            delay(0.6){
                vc.cookingSteps = self.cookingSteps
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if toVC.isMember(of: CookingStepViewController.self) {
            return FadeInAnimator(isPresenting: false)
        }
        else {

            return nil
     }
    }
}
