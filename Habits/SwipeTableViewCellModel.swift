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
    var detail: String
    var habitMax: Int = 20
    var current: Int = 10
    
    public init(_ title: String, detail: String, current: Int, habitMax: Int) {
        self.title = title
        self.detail = detail
        self.current = current
        self.habitMax = habitMax
    }
    
    public func negativeReinforcement() {
        current -= 1
        habitMax += 1
        current = max(0, current)
    }
    
    public func positiveReinforcement() {
        current += 1
        if current > habitMax {
            habitMax = current
        }
    }
    
    public func getColor() -> UIColor {
        // for now, we're restricted to hues of 0 to 0.3        
        let percent = CGFloat(current)/CGFloat(max(1, habitMax))
        return getColorFromPercent(percent)
    }
    
    public func getColorFromPercent(percent: CGFloat) -> UIColor {
        let hue: CGFloat = 0.28 * percent
        let saturation: CGFloat = 0.6
        let brightness: CGFloat = 0.8
        let alpha: CGFloat = 1
        
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        return color
    }
    
    public func getNextColor(positive: Bool) -> UIColor {
        var percent: CGFloat = 0
        if positive {
            percent = CGFloat(current + 1)/CGFloat(max(1, habitMax))
        } else {
            percent = CGFloat(current - 1)/CGFloat(max(1, habitMax + 1))
        }
        return getColorFromPercent(percent)
    }
}