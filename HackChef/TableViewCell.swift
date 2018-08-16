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
    var completeAnimationOnDragRelease = false
    var px : CGFloat = 25
    var py : CGFloat = 30
    var textWidth: CGFloat = 0.0
    let path = UIBezierPath()
    var currentPoint: CGPoint = CGPoint.zero
    var prevTranslation: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        textWidth = quantity.frame.maxX
    }
    
    var originalCenter = CGPoint()
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        drawLine()
    }
    
    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            //prevTranslation = 0
            
        }
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            let distanceTravelled = translation.x - prevTranslation
            if (distanceTravelled + px) >= 25 && (distanceTravelled + px) < textWidth {
                px += distanceTravelled
                completeAnimationOnDragRelease = px < textWidth / 2.0
                setNeedsDisplay()
            }
            prevTranslation = translation.x
            
        }
        if recognizer.state == .ended {
            if !completeAnimationOnDragRelease {
                
            }
            if (px-25) > textWidth/2 {
                path.removeAllPoints()
                let newpath = UIBezierPath()
                path.move(to: CGPoint(x:25, y: 30))
                path.addLine(to:  CGPoint(x: px, y: py))
                UIColor.black.set()
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                self.layer.addSublayer(shapeLayer)
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.fromValue = CGPoint(x: px, y: py)
                animation.toValue = CGPoint(x: textWidth + 25, y: py)
                animation.duration = 0.7
                shapeLayer.add(animation, forKey: "drawLineAnimation")
            }
        }
    }
    
    func drawLine() {
        
        print(px)
        if px > 25 && px <= textWidth{
            path.removeAllPoints()
            path.move(to: CGPoint(x:25, y: 30))
            path.addLine(to: CGPoint(x: px, y: py))
            UIColor.black.set()
            path.stroke()
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    
}
