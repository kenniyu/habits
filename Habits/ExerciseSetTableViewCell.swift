//
//  ExerciseSetTableViewCell.swift
//  Habits
//
//  Created by Ken Yu on 3/13/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public protocol ExerciseSetTableViewCellDelegate {
    func weightDidChange(cell: ExerciseSetTableViewCell, weight: String)
    func repsDidChange(cell: ExerciseSetTableViewCell, reps: String)
}

public
class ExerciseSetTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    
    public var viewModel: ExerciseSetTableViewCellModel!
    public var exerciseSetTableViewCellDelegate: ExerciseSetTableViewCellDelegate?
    
    public class var kReuseIdentifier: String {
        get {
            return "ExerciseSetTableViewCell"
        }
    }
    
    public class var kClassName: String {
        get {
            return "ExerciseSetTableViewCell"
        }
    }
    
    public class var kNib: UINib {
        get {
            return UINib(nibName: kClassName, bundle: NSBundle(forClass: ExerciseSetTableViewCell.self))
        }
    }
    
    public class var nib: UINib {
        get {
            return ExerciseSetTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return ExerciseSetTableViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    public func setup(viewModel: ExerciseSetTableViewCellModel) {
        self.viewModel = viewModel
        setupStyles(viewModel)
        
        loadDataIntoViews(viewModel)
        
    }
    
    public func setupStyles(viewModel: ExerciseSetTableViewCellModel) {
        // Cell styles
        containerView.backgroundColor = UIColor.whiteColor()
        
        // Element styles
//        titleLabel.font = ExerciseSetTableViewCell.getTitleLabelFontStyle(viewModel)
        
        selectionStyle = .None
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // set cell container frame
        // containerView.frame = UIEdgeInsetsInsetRect(bounds, feedModel.style.cellContainerMargin)
        
        containerView.frame = bounds
        containerView.clipsToBounds = true
        
        setSubviewFrames()
    }
    
    public func setSubviewFrames() {
        setsTextField.width = ExerciseSetTableViewCell.getContentWidth(containerView.width)/3
        weightTextField.width = setsTextField.width
        repsTextField.width = weightTextField.width
        
        setsTextField.left = ExerciseSetTableViewCell.getPaddingLeft()
        weightTextField.left = setsTextField.right
        repsTextField.left = weightTextField.right
        
        setsTextField.height = Styles.Dimensions.TextFieldHeight
        weightTextField.height = setsTextField.height
        repsTextField.height = weightTextField.height
        
        setsTextField.top = ExerciseSetTableViewCell.getPaddingTop()
        weightTextField.top = setsTextField.top
        repsTextField.top = weightTextField.top
    }
    
    public func loadDataIntoViews(viewModel: ExerciseSetTableViewCellModel) {
        setsTextField.text = String(viewModel.set)
        
        if let weight = viewModel.weight where weight > 0 {
            weightTextField.text = String(weight)
        }
        
        if let reps = viewModel.reps where reps > 0 {
            repsTextField.text = String(reps)
        }
    }
    
    public class func size(boundingWidth: CGFloat, viewModel: ExerciseSetTableViewCellModel, constrainedWidthAdjustment: CGFloat = 0) -> CGSize {
        var cellHeight: CGFloat = 0
        
        // Padding top
        cellHeight += ExerciseSetTableViewCell.getPaddingTop()
        
        // Title Label
        cellHeight += Styles.Dimensions.TextFieldHeight
        
        // Padding bottom
        cellHeight += ExerciseSetTableViewCell.getPaddingBottom()
        return CGSizeMake(boundingWidth, cellHeight)
    }
    
    public class func getContentWidth(containerWidth: CGFloat) -> CGFloat {
        return containerWidth - getPaddingLeft() - getPaddingRight()
    }
    
    public class func getPaddingTop() -> CGFloat {
        return Styles.Dimensions.TableViewCellContainerVerticalPadding
    }
    
    public class func getPaddingBottom() -> CGFloat {
        return Styles.Dimensions.TableViewCellContainerVerticalPadding
    }
    
    public class func getPaddingLeft() -> CGFloat {
        return Styles.Dimensions.TableViewCellContainerHorizontalPadding
    }
    
    public class func getPaddingRight() -> CGFloat {
        return Styles.Dimensions.TableViewCellContainerHorizontalPadding
    }
    
    public class func getTitleLabelNumberOfLines() -> Int {
        return 0
    }
    
    public class func getAttributedString(text: String?) -> NSMutableAttributedString? {
        // TODO: To be implemented by subclass if needed
        return nil
    }
    
    public class func getTitleBottomMargin() -> CGFloat {
        return Styles.Dimensions.kItemSpacingDim4
    }
}

extension ExerciseSetTableViewCell {
    
    @IBAction func didChangeWeightTextField(sender: UITextField) {
        guard let text = sender.text else { return }
        exerciseSetTableViewCellDelegate?.weightDidChange(self, weight: text)
    }
    
    @IBAction func didChangeRepsTextField(sender: UITextField) {
        guard let text = sender.text else { return }
        exerciseSetTableViewCellDelegate?.repsDidChange(self, reps: text)
    }
}