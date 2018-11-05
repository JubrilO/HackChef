//
//  FadeInTransition.swift
//  HackChef
//
//  Created by Jubril on 11/10/2018.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import Foundation
import UIKit

class FadeInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool
    var duration: TimeInterval
    
    init(isPresenting: Bool, duration: TimeInterval = 0.4) {
        self.isPresenting = isPresenting
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        
        guard let originView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                return
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.frame = destinationView.frame
        containerView.addSubview(originView)
        
        destinationView.alpha = isPresenting ? 0 : 1
        backgroundView.alpha = isPresenting ? 0 : 1
        if isPresenting {
        containerView.addSubview(backgroundView)
        containerView.addSubview(destinationView)
        }
        else {
            containerView.addSubview(destinationView)
            containerView.addSubview(backgroundView)
        }
        
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1){
            backgroundView.alpha = self.isPresenting ? 1 : 0
        }
        
        animator.startAnimation()
        
        animator.addCompletion {
            _ in
            backgroundView.removeFromSuperview()
            destinationView.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}

