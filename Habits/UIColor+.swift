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
        var hue: CGFloat = 0,
            saturation: CGFloat = 0,
            brightness: CGFloat = 0,
            alpha: CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: max(0, brightness - 0.1), alpha: alpha)
        }
        
        return self
    }
}