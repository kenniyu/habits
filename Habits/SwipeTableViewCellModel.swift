//
//  SwipeTableViewCellModel.swift
//  Habits
//
//  Created by Ken Yu on 3/9/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import UIKit

public class SwipeTableViewCellModel {
    var title: String
    var detail: String?
    var swipeMax: Int
    var current: Int = 0
    
    public init(_ title: String, detail: String? = nil, current: Int, swipeMax: Int) {
        self.title = title
        self.detail = detail
        self.current = current
        self.swipeMax = swipeMax
    }
    
    public func negative() {
        current -= 1
        current = max(0, current)
    }
    
    public func positive() {
        current += 1
        current = min(current, swipeMax)
    }
    
    public func getColor() -> UIColor {
        // for now, we're restricted to hues of 0 to 0.3        
        let percent = CGFloat(current)/CGFloat(max(1, swipeMax))
        return getColorFromPercent(percent)
    }
    
    public func getColorFromPercent(var percent: CGFloat) -> UIColor {
        if percent < 0 && current == 0 {
            percent = 0
        } else if percent > 0 && current == 1 {
            percent = 1
        } else if percent < 0 && current == 1 {
            percent = 1 + percent
        }
        
        let hue: CGFloat = 0.3
        let saturation: CGFloat = percent * 0.8
        let brightness: CGFloat = 0.985 - 0.15 * percent
        let alpha: CGFloat = 1
        
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        return color
    }
    
    public func getNextColor(positive: Bool) -> UIColor {
        var percent: CGFloat = 0
        if positive {
            percent = CGFloat(current + 1)/CGFloat(max(1, swipeMax))
        } else {
            percent = CGFloat(current - 1)/CGFloat(max(1, swipeMax))
        }
        return getColorFromPercent(percent)
    }
}