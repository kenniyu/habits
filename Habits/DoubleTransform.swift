//
//  DoubleTransform.swift
//  Habits
//
//  Created by Ken Yu on 3/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import ObjectMapper
//public protocol TransformType {
//    typealias Object
//    typealias JSON
//    
//    func transformFromJSON(value: AnyObject?) -> Object?
//    func transformToJSON(value: Object?) -> JSON?
//}

public class DoubleTransform: TransformType {
    public typealias Object = Double
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> Object? {
        if let value = value as? String {
            return Double(value)
        }
        return nil
    }
    
    public func transformToJSON(value: Double?) -> JSON? {
        if let value = value {
            return "\(value)"
        }
        return nil
    }
}
