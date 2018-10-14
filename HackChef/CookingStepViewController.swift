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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         timerLabel.text = timeString(time: TimeInterval(seconds))
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
            timerLabel.text = timeString(time: seconds)
            //timerLabel.text = String(seconds)
            //            labelButton.setTitle(timeString(time: TimeInterval(seconds)), for: UIControlState.normal)
        }
    }
    
    
    @IBAction func onNextButtonTap(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.CookingStepVC ) {
            removePendingNotifications()
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
                self.navigationController?.popViewController(animated: true)
            }),
            KPItem(title: "Send feedback on this step", onTap: {
                print("Hello girls 😇")
            }),
            KPItem(title: "End cooking session", onTap: {
                self.navigationController?.popToRootViewController(animated: true)
            })
            ])
        present(kpActionSheet, animated: true, completion: nil)

    }
    
}

extension CookingStepViewController: UINavigationControllerDelegate {
    
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        <#code#>
//    }
//    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
//        self.interactivePopGestureRecognizer?.enabled = self.viewControllers.count > 1
//    }
}
