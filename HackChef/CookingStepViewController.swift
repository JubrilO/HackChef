//
//  CookingStepViewController.swift
//  HackChef
//
//  Created by Jubril on 20/08/2018.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit
import UserNotifications

class CookingStepViewController: UIViewController {
    
    @IBOutlet weak var nextStepButton: UIButton!
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
    var seconds : TimeInterval = 3
    var cookingStep: CookingStep?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navVC = navigationController as? CookingStepNavController {
            cookingStep = navVC.steps[navVC.index]
        }
        timerLabel.text = timeString(time: TimeInterval(seconds))
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        updateLabels()
    }
    
    @IBAction func onPlayButtonTap(_ sender: UIButton) {
        if isTimerRunning {
            isTimerRunning = false
            sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            sender.backgroundColor = UIColor.white
            timer.invalidate()
            removePendingNotifications()
        }
        else {
            isTimerRunning = true
            sender.setImage(#imageLiteral(resourceName: "control-pause"), for: .normal)
            sender.backgroundColor = UIColor.hcHighlightColor
            runTimer()
            triggerNotification()
        }
    }
    
    func updateLabels() {
        guard let cookingStep = cookingStep, let navVC = navigationController as? CookingStepNavController else { return}
        creatorNameLabel.text = cookingStep.chefName + "'s"
        recipeNameLabel.text = cookingStep.dishName
        tastingNoteLabel.text = cookingStep.tasteNote
        descriptionLabel.text = cookingStep.instruction
        heatLevelLabel.setupHeatLevelText(heat: cookingStep.heatLevel)
        seconds = cookingStep.durationSeconds
        timerLabel.text = timeString(time: cookingStep.durationSeconds)
        currentStepCountLabel.text = String(navVC.index+1)
        cookingStepCountLabel.text = " / " + String(navVC.steps.count)
        if cookingStep.tasteNote == nil {
            tastingNoteHeader.isHidden = true
        }
        if navVC.index+1 == navVC.steps.count {
            nextStepButton.setTitle("End Cooking Session", for: .normal)
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: seconds)
        }
    }
    
    
    @IBAction func onNextButtonTap(_ sender: UIButton) {
        removePendingNotifications()
        if let navVC = navigationController as? CookingStepNavController{
            if navVC.steps.count == navVC.index+1 {
                navVC.index = 0
                presentCompletionScreen()
            }
            else {
                presentNextCookingStep()
                navVC.index += 1
            }
        }
    }
    
    func presentNextCookingStep() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.CookingStepVC ) {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func presentCompletionScreen() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.RatingVC) as? RatingViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func triggerNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Time Up"
        notificationContent.body = "Move on to the next step"
        notificationContent.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "Timer", content: notificationContent, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    func removePendingNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["Timer"])
    }
    
    @IBAction func onMoreButtonTap(_ sender: UIButton) {
        
        let kpActionSheet = KPActionSheet(items: [
            KPItem(title: "Return to previous step", onTap: {
                if let navVC = self.navigationController as? CookingStepNavController {
                    navVC.index -= 1
                }
                self.navigationController?.popViewController(animated: true)
            }),
            KPItem(title: "End cooking session", onTap: {
                if let navVC = self.navigationController as? CookingStepNavController {
                    navVC.index = 0
                }
                self.navigationController?.popToRootViewController(animated: true)
            })
            ])
        if let navVC = navigationController as? CookingStepNavController{
            if navVC.index == 0 {
                kpActionSheet.items.remove(at: 0)
            }
        }
        present(kpActionSheet, animated: true, completion: nil)
        
    }
    
}

extension CookingStepViewController: UINavigationControllerDelegate {
    
}

extension UILabel {
    func setupHeatLevelText(heat: CookingStep.HeatLevel) {
        text = heat.rawValue.capitalized
        switch heat {
        case .low:
            textColor = UIColor.hcLowHeatColor
        case .medium:
            textColor = UIColor.hcMediumHeatColor
        case .high:
            textColor = UIColor.hcHighHeatColor
        default:
            break
        }
    }
}
