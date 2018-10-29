//
//  ImageVC.swift
//  HackChef
//
//  Created by Jubril on 26/10/2018.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit
import Kingfisher

class ImageVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageURL: String!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: imageURL)
        print("Image URL \(imageURL)")
        imageView.kf.setImage(with: url)
    }

}
