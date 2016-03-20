//
//  Routine.swift
//  Habits
//
//  Created by Ken Yu on 3/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import ObjectMapper

public class Routine: Mappable {
    var _id: Int!
    var name: String!
    var exercises: [Exercise]!
    
    required public init?(_ map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        _id    <- map["id"]
        name         <- map["name"]
        exercises      <- map["exercises"]
    }
    
//    public func getDetails() {
//        guard let userId = SessionManager.sharedInstance.userId else { return }
//        let routineId = _id
//        let path = "/users/\(userId)/routines/\(routineId)"
//        NetworkManager.sharedInstance.getRequest(path) { (response) -> Void in
//            <#code#>
//        }
//    }
}