//
//  Exercise.swift
//  Habits
//
//  Created by Ken Yu on 3/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import ObjectMapper


public class Exercise: Mappable {
    var _id: Int!
    var name: String!
    var sets: [ExerciseSet]!
    
    required public init?(_ map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        _id    <- map["id"]
        name         <- map["name"]
        sets       <- map["sets"]
    }
}