//
//  ViewController.swift
//  week-4-lab
//
//  Created by Matt Hayes on 9/16/15.
//  Copyright © 2015 Mystery Command. All rights reserved.
//

import UIKit

class Vfl {
    class func make(vfl: String, views: Dictionary<String, UIView>) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(vfl, options: [], metrics: nil, views: views)
    }
}

class CanvasViewController: UIViewController {
    
    let trayView = UIView()

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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        trayView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        trayView.translatesAutoresizingMaskIntoConstraints = false
        trayView.backgroundColor = UIColor.grayColor()
        
        initTrayView()
        view.addSubview(trayView)
        
        closeImmediate = { () -> () in
            self.trayView.center.y = self.view.bounds.height + self.trayView.bounds.height / 2 - 34
            self.downArrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }
        
        openImmediate = { () -> () in
            self.trayView.center.y = self.view.bounds.height - self.trayView.bounds.height / 2 + 34
            self.downArrowImageView.transform = CGAffineTransformIdentity
        }

        let views = ["tray": trayView]
        view.addConstraints(Vfl.make("H:|[tray]|", views: views))
        view.addConstraint(NSLayoutConstraint(
            item: trayView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: -34.0
        ))
        self.downArrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onPanGesture:")
        trayView.addGestureRecognizer(panGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTrayView() {
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
            trayView.addSubview(subview)
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
                toItem: trayView,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: 1.0,
                constant: 0.0
            )
            
            trayView.addConstraint(centerConstraint)
        }
        
        trayView.addConstraints(Vfl.make("H:|-(>=1)-[down(==20)]-(>=1)-|", views: subviews))
        trayView.addConstraints(Vfl.make("H:|-20-[dead]-(>=1)-[exci]-(>=1)-[sadI]-20-|", views: subviews))
        trayView.addConstraints(Vfl.make("H:|-20-[wink]-(>=1)-[happ]-(>=1)-[tong]-20-|", views: subviews))
        trayView.addConstraints(Vfl.make("V:|-12-[down(==14)]", views: subviews))
        trayView.addConstraints(Vfl.make("V:[down]-12-[dead]-[wink]-52-|", views: subviews))
        trayView.addConstraints(Vfl.make("V:[down]-12-[exci]-[happ]-52-|", views: subviews))
        trayView.addConstraints(Vfl.make("V:[down]-12-[sadI]-[tong]-52-|", views: subviews))
    }
    
    func onPanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            trayCenter = trayView.center
        case .Changed:
            let L = sender.locationInView(view)
            let T = sender.translationInView(view)

            let trayY = trayCenter.y + T.y
            
            let trayBoundary = view.bounds.height - (trayView.bounds.height - 34)
            let trayTop = trayY - (trayView.bounds.height / 2)
            
            let flexY = trayBoundary + (trayView.bounds.height / 2) - ((1 - min(max(0, L.y / trayBoundary), 1)) * 34)

            trayView.center.y = trayTop < trayBoundary
                ? flexY
                : trayY
        case .Ended:
            let V = sender.velocityInView(view)
            (V.y > 0) ? close(V.y / trayView.bounds.height) : open(V.y / trayView.bounds.height)
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

