//
//  ExerciseSet.swift
//  Habits
//
//  Created by Ken Yu on 3/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import ObjectMapper


public class ExerciseSet: Mappable {
    var _id: Int!
    var routineId: Int!
    var exerciseId: Int!
    var weight: Double!
    var reps: Int!
    
    required public init?(_ map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        _id    <- map["id"]
        routineId         <- map["routine_id"]
        exerciseId         <- map["exercise_id"]
        weight         <- (map["weight"], DoubleTransform())
        reps         <- map["reps"]
    }
}