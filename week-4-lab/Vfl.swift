//
//  Vfl.swift
//  week-4-lab
//
//  Created by Matt Hayes on 9/18/15.
//  Copyright © 2015 Mystery Command. All rights reserved.
//

import UIKit

class Vfl {
    class func make(vfl: String, views: Dictionary<String, UIView>) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(vfl, options: [], metrics: nil, views: views)
    }
}