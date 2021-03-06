//
//  LogInViewController.swift
//  Habits
//
//  Created by Ken Yu on 3/19/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public
class LogInViewController: BaseViewController {
    // IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    // Class
    public static let kNibName = "LogInViewController"
    public static let kViewPaddingBottom: CGFloat = 40

    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: LogInViewController.kNibName, bundle: nil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        checkSession()
        
        setup()
        setupGestureRecognizers()

        // Do any additional setup after loading the view.
    }
    
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedView:")
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setup() {
        keyboardDelegate = self
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = getScrollViewContentSize()
    }
    
    private func getScrollViewContentSize() -> CGSize {
        let height: CGFloat = logInButton.bottom + LogInViewController.kViewPaddingBottom
        return CGSizeMake(scrollView.width, height)
    }
    
    private func checkSession() {
        if SessionManager.sharedInstance.isLoggedIn() {
            LogInViewController.launchAppControllers(self)
        }
    }
    
    @IBAction func tappedLogIn(sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password  = passwordTextField.text else { return }
        
        SessionManager.sharedInstance.login(email, password: password, completion: { [weak self] (object) -> Void in
            guard let strongSelf = self else { return }
            if object.success {
                // Launch view controllers
                LogInViewController.launchAppControllers(strongSelf)
            } else {
                print(object.message)
            }
        })
    }
    
    public func tappedView(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    public class func launchAppControllers(viewController: LogInViewController) {
        let tabBarController = UITabBarController()
        
        let routinesViewController = RoutinesViewController()
        routinesViewController.title = RoutinesViewController.kTitle
        let routinesNavigationController = UINavigationController(rootViewController: routinesViewController)
        
        let settingsViewController = SettingsViewController()
        settingsViewController.title = SettingsViewController.kTitle
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        
        let controllers = [routinesNavigationController, settingsNavigationController]
        tabBarController.viewControllers = controllers
        
        viewController.presentViewController(tabBarController, animated: true, completion: nil)
    }
}

extension LogInViewController: KeyboardDelegate {
    public func keyboardWillShow(keyboardHeight: CGFloat, animationOptions: UIViewAnimationOptions, animationDuration: Double) {
        UIView.animateWithDuration(animationDuration, delay: 0, options: animationOptions, animations: { [weak self] () -> Void in
            guard let strongSelf = self else { return }
            strongSelf.scrollView.contentInset = UIEdgeInsetsMake(strongSelf.topBarHeight(), 0, keyboardHeight, 0)
            strongSelf.scrollView.setContentOffset(CGPointMake(0, strongSelf.topBarHeight()), animated: true)
        }, completion: nil)
    }
    
    public func keyboardWillHide(keyboardHeight: CGFloat, animationOptions: UIViewAnimationOptions, animationDuration: Double) {
        UIView.animateWithDuration(animationDuration, delay: 0, options: animationOptions, animations: { [weak self] () -> Void in
            guard let strongSelf = self else { return }
            strongSelf.scrollView.contentInset = UIEdgeInsetsMake(strongSelf.topBarHeight(), 0, 0, 0)
        }, completion: nil)
    }
}
