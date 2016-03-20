//
//  BaseTableViewHeaderFooterView.swift
//  Stellar
//
//  Created by Ken Yu on 1/16/16.
//  Copyright © 2016 Stellar. All rights reserved.
//

import Foundation
import UIKit

public class BaseTableViewHeaderFooterViewModel {
    var title: String
    
    public init(_ title: String) {
        self.title = title
    }
}

public
class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    public class var kNib: UINib {
        get {
            return UINib(nibName: kClassName, bundle: NSBundle(forClass: BaseTableViewHeaderFooterView.self))
        }
    }
    
    public class var kReuseIdentifier: String {
        get {
            return "BaseTableViewHeaderFooterView"
        }
    }
    
    public class var kClassName: String {
        get {
            return "BaseTableViewHeaderFooterView"
        }
    }
    
    public class var kSectionHeaderHeight: CGFloat {
        get {
            return 40
        }
    }
    
    public class var nib: UINib {
        get {
            return BaseTableViewHeaderFooterView.kNib
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
        let nib = UINib(nibName: "BaseTableViewHeaderFooterView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        view.backgroundColor = Styles.Colors.LightGray
        
        // Adjust bounds
        view.frame = self.bounds
        
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Add subview
        addSubview(self.view)
        
        layoutIfNeeded()
    }
    
//    public func setTitle(text: String) {
//        titleLabel.text = text.uppercaseString
//    }
    
    public func setup(viewModel: BaseTableViewHeaderFooterViewModel) {
//        titleLabel.font = BaseTableViewHeaderFooterView.kSectionHeaderFont
        titleLabel.text = viewModel.title.uppercaseString
    }
}
