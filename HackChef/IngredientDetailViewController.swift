//
//  IngredientDetailViewController.swift
//  HackChef
//
//  Created by Jubril on 20/08/2018.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit
import GrowingTextView

class IngredientDetailViewController: UIViewController {
    
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = keyboardHeight
            view.layoutIfNeeded()
        }
    }
    
    @objc private func tapGestureHandler() {
        view.endEditing(true)
    }

}
