//
//  TableViewCell.swift
//  HackChef
//
//  Created by Jubril on 8/12/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit

class SwipeableTableCell: UITableViewCell{
    @IBOutlet weak var ingredient: UILabel!
    @IBOutlet weak var quantity: UILabel!
    var shapeLayer = CAShapeLayer()
    var px : CGFloat = 25
    var py : CGFloat = 30
    var textWidth: CGFloat = 0.0
    let path = UIBezierPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let rightSwipeGesture =  UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        rightSwipeGesture.numberOfTouchesRequired = 1
        rightSwipeGesture.direction = .right
        leftSwipeGesture.numberOfTouchesRequired = 1
        leftSwipeGesture.direction = .left
        rightSwipeGesture.delegate = self
        addGestureRecognizer(rightSwipeGesture)
        addGestureRecognizer(leftSwipeGesture)
        textWidth = quantity.frame.maxX
        drawLine()
    }
    
    func drawLine() {
        path.move(to: CGPoint(x:px, y: py))
        path.addLine(to:  CGPoint(x: textWidth, y: py))
        shapeLayer.lineWidth = 1
        shapeLayer.path = path.cgPath
    }
    
    @objc func handleRightSwipe(recognizer: UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case .right:
            print("right")
            drawlineAnimation()
        default:
            break
        }
    }
    
    @objc func handleLeftSwipe(recognizer: UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case .left:
            print("Left")
            removeLineAnimation()
        default:
            break
        }
    }
    
    func drawlineAnimation() {
        shapeLayer.fillColor = UIColor.black.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        self.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        shapeLayer.add(animation, forKey: "strokeEnd")
    }
    
    func removeLineAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.4
        animation.fromValue = shapeLayer.presentation()?.strokeEnd
        animation.toValue = 0
        shapeLayer.removeAllAnimations()
        shapeLayer.add(animation, forKey: "strokeEnd")
        delay(0.2) {
            self.shapeLayer.strokeColor = UIColor.clear.cgColor
        }
    }
    
}

