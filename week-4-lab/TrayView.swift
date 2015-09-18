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
    
    var trayCenter = CGPoint(x: 0, y: 0)
    
    var faceCenter: CGPoint!
    var face: FaceView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        setupConstraints()
        setupGestures()
    }
    
    // MARK: - Constraints
    func setupConstraints() {
        downArrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))

        let allSubviews = [
            "down": downArrowImageView,
            "dead": deadImageView,
            "exci": excitedImageView,
            "sadI": sadImageView,
            "wink": winkImageView,
            "happ": happyImageView,
            "tong": tongueImageView,
        ]
        
        for (_, subview) in allSubviews {
            subview.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.userInteractionEnabled = true
            addSubview(subview)
        }
        
        addConstraints(Vfl.make("H:|-(>=1)-[down(==20)]-(>=1)-|", views: allSubviews))
        addConstraints(Vfl.make("H:|-20-[dead]-(>=1)-[exci]-(>=1)-[sadI]-20-|", views: allSubviews))
        addConstraints(Vfl.make("H:|-20-[wink]-(>=1)-[happ]-(>=1)-[tong]-20-|", views: allSubviews))
        addConstraints(Vfl.make("V:|-12-[down(==14)]", views: allSubviews))
        addConstraints(Vfl.make("V:[down]-12-[dead]-[wink]-52-|", views: allSubviews))
        addConstraints(Vfl.make("V:[down]-12-[exci]-[happ]-52-|", views: allSubviews))
        addConstraints(Vfl.make("V:[down]-12-[sadI]-[tong]-52-|", views: allSubviews))
        
        centerSubviews([
            downArrowImageView,
            excitedImageView,
            happyImageView,
        ])
    }
    
    func centerSubviews(centeredSubviews: [UIView]) {
        for subview in centeredSubviews {
            let centerConstraint = NSLayoutConstraint(
                item: subview,
                attribute: NSLayoutAttribute.CenterX,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: 1.0,
                constant: 0.0
            )
            
            addConstraint(centerConstraint)
        }
    }
    
    // MARK: - Gestures
    func setupGestures() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onPanGestureTray:")
        addGestureRecognizer(panGestureRecognizer)
        
        panSubviews([
            deadImageView,
            excitedImageView,
            sadImageView,
            winkImageView,
            happyImageView,
            tongueImageView,
        ])
    }
    
    func panSubviews(pannedSubviews: [UIImageView]) {
        for subview in pannedSubviews {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onPanGestureFace:")
            subview.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    func onPanGestureTray(sender: UIPanGestureRecognizer) {
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
            (V.y > 0) ? closeTray(V.y / bounds.height) : openTray(V.y / bounds.height)
        default:
            break
        }
    }
    
    func closeTray(vel: CGFloat) {
        let animations = { () -> () in
            if let superview = self.superview {
                self.center.y = superview.bounds.height + self.bounds.height / 2 - 34
                self.downArrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            }
        }
        
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
    
    func openTray(vel: CGFloat) {
        let animations = { () -> () in
            if let superview = self.superview {
                self.center.y = superview.bounds.height - self.bounds.height / 2 + 34
                self.downArrowImageView.transform = CGAffineTransformIdentity
            }
        }
        
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
    
    func onPanGestureFace(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            if let view = sender.view as? UIImageView {
                faceCenter = view.center
                faceCenter.y += self.frame.origin.y

                face = FaceView(image: view.image)
                face.center = faceCenter
                
                superview?.addSubview(face)
                closeTray(1.0)
            }
        case .Changed:
            let T = sender.translationInView(superview)
            face.center.x = faceCenter.x + T.x
            face.center.y = faceCenter.y + T.y
        default:
            break
        }
    }

}
