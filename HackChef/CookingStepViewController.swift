//
//  CookingStepViewController.swift
//  HackChef
//
//  Created by Jubril on 20/08/2018.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit

class CookingStepViewController: UIViewController {

    @IBOutlet weak var currentStepCountLabel: UILabel!
    @IBOutlet weak var cookingStepCountLabel: UILabel!
    @IBOutlet weak var tastingNoteLabel: UILabel!
    @IBOutlet weak var tastingNoteHeader: UILabel!
    @IBOutlet weak var playButtonLabel: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var heatLevelLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var creatorNameLabel: UILabel!
    
    var isTimerRunning = false
    var timer = Timer()
    var seconds = 240
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         timerLabel.text = timeString(time: TimeInterval(seconds))
        navigationController?.interactivePopGestureRecognizer?.delegate = nil;

        // Do any additional setup after loading the view.
    }

    @IBAction func onPlayButtonTap(_ sender: UIButton) {
        if isTimerRunning {
            isTimerRunning = false
            sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            sender.backgroundColor = UIColor.white
            timer.invalidate()
        }
        else {
            isTimerRunning = true
            sender.setImage(#imageLiteral(resourceName: "control-pause"), for: .normal)
            sender.backgroundColor = UIColor.hcHighlightColor
            runTimer()
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate time's up.
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
            //timerLabel.text = String(seconds)
            //            labelButton.setTitle(timeString(time: TimeInterval(seconds)), for: UIControlState.normal)
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
    
    @IBAction func onNextButtonTap(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.CookingStepVC ) {
            navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @IBAction func onMoreButtonTap(_ sender: UIButton) {
        
        let kpActionSheet = KPActionSheet(items: [
            KPItem(title: "Return to previous step", onTap: {
                self.navigationController?.popViewController(animated: true)
            }),
            KPItem(title: "Send feedback on this step", onTap: {
                print("Hello girls 😇")
            }),
            KPItem(title: "End cooking session", onTap: {
                self.dismiss(animated: true)
            })
            ])
        present(kpActionSheet, animated: true, completion: nil)

    }
    
}

extension CookingStepViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        <#code#>
    }
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        self.interactivePopGestureRecognizer?.enabled = self.viewControllers.count > 1
    }
}
