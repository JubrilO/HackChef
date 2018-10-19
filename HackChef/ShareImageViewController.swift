//
//  ShareImageViewController.swift
//  HackChef
//
//  Created by Jubril on 16/10/2018.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit

class ShareImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSkipButtonTap(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
