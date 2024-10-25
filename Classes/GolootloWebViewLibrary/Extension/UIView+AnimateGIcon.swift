//
//  UIView+AnimateGIcon.swift
//  GolootloWebViewLibrary
//
//  Created by Asad Khan on 07/11/2019.
//  Copyright © 2019 Decagon. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func rotateAndScale() {
        
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.duration = 1
        rotateAnimation.repeatCount = Float.infinity
        //rotateAnimation.isAdditive = true
        rotateAnimation.beginTime = 0
        
        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.fromValue = 1
        scaleUp.toValue = 1.5
        scaleUp.duration = 1
        //scaleUp.isAdditive = true
        scaleUp.repeatCount = Float.infinity
        scaleUp.beginTime = 0
        
        let rotateReverseAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotateReverseAnimation.fromValue = CGFloat.pi * 2
        rotateReverseAnimation.toValue = 0.0
        rotateReverseAnimation.duration = 1
        rotateReverseAnimation.repeatCount = Float.infinity
        //rotateReverseAnimation.isAdditive = true
        rotateReverseAnimation.beginTime = 1
        
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 1.5
        scaleDown.toValue = 1
        scaleDown.duration = 1
        //scaleDown.isAdditive = true
        scaleDown.repeatCount = Float.infinity
        scaleDown.beginTime = 1
        
        let rotateAndScale = CAAnimationGroup()
        rotateAndScale.animations = [rotateAnimation, scaleUp,rotateReverseAnimation,scaleDown]
        rotateAndScale.duration = 2
        rotateAndScale.repeatCount = Float.infinity
        rotateAndScale.isRemovedOnCompletion = false
        
        
        // Setting key to "transform" overwrites the implicit animation created when setting the target values before the animation.
        self.layer.zPosition = 10000
        self.layer.add(rotateAndScale, forKey: "transform")
        
        
        //self.layer.add(rotateAnimation, forKey: nil)
    }

    func stopRotating(){
        self.layer.sublayers?.removeAll()
        //or
        self.layer.removeAllAnimations()
    }
}
