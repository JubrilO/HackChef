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

class OverlayView: UIView {
    private lazy var layer0: CAGradientLayer = {
        let layer0 = CAGradientLayer()
        layer0.colors = [
            
            UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
            
            UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
            
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        layer0.bounds = bounds.insetBy(dx: -0.5*bounds.size.width, dy: -0.5*bounds.size.height)
        layer0.position = center
        return layer0
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(layer0, at: 0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(layer0, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer0.frame = bounds
        setNeedsDisplay()
    }
}

@IBDesignable
open class GradientView: UIView {
    @IBInspectable
    public var startColor: UIColor = .white {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var endColor: UIColor = .white {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
