//
//  QrCodeRotateAnimator.swift
//  QRChild
//
//  Created by Karapats on 20/06/ 15.
//  Copyright © 2018 Karapats. All rights reserved.
//

import Foundation
import UIKit

class QrCodeRotateAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var duration : TimeInterval
    var image: UIImage
    var backgroundColor: UIColor
    var imgSize:CGFloat
    
    init(duration : TimeInterval, image: UIImage, backgroundColor: UIColor,imgSize: CGFloat) {
        self.duration = duration
        self.image = image
        self.backgroundColor = backgroundColor
        self.imgSize = imgSize
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        //add backgroundView
        let backgroundView = UIView(frame: containerView.frame)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.alpha = 0
        containerView.addSubview(backgroundView)
        
        //add center corner image
        let centerImage = UIImageView()
        
        centerImage.frame.size.width = imgSize
        centerImage.frame.size.height = imgSize
        centerImage.center = fromVC.view.center
        centerImage.image = image
        centerImage.layer.cornerRadius = 10
        centerImage.layer.masksToBounds = true
        backgroundView.addSubview(centerImage)
        
        //add shapshot
     
        
        snapshot.frame.size.width = imgSize
        snapshot.frame.size.height = imgSize
        snapshot.center = fromVC.view.center
        snapshot.layer.cornerRadius = 10
        snapshot.layer.masksToBounds = true
        //snapshot.isHidden = true
        toVC.view.alpha = 0
        containerView.addSubview(toVC.view)
        backgroundView.addSubview(snapshot)
        
        //rotate destination shapshot
        AnimationHelper.perspectiveTransform(for: centerImage)
        AnimationHelper.perspectiveTransform(for: snapshot)
        snapshot.layer.transform = AnimationHelper.yRotation(-.pi/2)
        
        let duration = transitionDuration(using: transitionContext)
        
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                // 2
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/4) {
                    backgroundView.alpha = 1
                }
                
                UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 1/4) {
                    centerImage.layer.transform = AnimationHelper.yRotation(-.pi / 2)
                    
                }
                
                // 3
                UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4) {
                    snapshot.layer.transform = AnimationHelper.yRotation(0.0)
                }
                
                // 4
                UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
                    snapshot.frame = finalFrame
                    snapshot.layer.cornerRadius = 0
                    toVC.view.alpha = 1
                    fromVC.view.alpha = 0
                    
                }
        },
            // 5
            completion: { _ in
                toVC.view.isHidden = false
                fromVC.view.alpha = 1
                snapshot.removeFromSuperview()
                fromVC.view.layer.transform = CATransform3DIdentity
                //fromVC.dismiss(animated: false, completion: nil)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
        
        
    }
    
    
}
