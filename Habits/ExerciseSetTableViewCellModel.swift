//
//  ExerciseSetTableViewCellModel.swift
//  Habits
//
//  Created by Ken Yu on 3/13/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import UIKit

public class ExerciseSetTableViewCellModel {
    var set: Int
    var weight: Double?
    var reps: Int?
    
    public init(_ set: Int, weight: Double?, reps: Int?) {
        self.set = set
        self.weight = weight
        self.reps = reps
    }
}