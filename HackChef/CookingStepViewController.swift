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
        navigationController?.delegate = self
        timerLabel.text = timeString(time: TimeInterval(seconds))
        let stopAction = UNNotificationAction(identifier: "stop.action", title: "Stop", options: [])
        let timerCategory = UNNotificationCategory(identifier: "timer.category", actions: [stopAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([timerCategory])
        updateLabels()
    }
    
    @IBAction func onPlayButtonTap(_ sender: UIButton) {
        if isTimerRunning {
            isTimerRunning = false
            sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            sender.backgroundColor = UIColor.clear
            timer.invalidate()
            removePendingNotifications()
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
            resetTimerValues()
            triggerNotification()
        } else if seconds > 0 {
            seconds -= 1
            timerLabel.text = timeString(time: seconds)
        }
    }
    
    func resetTimerValues() {
        guard let cookingStep = cookingStep else {return}
        seconds = cookingStep.durationSeconds
        timerLabel.text = timeString(time: cookingStep.durationSeconds)
        isTimerRunning = false
        playButtonLabel.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        playButtonLabel.backgroundColor = UIColor.clear
    }
    
    
    @IBAction func onNextButtonTap(_ sender: UIButton) {
        timer.invalidate()
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
        if navVC.index % 2 != 0 {
            imageView.image = UIImage(named: "goatMeat")
        }
        if cookingStep.tasteNote == nil {
            tastingNoteHeader.isHidden = true
        }
        if navVC.index+1 == navVC.steps.count {
            nextStepButton.setTitle("End Cooking Session", for: .normal)
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
        notificationContent.categoryIdentifier = "timer.category"
        notificationContent.sound = UNNotificationSound(named: "Alarm.wav")
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.001, repeats: false)
        let request = UNNotificationRequest(identifier: "Timer", content: notificationContent, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.add(request) {
            _ in
        }
    }
    
    func removePendingNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["Timer"])
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
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

extension CookingStepViewController: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    
}

extension CookingStepViewController: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
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
        }
    }
}
