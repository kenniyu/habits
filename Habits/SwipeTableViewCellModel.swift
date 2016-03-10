//
//  SwipeTableViewCellModel.swift
//  Habits
//
//  Created by Ken Yu on 3/9/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation


public class SwipeTableViewCellModel {
    var title: String
    var detail: String
    var max: Float
    var percent: Float
    var isLocked: Bool = false
    var isEditMode: Bool = false
    
    var value: Float {
        get {
            return percent * max
        }
    }
    
    public init(_ title: String, detail: String, percent: Float, max: Float, isEditMode: Bool = false, isLocked: Bool = false) {
        self.title = title
        self.detail = detail
        self.percent = percent
        self.max = max
        self.isEditMode = isEditMode
        self.isLocked = isLocked
    }
    
    public func updatePercent(percent: Float) {
        self.percent = percent
        self.detail = "\(value)"
    }
}