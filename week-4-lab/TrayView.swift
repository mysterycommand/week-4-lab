//
//  TrayView.swift
//  week-4-lab
//
//  Created by Matt Hayes on 9/18/15.
//  Copyright © 2015 Mystery Command. All rights reserved.
//

import UIKit

class TrayView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    let downArrowImageView = UIImageView(image: UIImage(named: "DownArrow"))
    
    let deadImageView = UIImageView(image: UIImage(named: "Dead"))
    let excitedImageView = UIImageView(image: UIImage(named: "Excited"))
    let sadImageView = UIImageView(image: UIImage(named: "Sad"))
    let winkImageView = UIImageView(image: UIImage(named: "Wink"))
    let happyImageView = UIImageView(image: UIImage(named: "Happy"))
    let tongueImageView = UIImageView(image: UIImage(named: "Tongue"))
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    var trayCenter = CGPoint(x: 0, y: 0)
    
    var closeImmediate: (() -> ())!
    var openImmediate: (() -> ())!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        closeImmediate = { () -> () in
            if let superview = self.superview {
                self.center.y = superview.bounds.height + self.bounds.height / 2 - 34
                self.downArrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            }
        }
        
        openImmediate = { () -> () in
            if let superview = self.superview {
                self.center.y = superview.bounds.height - self.bounds.height / 2 + 34
                self.downArrowImageView.transform = CGAffineTransformIdentity
            }
        }
        
        downArrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onPanGesture:")
        addGestureRecognizer(panGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let subviews = [
            "down": downArrowImageView,
            "dead": deadImageView,
            "exci": excitedImageView,
            "sadI": sadImageView,
            "wink": winkImageView,
            "happ": happyImageView,
            "tong": tongueImageView,
        ]
        
        for (_, subview) in subviews {
            subview.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
        
        let centeredSubviews = [
            downArrowImageView,
            excitedImageView,
            happyImageView,
        ]
        
        for centeredSubview in centeredSubviews {
            let centerConstraint = NSLayoutConstraint(
                item: centeredSubview,
                attribute: NSLayoutAttribute.CenterX,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: 1.0,
                constant: 0.0
            )
            
            addConstraint(centerConstraint)
        }
        
        addConstraints(Vfl.make("H:|-(>=1)-[down(==20)]-(>=1)-|", views: subviews))
        addConstraints(Vfl.make("H:|-20-[dead]-(>=1)-[exci]-(>=1)-[sadI]-20-|", views: subviews))
        addConstraints(Vfl.make("H:|-20-[wink]-(>=1)-[happ]-(>=1)-[tong]-20-|", views: subviews))
        addConstraints(Vfl.make("V:|-12-[down(==14)]", views: subviews))
        addConstraints(Vfl.make("V:[down]-12-[dead]-[wink]-52-|", views: subviews))
        addConstraints(Vfl.make("V:[down]-12-[exci]-[happ]-52-|", views: subviews))
        addConstraints(Vfl.make("V:[down]-12-[sadI]-[tong]-52-|", views: subviews))
    }
    
    func onPanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            trayCenter = self.center
        case .Changed:
            let L = sender.locationInView(superview)
            let T = sender.translationInView(superview)
            
            let trayY = trayCenter.y + T.y
            
            let trayBoundary = superview!.bounds.height - (bounds.height - 34)
            let trayTop = trayY - (bounds.height / 2)
            
            let flexY = trayBoundary + (bounds.height / 2) - ((1 - min(max(0, L.y / trayBoundary), 1)) * 34)
            
            center.y = trayTop < trayBoundary ? flexY : trayY
        case .Ended:
            let V = sender.velocityInView(superview)
            (V.y > 0) ? close(V.y / bounds.height) : open(V.y / bounds.height)
        default:
            break
        }
    }
    
    func close(vel: CGFloat) {
        let animations = closeImmediate
        
        UIView.animateWithDuration(
            0.35,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: vel,
            options: .CurveEaseInOut,
            animations: animations,
            completion: nil
        )
    }
    
    func open(vel: CGFloat) {
        let animations = openImmediate
        
        UIView.animateWithDuration(
            0.35,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: vel,
            options: .CurveEaseInOut,
            animations: animations,
            completion: nil
        )
    }

}
