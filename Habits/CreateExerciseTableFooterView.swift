//
//  CreateExerciseTableFooterView.swift
//  Habits
//
//  Created by Ken Yu on 3/14/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import UIKit

public protocol CreateExerciseTableFooterViewDelegate {
    func didTapAddSetButton()
}

public
class CreateExerciseTableFooterView: UIView {
    // IBOutlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var addExerciseButton: UIButton!
    
    // Class
    public static let kHeight: CGFloat = 64
    public static let kNibName = "CreateExerciseTableFooterView"
    
    // Public
    public var createExerciseTableFooterViewDelegate: CreateExerciseTableFooterViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    public func commonInit() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: CreateExerciseTableFooterView.kNibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        view.backgroundColor = UIColor.clearColor()
        
        // Adjust bounds
        view.frame = self.bounds
        
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Add subview
        addSubview(self.view)
        
        layoutIfNeeded()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setup() {
        setupAccessibility()
    }
    
    @IBAction func tappedAddSetButton(sender: UIButton) {
        createExerciseTableFooterViewDelegate?.didTapAddSetButton()
    }
    
    public func setupAccessibility() {
        
    }
}