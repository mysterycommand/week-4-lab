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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        print("init")
        setup()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        setup()
    }
    
    func setup() {
        print("setup")
        setupGestures()
    }
    
    func setupGestures() {
        print("setupGestures")
        userInteractionEnabled = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onPanGesture:")
        addGestureRecognizer(panGestureRecognizer)
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
    
    func liftFace() {
        let animations = { () -> () in
            self.transform = CGAffineTransformMakeScale(2.0, 2.0)
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
            self.transform = CGAffineTransformMakeScale(1.0, 1.0)
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
