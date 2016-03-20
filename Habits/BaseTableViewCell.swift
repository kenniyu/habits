//
//  BaseTableViewCell.swift
//  Habits
//
//  Created by Ken Yu on 3/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class BaseTableViewCellModel {
    var title: String
    var detail: String?
    var isLast: Bool
    
    public init(_ title: String, detail: String? = nil, isLast: Bool = false) {
        self.title = title
        self.detail = detail
        self.isLast = isLast
    }
}

public
class BaseTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel?
    @IBOutlet weak var containerView: UIView!
    
    public var dataModel: BaseTableViewCellModel!
    
    static let kFontColor = UIColor.blackColor()
    
    public class var kReuseIdentifier: String {
        get {
            return "BaseTableViewCell"
        }
    }
    
    public class var kClassName: String {
        get {
            return "BaseTableViewCell"
        }
    }
    
    public class var kNib: UINib {
        get {
            return UINib(nibName: kClassName, bundle: NSBundle(forClass: BaseTableViewCell.self))
        }
    }
    
    public class var nib: UINib {
        get {
            return BaseTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return BaseTableViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    public func setup(dataModel: BaseTableViewCellModel) {
        self.dataModel = dataModel
        setupStyles(dataModel)
        
        loadDataIntoViews(dataModel)
        toggleVisibilities()
    }
    
    public func setupStyles(dataModel: BaseTableViewCellModel) {
        // Cell styles
        self.contentView.backgroundColor = UIColor.clearColor()
        containerView.backgroundColor = UIColor.clearColor()
        backgroundColor = Styles.Colors.LightGray
        
        if dataModel.isLast {
            separatorInset = UIEdgeInsetsMake(0, containerView.width, 0, 0)
        } else {
            separatorInset = UIEdgeInsetsMake(0, Styles.Dimensions.kItemSpacingDim4, 0, 0)
        }
        
        // Element styles
        titleLabel.font = getTitleLabelFontStyle(dataModel)
        titleLabel.textColor = BaseTableViewCell.kFontColor
        detailLabel?.font = getDetailLabelFontStyle()
        detailLabel?.textColor = BaseTableViewCell.kFontColor
    }
    
    public func toggleVisibilities() {
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
        titleLabel.top = getPaddingTop()
        titleLabel.left = getPaddingLeft()
        titleLabel.width = getContentWidth(containerView.width)
        titleLabel.height = getTitleLabelHeight(titleLabel.width, viewModel: dataModel, attributedText: getAttributedTitleString(dataModel.title))
        
        if let detailLabel = detailLabel {
            detailLabel.top = titleLabel.bottom + Styles.Dimensions.TableViewCellElementVerticalSpacing
            detailLabel.left = titleLabel.left
            detailLabel.width = titleLabel.width
            detailLabel.height = getDetailLabelHeight(detailLabel.width, viewModel: dataModel, attributedText: getAttributedDetailString(dataModel.detail))
        }
    }
    
    public func loadDataIntoViews(viewModel: BaseTableViewCellModel) {
        if let attributedTitle = getAttributedTitleString(dataModel.title) {
            titleLabel.attributedText = attributedTitle
        } else {
            titleLabel.text = dataModel.title
        }
        
        if let detail = viewModel.detail {
            if let attributedDetail = getAttributedDetailString(dataModel.detail) {
                detailLabel?.attributedText = attributedDetail
            } else {
                detailLabel?.text = detail
            }
        }
    }
    
    public class func size(boundingWidth: CGFloat, viewModel: BaseTableViewCellModel, constrainedWidthAdjustment: CGFloat = 0) -> CGSize {
        var cellHeight: CGFloat = 0
        
        // Padding top
        cellHeight += getPaddingTop()
        
        // Title Label
        let constrainedWidth = getContentWidth(boundingWidth) - constrainedWidthAdjustment
        let titleLabelHeight = getTitleLabelHeight(constrainedWidth, viewModel: viewModel, attributedText: getAttributedTitleString(viewModel.title))
        cellHeight += titleLabelHeight
        
        // Detail Label
        if let _ = viewModel.detail {
            cellHeight += getTitleDetailSpacing()
            let detailLabelHeight = getDetailLabelHeight(constrainedWidth, viewModel: viewModel, attributedText: getAttributedDetailString(viewModel.detail))
            cellHeight += detailLabelHeight
        }
        
        // Padding bottom
        cellHeight += getPaddingBottom()
        return CGSizeMake(boundingWidth, cellHeight)
    }
    
    // MARK Instance-to-Class methods
    public func getTitleLabelHeight(boundingWidth: CGFloat, viewModel: BaseTableViewCellModel, attributedText: NSMutableAttributedString? = nil) -> CGFloat {
        return self.dynamicType.getTitleLabelHeight(boundingWidth, viewModel: viewModel, attributedText: attributedText)
    }
    
    public func getDetailLabelHeight(boundingWidth: CGFloat, viewModel: BaseTableViewCellModel, attributedText: NSMutableAttributedString? = nil) -> CGFloat {
        return self.dynamicType.getDetailLabelHeight(boundingWidth, viewModel: viewModel, attributedText: attributedText)
    }
    
    public func getTitleLabelFontStyle(viewModel: BaseTableViewCellModel) -> UIFont {
        return self.dynamicType.getTitleLabelFontStyle(viewModel)
    }
    
    public func getDetailLabelFontStyle() -> UIFont {
        return self.dynamicType.getDetailLabelFontStyle()
    }
    
    public func getPaddingTop() -> CGFloat {
        return self.dynamicType.getPaddingTop()
    }
    
    public func getPaddingBottom() -> CGFloat {
        return self.dynamicType.getPaddingBottom()
    }
    
    public func getPaddingLeft() -> CGFloat {
        return self.dynamicType.getPaddingLeft()
    }
    
    public func getPaddingRight() -> CGFloat {
        return self.dynamicType.getPaddingLeft()
    }
    
    public func getTitleDetailSpacing() -> CGFloat {
        return self.dynamicType.getTitleDetailSpacing()
    }
    
    public func getContentWidth(containerWidth: CGFloat) -> CGFloat {
        return self.dynamicType.getContentWidth(containerWidth)
    }
    
    public func getAttributedTitleString(text: String?) -> NSMutableAttributedString? {
        return self.dynamicType.getAttributedTitleString(text)
    }
    
    public func getAttributedDetailString(text: String?) -> NSMutableAttributedString? {
        return self.dynamicType.getAttributedDetailString(text)
    }
    
    public func getLineHeight() -> CGFloat {
        return self.dynamicType.getLineHeight()
    }
    
    
    
    // MARK Class Methods
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
    
    public class func getContentWidth(containerWidth: CGFloat) -> CGFloat {
        return containerWidth - getPaddingLeft() - getPaddingRight()
    }
    
    public class func getTitleDetailSpacing() -> CGFloat {
        return Styles.Dimensions.kItemSpacingDim2
    }
    
    public class func getTitleLabelFontStyle(viewModel: BaseTableViewCellModel) -> UIFont {
        return Styles.Fonts.TableViewCellTitle
    }
    
    public class func getDetailLabelFontStyle() -> UIFont {
        return Styles.Fonts.TableViewCellDetail
    }
    
    public class func getTitleLabelNumberOfLines() -> Int {
        return 0
    }
    
    public class func getDetailLabelNumberOfLines() -> Int {
        return 0
    }
    
    public class func getAttributedTitleString(text: String?) -> NSMutableAttributedString? {
        // TODO: To be implemented by subclass if needed
        return nil
    }
    
    public class func getAttributedDetailString(text: String?) -> NSMutableAttributedString? {
        // TODO: To be implemented by subclass if needed
        return nil
    }
    
    public class func getLineHeight() -> CGFloat {
        return 0
    }
    
    public class func getTitleLabelHeight(boundingWidth: CGFloat, viewModel: BaseTableViewCellModel, attributedText: NSMutableAttributedString? = nil) -> CGFloat {
        let textHeight = TextUtils.textHeight(viewModel.title, font: getTitleLabelFontStyle(viewModel), boundingWidth: boundingWidth, numberOfLines: getTitleLabelNumberOfLines(), attributedText: attributedText)
        return textHeight
    }
    
    public class func getDetailLabelHeight(boundingWidth: CGFloat, viewModel: BaseTableViewCellModel, attributedText: NSMutableAttributedString? = nil) -> CGFloat {
        guard let detail = viewModel.detail else { return 0 }
        let textHeight = TextUtils.textHeight(detail, font: getDetailLabelFontStyle(), boundingWidth: boundingWidth, numberOfLines: getDetailLabelNumberOfLines(), attributedText: attributedText)
        return textHeight
    }
}

