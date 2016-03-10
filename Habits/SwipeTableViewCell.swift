//
//  SwipeTableViewCell.swift
//  Habits
//
//  Created by Ken Yu on 3/9/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public protocol SwipeTableViewCellDelegate {
    func didTapDeleteButton(cell: SwipeTableViewCell)
}

public class SwipeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    public var viewModel: SwipeTableViewCellModel!
    public var swipeTableViewCellDelegate: SwipeTableViewCellDelegate?
    
    static let kFontColor = UIColor.blackColor()
    static let kAccessoryButtonWidth: CGFloat = 65
    static let kDeleteButtonWidthRatio: CGFloat = 0.25
    public static let kSliderHeight: CGFloat = Styles.Dimensions.SliderHeight
    
    
    public class var kReuseIdentifier: String {
        get {
            return "SwipeTableViewCell"
        }
    }
    
    public class var kClassName: String {
        get {
            return "SwipeTableViewCell"
        }
    }
    
    public class var kNib: UINib {
        get {
            return UINib(nibName: kClassName, bundle: NSBundle(forClass: SwipeTableViewCell.self))
        }
    }
    
    public class var nib: UINib {
        get {
            return SwipeTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return SwipeTableViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    public func setup(viewModel: SwipeTableViewCellModel) {
        self.viewModel = viewModel
        setupStyles(viewModel)
        
        loadDataIntoViews(viewModel)
    }
    
    public func setupStyles(viewModel: SwipeTableViewCellModel) {
        // Cell styles
        containerView.backgroundColor = UIColor.whiteColor()
        backgroundColor = UIColor.redColor()
        
        // Element styles
        titleLabel.font = SwipeTableViewCell.getTitleLabelFontStyle(viewModel)
        
        selectionStyle = .None
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // set cell container frame
        // containerView.frame = UIEdgeInsetsInsetRect(bounds, feedModel.style.cellContainerMargin)
        
        containerView.frame = bounds
        containerView.clipsToBounds = true
        
        mainView.frame = containerView.bounds
        backView.frame = containerView.bounds
        
        setSubviewFrames()
    }
    
    public func setSubviewFrames() {
        titleLabel.top = SwipeTableViewCell.getPaddingTop()
        titleLabel.left = SwipeTableViewCell.getPaddingLeft()
        titleLabel.height = SwipeTableViewCell.getTitleLabelHeight(containerView.width, viewModel: viewModel)
        titleLabel.width = SwipeTableViewCell.getContentWidth(containerView.width)
        
        deleteButton.height = backView.height
        deleteButton.width = containerView.width * SwipeTableViewCell.kDeleteButtonWidthRatio
        deleteButton.right = backView.right
        deleteButton.top = 0
        
    }
    
    public func loadDataIntoViews(viewModel: SwipeTableViewCellModel) {
        titleLabel.text = viewModel.title
    }
    
    public class func size(boundingWidth: CGFloat, viewModel: SwipeTableViewCellModel, constrainedWidthAdjustment: CGFloat = 0) -> CGSize {
        var cellHeight: CGFloat = 0
        
        // Padding top
        cellHeight += Styles.Dimensions.TableViewCellContainerVerticalPadding
        
        // Title Label
        let constrainedWidth = getContentWidth(boundingWidth) - constrainedWidthAdjustment
        let titleLabelHeight = getTitleLabelHeight(constrainedWidth, viewModel: viewModel, attributedText: getAttributedString(viewModel.title))
        cellHeight += titleLabelHeight
        
        cellHeight += getTitleBottomMargin()
        
        // Slider control height
        cellHeight += SwipeTableViewCell.kSliderHeight
        
        // Padding bottom
        cellHeight += Styles.Dimensions.TableViewCellContainerVerticalPadding
        return CGSizeMake(boundingWidth, cellHeight)
    }
    
    public class func getTitleLabelHeight(boundingWidth: CGFloat, viewModel: SwipeTableViewCellModel, attributedText: NSMutableAttributedString? = nil) -> CGFloat {
        let textHeight = TextUtils.textHeight(viewModel.title, font: getTitleLabelFontStyle(viewModel), boundingWidth: boundingWidth, numberOfLines: getTitleLabelNumberOfLines(), attributedText: attributedText)
        return textHeight
    }
    
    public class func getTitleLabelFontStyle(viewModel: SwipeTableViewCellModel) -> UIFont {
        return Styles.Fonts.TableViewCellTitle
    }
    
    public class func getDetailLabelFontStyle(viewModel: SwipeTableViewCellModel) -> UIFont {
        return Styles.Fonts.TableViewCellDetail
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
    
    @IBAction func tappedDeleteButton(sender: UIButton) {
        swipeTableViewCellDelegate?.didTapDeleteButton(self)
    }
}