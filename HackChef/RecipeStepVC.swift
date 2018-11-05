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
    
    
    @IBOutlet weak var startButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var timerButtonTap: UITapGestureRecognizer!
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
        registerApplicationCycleNotifications()
        resetButton.isHidden = true
        duration = cookingStep.durationSeconds
        setupUIWithData()
        registerApplicationCycleNotifications()
        setupFontsForSmallerScreens()
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
    
    func setupFontsForSmallerScreens() {
        if UIScreen.main.bounds.size.width == 320 {
            // iPhone 4
            instructionsLabel.font = instructionsLabel.font.withSize(14)
            bottomConstraint.constant = 20
            startButtonTopConstraint.constant = 15
        }
        else if UIScreen.main.bounds.size.width == 375 {
            instructionsLabel.font = instructionsLabel.font.withSize(16)
            bottomConstraint.constant = 50
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
    
    func registerApplicationCycleNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicaionWillResignActive), name: .UIApplicationWillResignActive, object: nil)
    }
    
    
    @objc func applicationDidBecomeActive() {
        if isTimerRunning {
            let currentTime = Date()
            guard let timeBeforeEnteringBackground = UserDefaults.standard.object(forKey: "HCResignActiveTime") as? Date else { return }
            guard let durationBeforeEnteringBackground = UserDefaults.standard.object(forKey: "HCTimeLeft") as? TimeInterval else { return }
            let timeIntervalInBackground = currentTime.timeIntervalSince(timeBeforeEnteringBackground)
            print("Time in Background: \(timeIntervalInBackground)")
            let totalTimeElapsed = timeIntervalInBackground +  cookingStep.durationSeconds - durationBeforeEnteringBackground
            print("Total Time Elapsed: \(totalTimeElapsed)")
            if totalTimeElapsed >= cookingStep.durationSeconds {
                onResetButtonTap(resetButton)
                isTimerRunning = false
                print("ResetTimer")
                
            }
            else {
                duration = cookingStep.durationSeconds - totalTimeElapsed
                removePendingNotifications()
                timer.invalidate()
                isTimerRunning = false
                onStartButtonGestureRecognised(timerButtonTap)
                print("RunningTimer")
            }
            
        }
        
    }
    
    @objc func applicaionWillResignActive() {
        if isTimerRunning {
            UserDefaults.standard.set(Date(), forKey: "HCResignActiveTime")
            UserDefaults.standard.set(duration, forKey: "HCTimeLeft")
            timer.invalidate()
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
        let width = (CGFloat(pageboyViewController.pageCount!) * pageboyViewController.view.bounds.width)
        let pageOffset = (position.x / (CGFloat(pageboyViewController.pageCount!)-1)) * width
        let page = pageOffset /  width
        let progressInPage = pageOffset - (page * width)
        let progress = (CGFloat(page)*2) + progressInPage
        pageControl.progress = progress
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
