//
//  ViewController.swift
//  week-4-lab
//
//  Created by Matt Hayes on 9/16/15.
//  Copyright © 2015 Mystery Command. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    let trayView = TrayView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        trayView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        trayView.translatesAutoresizingMaskIntoConstraints = false
        trayView.backgroundColor = UIColor.grayColor()
        
        view.addSubview(trayView)

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

