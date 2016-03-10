//
//  SwipeTableViewCell.swift
//  Habits
//
//  Created by Ken Yu on 3/9/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit
import pop

public protocol SwipeTableViewCellDelegate {
}

public class SwipeTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var minusImageView: UIImageView!
    
    public var viewModel: SwipeTableViewCellModel!
    public var swipeTableViewCellDelegate: SwipeTableViewCellDelegate?
    
    static let kFontColor = UIColor.blackColor()
    static let kAccessoryButtonWidth: CGFloat = 65
    static let kActionThresholdDeltaX: CGFloat = 50.0
    
    private var swipeGesture: UIPanGestureRecognizer?
    
    
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
        
        setupGestureRecognizers()
    }
    
    public func setupGestureRecognizers() {
        swipeGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        swipeGesture?.delegate = self
        if let gesture = swipeGesture {
            mainView.addGestureRecognizer(gesture)
        }
    }
    
    public func setupStyles(viewModel: SwipeTableViewCellModel) {
        // Cell styles
        containerView.backgroundColor = UIColor.whiteColor()
        backgroundColor = UIColor.redColor()
        
        // Element styles
        titleLabel.font = SwipeTableViewCell.getTitleLabelFontStyle(viewModel)
        
        selectionStyle = .None
        
        separatorInset = UIEdgeInsetsMake(0, SwipeTableViewCell.getPaddingLeft(), 0, 0)
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
        
        plusImageView.left = SwipeTableViewCell.getPaddingLeft()
        plusImageView.height = containerView.height/2
        plusImageView.width = plusImageView.height
        plusImageView.center.y = containerView.height/2
        
        minusImageView.right = containerView.width - SwipeTableViewCell.getPaddingRight()
        minusImageView.height = containerView.height/2
        minusImageView.width = plusImageView.height
        minusImageView.center.y = containerView.height/2
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
}

extension SwipeTableViewCell {
    public func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translationPoint = sender.translationInView(self)
        let translationX = translationPoint.x/2
        let deltaX = abs(translationX)
        mainView.left = translationX
        
        if sender.state == .Began || sender.state == .Changed {
            // Swiping
        } else {
            // Only if we let go do we calculate the drag above threshold
            let didToggleAction = deltaX > SwipeTableViewCell.kActionThresholdDeltaX
            print(didToggleAction)
            animateCell()
        }
    }
    
    public func animateCell() {
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 20.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.mainView.left = 0
            }) { (completed) -> Void in
                print("Completed")
        }
    }
}