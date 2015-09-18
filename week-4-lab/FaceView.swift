//
//  FaceView.swift
//  week-4-lab
//
//  Created by Matt Hayes on 9/18/15.
//  Copyright © 2015 Mystery Command. All rights reserved.
//

import UIKit

class FaceView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var faceCenter: CGPoint!
    var faceTransform = CGAffineTransformIdentity
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        setup()
    }
    
    func setup() {
        setupGestures()
    }
    
    func setupGestures() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onPanGesture:")
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "onPinchGesture:")

        userInteractionEnabled = true
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(pinchGestureRecognizer)
    }
    
    func onPanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            faceCenter = center
            liftFace()
        case .Changed:
            let T = sender.translationInView(superview)
            center.x = faceCenter.x + T.x
            center.y = faceCenter.y + T.y
        case .Ended:
            dropFace()
        default:
            break
        }
    }
    
    func onPinchGesture(sender: UIPinchGestureRecognizer) {
        faceTransform = CGAffineTransformMakeScale(sender.scale, sender.scale)
        transform = faceTransform
    }
    
    func liftFace() {
        let animations = { () -> () in
            self.transform = CGAffineTransformScale(self.transform, 1.5, 1.5)
        }
        
        UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .CurveEaseIn,
            animations: animations,
            completion: nil
        )
    }
    
    func dropFace() {
        let animations = { () -> () in
            self.transform = self.faceTransform
        }
        
        UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .CurveEaseOut,
            animations: animations,
            completion: nil
        )
    }

}
