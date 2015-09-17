//
//  ViewController.swift
//  week-4-lab
//
//  Created by Matt Hayes on 9/16/15.
//  Copyright © 2015 Mystery Command. All rights reserved.
//

import UIKit

extension NSLayoutFormatOptions {
    static var None: NSLayoutFormatOptions {
        return NSLayoutFormatOptions(rawValue: 0)
    }
}

class Vfl {
    class func make(vfl: String, views: Dictionary<String, UIView>) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(vfl, options: .None, metrics: nil, views: views)
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
        
        let views = ["tray": trayView]
        view.addConstraints(Vfl.make("H:|[tray]|", views: views))
        view.addConstraints(Vfl.make("V:[tray]|", views: views))
        
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
        
        trayView.addConstraints(Vfl.make("H:|-(>=1)-[down]-(>=1)-|", views: subviews))
        trayView.addConstraints(Vfl.make("H:|-[dead]-(>=1)-[exci]-(>=1)-[sadI]-|", views: subviews))
        trayView.addConstraints(Vfl.make("H:|-[wink]-(>=1)-[happ]-(>=1)-[tong]-|", views: subviews))
        trayView.addConstraints(Vfl.make("V:|-[down]", views: subviews))
        trayView.addConstraints(Vfl.make("V:[down]-[dead]-[wink]-|", views: subviews))
        trayView.addConstraints(Vfl.make("V:[down]-[exci]-[happ]-|", views: subviews))
        trayView.addConstraints(Vfl.make("V:[down]-[sadI]-[tong]-|", views: subviews))
    }
    
    func onPanGesture(sender: UIPanGestureRecognizer) {
        let center = sender.translationInView(view)

        switch sender.state {
        case .Began:
            trayCenter = trayView.center
        case .Changed:
            trayView.center.y = trayCenter.y + center.y
        default:
            break
        }
    }

}

