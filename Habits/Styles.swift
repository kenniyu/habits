//
//  Styles.swift
//  Habits
//
//  Created by Ken Yu on 3/9/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import UIKit

public class Styles {
    public class Fonts {
        class func avenirBoldFontWithSize(size: CGFloat) -> UIFont! {
            return UIFont(name: "AvenirNext-Bold", size: size)
        }
        class func avenirRegularFontWithSize(size: CGFloat) -> UIFont! {
            return UIFont(name: "AvenirNext-Regular", size: size)
        }
        class func avenirItalicFontWithSize(size: CGFloat) -> UIFont! {
            return UIFont(name: "AvenirNext-Italic", size: size)
        }
        class func avenirMediumFontWithSize(size: CGFloat) -> UIFont! {
            return UIFont(name: "AvenirNext-Medium", size: size)
        }
        class func avenirBookFontWithSize(size: CGFloat) -> UIFont! {
            return UIFont(name: "Avenir-Book", size: size)
        }
        
        static let StellarButton = Fonts.avenirMediumFontWithSize(16)
        
        // Table View Cells
        static let TableViewCellTitle = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        static let TableViewCellDetail = UIFont.systemFontOfSize(24)
    }
    
    public class Colors {
        static let Green = UIColor(red: 130/255.0, green: 192/255.0, blue: 88/255.0, alpha: 1)
        static let Red = UIColor(red: 225/255.0, green: 103/255.0, blue: 133/255.0, alpha: 1)
        static let Gray = UIColor(red: 48/255.0, green: 48/255.0, blue: 48/255.0, alpha: 1)
    }
    
    public class Dimensions {
        static let kItemSpacingDim1: CGFloat = 4
        static let kItemSpacingDim2: CGFloat = 8
        static let kItemSpacingDim3: CGFloat = 12
        static let kItemSpacingDim4: CGFloat = 16
        static let kItemSpacingDim5: CGFloat = 20
        static let kItemSpacingDim6: CGFloat = 24
        static let kItemSpacingDim7: CGFloat = 28
        static let kItemSpacingDim8: CGFloat = 32
        static let kItemSpacingDim9: CGFloat = 36
        static let kItemSpacingDim10: CGFloat = 40
        static let kItemSpacingDim11: CGFloat = 44
        static let kItemSpacingDim12: CGFloat = 48
        static let kItemSpacingDim13: CGFloat = 52
        static let kItemSpacingDim14: CGFloat = 56
        static let kItemSpacingDim15: CGFloat = 60
        static let kItemSpacingDim16: CGFloat = 64
        static let kItemSpacingDim17: CGFloat = 68
        static let kItemSpacingDim18: CGFloat = 72
        static let kItemSpacingDim19: CGFloat = 76
        static let kItemSpacingDim20: CGFloat = 80
        
        // Table View Cell
        static let TableViewCellContainerVerticalPadding = kItemSpacingDim5
        static let TableViewCellContainerHorizontalPadding = kItemSpacingDim5
        static let TableViewCellElementVerticalSpacing = kItemSpacingDim5
        static let TableViewCellElementHorizontalSpacing = kItemSpacingDim5
        
        static let SliderHeight = kItemSpacingDim8
    }
}