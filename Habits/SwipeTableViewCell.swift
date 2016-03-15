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
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    public var viewModel: SwipeTableViewCellModel!
    public var swipeTableViewCellDelegate: SwipeTableViewCellDelegate?
    
    static let kFontColor = UIColor.blackColor()
    static let kAccessoryButtonWidth: CGFloat = 65
    static let kActionThresholdDeltaX: CGFloat = 50.0
    static let kAnimationDuration: NSTimeInterval = 0.2
    static let kSpringDampingRatio: CGFloat = 0.15
    static let kSpringVelocity: CGFloat = 6
    
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
        
        // Element styles
        titleLabel.font = SwipeTableViewCell.getTitleLabelFontStyle(viewModel)
        
        selectionStyle = .None
        
        // Set alphas of both images to 0
        plusButton.alpha = 0
        minusButton.alpha = 0
        
        // Update background color
        updateBackground()
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
        
        plusButton.height = containerView.height/2
        plusButton.width = plusButton.height
        plusButton.center.y = containerView.height/2
        plusButton.left = titleLabel.left
        
        minusButton.height = containerView.height/2
        minusButton.width = minusButton.height
        minusButton.center.y = containerView.height/2
        minusButton.right = titleLabel.right
    }
    
    public func loadDataIntoViews(viewModel: SwipeTableViewCellModel) {
        updateTitle()
    }
    
    public func title() -> String {
        var title = viewModel.title
        
        if viewModel.swipeMax > 1 {
            let detail = " (\(viewModel.current)/\(viewModel.swipeMax))"
            title = title + detail
        }
        return title
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
    public func actionThresholdDeltaX() -> CGFloat {
        return plusButton.right + plusButton.left
    }
    
    public func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translationPoint = sender.translationInView(self)
        let translationX = translationPoint.x/2
        let deltaX = abs(translationX)
        mainView.left = translationX
        
        if sender.state == .Began || sender.state == .Changed {
            // Swiping
            updateImageViewAlphas(translationX)
            updateBackground(translationX)
        } else {
            // Only if we let go do we calculate the drag above threshold
            let didToggleAction = deltaX >= actionThresholdDeltaX()
            if didToggleAction {
                updateViewModel(translationX)
            }
            animateCell()
            updateCell()
        }
    }
    
    public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let velocity = swipeGesture?.velocityInView(mainView) else { return false }
        return fabs(velocity.x) > fabs(velocity.y)
    }
    
    public func updateViewModel(translationX: CGFloat) {
        if translationX < 0 {
            // We swiped left, negative
            viewModel.negative()
        } else {
            // Good habit, positive
            viewModel.positive()
        }
    }
    
    public func updateTitle() {
        titleLabel.text = title()
    }
    
    public func updateCell() {
        updateTitle()
        updateBackground()
    }
    
    public func updateBackground(translationX: CGFloat = 0) {
        if translationX < 0 {
            if abs(translationX) >= actionThresholdDeltaX() {
                mainView.backgroundColor = viewModel.getNextColor(false)
            } else {
                if translationX == 0 {
                    mainView.backgroundColor = viewModel.getColor()
                } else {
                    mainView.backgroundColor = viewModel.getColorFromPercent(getPercent(translationX))   
                }
            }
        } else {
            if abs(translationX) >= actionThresholdDeltaX() {
                mainView.backgroundColor = viewModel.getNextColor(true)
            } else {
                if translationX == 0 {
                    mainView.backgroundColor = viewModel.getColor()
                } else {
                    mainView.backgroundColor = viewModel.getColorFromPercent(getPercent(translationX))
                }
            }
        }
        
    }
    
    public func getPercent(translationX: CGFloat) -> CGFloat {
        if translationX < 0 {
            let minDomain: CGFloat = minusButton.left - 7 * plusButton.left
            let maxDomain: CGFloat = minusButton.right + plusButton.left
            let distDomain = maxDomain - minDomain
            return translationX / distDomain
        } else if translationX > 0 {
            let minDomain: CGFloat = 0
            let maxDomain: CGFloat = plusButton.right + 7 * plusButton.left
            let distDomain = maxDomain - minDomain
            return translationX / distDomain
        } else {
            return 0
        }
    }
    
    public func updateImageViewAlphas(translationX: CGFloat) {
        if translationX < 0 {
            var alpha = -1 * getPercent(translationX)
            if abs(translationX) >= actionThresholdDeltaX() {
                alpha = 1
            }
            minusButton.alpha = alpha
        } else if translationX > 0 {
            var alpha = getPercent(translationX)
            if abs(translationX) >= actionThresholdDeltaX() {
                alpha = 1
            }
            plusButton.alpha = alpha
        } else {
            plusButton.alpha = 0
            minusButton.alpha = 0
        }
    }
    
    public func animateCell() {
        UIView.animateWithDuration(SwipeTableViewCell.kAnimationDuration, delay: 0, usingSpringWithDamping: SwipeTableViewCell.kSpringDampingRatio, initialSpringVelocity: SwipeTableViewCell.kSpringVelocity, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.mainView.left = 0
            }) { (completed) -> Void in
                print("Completed")
        }
    }
}