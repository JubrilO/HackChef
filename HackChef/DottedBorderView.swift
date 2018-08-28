//
//  DottedBorderView.swift
//  HackChef
//
//  Created by Jubril on 8/11/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit

class DottedBorderView: UIView {
    override func draw(_ rect: CGRect) {
        let dashShape = CAShapeLayer()
        dashShape.strokeColor = UIColor.hcLightGrey.cgColor
        dashShape.fillColor = nil
        dashShape.lineDashPattern = [3, 3]
        dashShape.frame = self.bounds
        dashShape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 3).cgPath
        self.layer.addSublayer(dashShape)
    }
}

class DottedLineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let dashShape = CAShapeLayer()
        dashShape.strokeColor = UIColor.hcLightGrey.cgColor
        dashShape.fillColor = nil
        dashShape.lineDashPattern = [3, 3]
        dashShape.frame = self.bounds
        let path = CGMutablePath()
        path.addLines(between: [bounds.origin, CGPoint(x: bounds.maxX, y: bounds.maxY)])
        dashShape.path = path
        self.layer.addSublayer(dashShape)
    }
}
