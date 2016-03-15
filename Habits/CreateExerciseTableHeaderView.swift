//
//  CreateExerciseTableHeaderView.swift
//  Habits
//
//  Created by Ken Yu on 3/14/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import UIKit

public protocol CreateExerciseTableHeaderViewDelegate {
    func didChangeExerciseTextField(exerciseName: String)
}

public
class CreateExerciseTableHeaderView: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseTextField: UITextField!
    
    public static let kHeight: CGFloat = 64
    public static let kNibName = "CreateExerciseTableHeaderView"
    
    // Public
    public var createExerciseTableHeaderViewDelegate: CreateExerciseTableHeaderViewDelegate?
    
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
        let nib = UINib(nibName: "CreateExerciseTableHeaderView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        view.backgroundColor = UIColor.whiteColor()
        
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
    
    public func setupAccessibility() {
        
    }
    
    @IBAction func exerciseTextFieldDidChange(sender: UITextField) {
        guard let text = sender.text else { return }
        createExerciseTableHeaderViewDelegate?.didChangeExerciseTextField(text)
    }
    
    @IBAction func exerciseTextFieldDidReturn(sender: UITextField) {
        exerciseTextField.resignFirstResponder()
    }
}