//
//  UIColor+.swift
//  Habits
//
//  Created by Ken Yu on 3/12/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    func lighter() -> UIColor {
        var r: CGFloat = 0,
            g: CGFloat = 0,
            b: CGFloat = 0,
            a: CGFloat = 0
        
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.2, 1.0), blue: min(b + 0.2, 1.0), alpha: a)
        }
        return self
    }
    
    func darker() -> UIColor {
        var r: CGFloat = 0,
            g: CGFloat = 0,
            b: CGFloat = 0,
            a: CGFloat = 0
        
        if getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        
        return self
    }
}