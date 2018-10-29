//
//  RecipeStepVC.swift
//  HackChef
//
//  Created by Jubril on 26/10/2018.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit
import UserNotifications
import Pageboy
import PageControls

class RecipeStepVC: UIViewController {
    
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var pageControl: SnakePageControl!
    @IBOutlet weak var buttonImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var heatLevelIndicator: UIView!
    @IBOutlet weak var heatLevelLabel: UILabel!
    @IBOutlet weak var metaStackView: UIStackView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var imagePlaceholderView: UIView!
    
    var cookingStep: CookingStep!
    var duration: TimeInterval = 0
    var isTimerRunning = false
    var imageSlideActive = false
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.isHidden = true
        duration = cookingStep.durationSeconds
        setupUIWithData()
        //addImageSlideVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //addImageSlideVC()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !imageSlideActive {
            addImageSlideVC()
        }
    }
    
    @IBAction func onStartButtonGestureRecognised(_ sender: UITapGestureRecognizer) {
        if !isTimerRunning {
            setupTimerActiveState()
            runTimer()
        }
        else {
            setupTimerPausedState()
            removePendingNotifications()
            timer.invalidate()
        }
    }
    
    @IBAction func onResetButtonTap(_ sender: UIButton) {
        setupTimerInactiveState()
        timer.invalidate()
        removePendingNotifications()
        duration = cookingStep.durationSeconds
    }
    
    func setupUIWithData() {
        instructionsLabel.text = cookingStep.instruction
        heatLevelLabel.text = cookingStep.heatLevel.rawValue.capitalized + " Heat"
        timerLabel.text = timeString(time: cookingStep.durationSeconds)
    }
    
    func scheduleNotification(duration: TimeInterval) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Timer Complete"
        notificationContent.body = ""
        notificationContent.categoryIdentifier = "timer.category"
        notificationContent.sound = UNNotificationSound(named: "Alarm.wav")
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duration, repeats: false)
        let request = UNNotificationRequest(identifier: "Timer", content: notificationContent, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.add(request)
    }
    
    func removePendingNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["Timer"])
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            if self.duration < 1 {
                self.setupTimerInactiveState()
                self.timer.invalidate()
                self.duration = self.cookingStep.durationSeconds
                self.parentPageboy?.scrollToPage(.next, animated: true)
            }
            else {
                self.duration -= 1
                self.buttonLabel.text = timeString(time: self.duration)
            }
        }
        scheduleNotification(duration: duration)
    }
    
    func addImageSlideVC() {
        let imageSlider = PageVC()
        imageSlideActive = true
        addChildViewController(imageSlider)
        imageSlider.view.frame = imagePlaceholderView.frame
        view.addSubview(imageSlider.view)
        imageSlider.didMove(toParentViewController: self)
        imageSlider.dataSource = self
        imageSlider.delegate = self
        if cookingStep.images.count <= 1 {
            pageControl.isHidden = true
        }
    }
    
    func setupTimerActiveState() {
        isTimerRunning = true
        buttonImageView.image = #imageLiteral(resourceName: "control-pause-1")
        buttonLabel.text = timeString(time: self.duration)
        timerLabel.isHidden = true
        resetButton.isHidden = false
    }
    
    func setupTimerInactiveState() {
        isTimerRunning = false
        buttonLabel.text = "Start Timer"
        buttonImageView.image = #imageLiteral(resourceName: "play-1")
        timerLabel.isHidden = false
        resetButton.isHidden = true
    }
    
    func setupTimerPausedState() {
        isTimerRunning = false
        buttonImageView.image = #imageLiteral(resourceName: "play-1")
        timerLabel.isHidden = true
        resetButton.isHidden = false
    }
    
    func setupButtonWithNoTimer() {
        isTimerRunning = false
        buttonLabel.text = "Next Step"
        buttonImageView.image = #imageLiteral(resourceName: "play-1")
    }
}

extension RecipeStepVC: PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        print("ImageCount \(cookingStep.images.count)")
        pageControl.pageCount = cookingStep.images.count
        return cookingStep.images.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        let imageURL = cookingStep.images[index]
        let imageVC = storyboard?.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
        imageVC.imageURL = imageURL
        return imageVC
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollTo position: CGPoint, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
        print("Pod \(position.x)")
        let pageOffset = position.x
        let offset = pageOffset
        if offset < 0.0 {
            //offset = CGFloat(pageboyViewController.pageCount ?? 1) + offset
        }
        
        var integral: Double = 0.0
        if direction == .forward {
            let percentage = CGFloat(modf(Double(offset), &integral)) + CGFloat(pageboyViewController.currentIndex ?? 0)
            pageControl.progress = percentage
            print("percentage \(percentage)&")
            
        }
        else if direction == .reverse {
            let percentage = CGFloat(modf(Double(offset), &integral)) + CGFloat(pageboyViewController.currentIndex ?? 0) - 1
            pageControl.progress = percentage
            print("percentage \(percentage)&")
            
            
        }
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
    }
    
}

extension RecipeStepVC: UNUserNotificationCenterDelegate {
    
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
