//
//  RecipeOverviewVC.swift
//  HackChef
//
//  Created by Jubril on 8/11/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var hcLightGrey: UIColor {
        return UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    }
    class var hcHighlightColor: UIColor {
        return UIColor(red: 1, green: 0.94, blue: 0.92, alpha: 1)
    }
    class var hcLowHeatColor: UIColor {
        return UIColor(red: 1, green: 0.71, blue: 0.37, alpha: 1)
    }
    class var hcMediumHeatColor: UIColor {
        return UIColor(red: 1, green: 0.52, blue: 0.52, alpha: 1)
    }
    class var hcHighHeatColor: UIColor {
        return UIColor(red: 1, green: 0.52, blue: 0.52, alpha: 1)
    }
    
}
extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedStringKey.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChildViewController(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
