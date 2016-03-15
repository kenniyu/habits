//
//  BaseViewController.swift
//  Stellar
//
//  Created by Ken Yu on 12/30/15.
//  Copyright © 2015 Stellar. All rights reserved.
//

import UIKit
import Foundation

@objc
public protocol KeyboardDelegate {
    optional func keyboardWillShow(keyboardHeight: CGFloat, animationOptions: UIViewAnimationOptions, animationDuration: Double)
    optional func keyboardWillHide(keyboardHeight: CGFloat, animationOptions: UIViewAnimationOptions, animationDuration: Double)
    optional func keyboardDidShow(keyboardHeight: CGFloat, animationOptions: UIViewAnimationOptions, animationDuration: Double)
    optional func keyboardDidHide(keyboardHeight: CGFloat, animationOptions: UIViewAnimationOptions, animationDuration: Double)
}

public
class BaseViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    public var keyboardDelegate: KeyboardDelegate?
    public let kLeftBarButtonItemTitle = ""
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    public override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    public override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        return min(statusBarSize.width, statusBarSize.height)
    }
    
    public func navBarHeight() -> CGFloat {
        return navigationController?.navigationBar.height ?? 0
    }
    
    public func topBarHeight() -> CGFloat {
        return statusBarHeight() + navBarHeight()
    }
    
    public override func viewDidLayoutSubviews() {
        adjustTopBarSpacingConstraint()
    }
    
    public func adjustTopBarSpacingConstraint() {
        // Override by subclass
    }
    
    public func addCloseButton() {
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "closeVc")
        let leftBarButtonItems = [closeBtn]
        navigationItem.leftBarButtonItems = leftBarButtonItems
    }
    
    public func createDoneButton() -> UIBarButtonItem {
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done")
        return closeBtn
    }
    
    public func createAddButton() -> UIBarButtonItem {
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "add")
        return closeBtn
    }
    
    public func addRightBarButtons(buttons: [UIBarButtonItem]) {
        let rightBarButtonItems = buttons
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    public func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func add() {
        // TO BE OVERRIDDEN
    }
    
    public func closeVc() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// Keyboard delegate
extension BaseViewController {
    public func getKeyboardNotificationInfo(notification: NSNotification) -> (keyboardHeight: CGFloat, animationCurveOptions: UIViewAnimationOptions, animationDuration: Double)? {
        
        if let keyboardNotificationInfo = notification.userInfo,
            keyboardFrameInfo = keyboardNotificationInfo[UIKeyboardFrameBeginUserInfoKey],
            animationCurveInfo = keyboardNotificationInfo[UIKeyboardAnimationCurveUserInfoKey],
            animationDurationInfo = keyboardNotificationInfo[UIKeyboardAnimationDurationUserInfoKey],
            keyboardRect = (keyboardFrameInfo as? NSValue)?.CGRectValue(),
            animationDuration = animationDurationInfo.doubleValue {
                let animationOptions = UIViewAnimationOptions(rawValue:
                    UInt(animationCurveInfo.unsignedIntValue << 16))
                return (keyboardRect.height, animationOptions, animationDuration)
        }
        
        return nil
    }
    
    public func keyboardWillShow(notification: NSNotification) {
        guard let keyboardNotificationInfo = getKeyboardNotificationInfo(notification) else { return }
        
        keyboardDelegate?.keyboardWillShow?(
            keyboardNotificationInfo.keyboardHeight,
            animationOptions: keyboardNotificationInfo.animationCurveOptions,
            animationDuration: keyboardNotificationInfo.animationDuration)
    }
    
    public func keyboardWillHide(notification: NSNotification) {
        guard let keyboardNotificationInfo = getKeyboardNotificationInfo(notification) else { return }
        
        keyboardDelegate?.keyboardWillShow?(
            keyboardNotificationInfo.keyboardHeight,
            animationOptions: keyboardNotificationInfo.animationCurveOptions,
            animationDuration: keyboardNotificationInfo.animationDuration)
    }
}