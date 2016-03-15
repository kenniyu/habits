//
//  CreateExerciseTableViewHeaderView.swift
//  Habits
//
//  Created by Ken Yu on 3/14/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public
class CreateExerciseTableViewHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    public class var kNib: UINib {
        get {
            return UINib(nibName: kClassName, bundle: NSBundle(forClass: CreateExerciseTableViewHeaderView.self))
        }
    }
    
    public class var kReuseIdentifier: String {
        get {
            return "CreateExerciseTableViewHeaderView"
        }
    }
    
    public class var kClassName: String {
        get {
            return "CreateExerciseTableViewHeaderView"
        }
    }
    
    public class var kSectionHeaderHeight: CGFloat {
        get {
            return 24
        }
    }
    
    public class var nib: UINib {
        get {
            return CreateExerciseTableViewHeaderView.kNib
        }
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func commonInit() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CreateExerciseTableViewHeaderView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        view.backgroundColor = Styles.Colors.LightGray
        
        // Adjust bounds
        view.frame = self.bounds
        
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Add subview
        addSubview(self.view)
        
        layoutIfNeeded()
    }
    
    public func setup() {
    }
}
