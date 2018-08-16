//
//  HCHighlightedButton.swift
//  HackChef
//
//  Created by Jubril on 8/12/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit

class HCHighlightedButton: UIButton {

    override func draw(_ rect: CGRect) {
        let highlight = CAShapeLayer()
        highlight.strokeColor = UIColor.hcHighlightColor.cgColor
        highlight.fillColor = UIColor.hcHighlightColor.cgColor
        let highlightRect = CGRect(x: bounds.origin.x , y: bounds.origin.y, width: bounds.width + 4, height: bounds.height)
        highlight.frame = highlightRect
        highlight.path = UIBezierPath(rect: highlightRect).cgPath
        self.layer.insertSublayer(highlight, at: 0)
    }

}
