//
//  SettingsViewController.swift
//  Habits
//
//  Created by Ken Yu on 3/19/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public enum SettingsCellModelKey {
    case Logout
}

public class SettingsCellModel {
    var key: SettingsCellModelKey
    var title: String!
    var detail: String!
    
    public init(key: SettingsCellModelKey, title: String, detail: String) {
        self.key = key
        self.title = title
        self.detail = detail
    }
}

public
class SettingsViewController: BaseViewController {
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // Class
    public static let kNibName = "SettingsViewController"
    public static let kTitle = "Settings"
    
    // Private
    private var cellModels: [SettingsCellModel] = []
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: SettingsViewController.kNibName, bundle: nil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavBar()
        registerCells()
        createCellModels()
        tableView.reloadData()
    }
    
    public func setupNavBar() {
        title = SettingsViewController.kTitle
    }
    
    private func createCellModels() {
        cellModels = [
            SettingsCellModel(key: .Logout, title: "Log Out", detail: "Log Out of Simple Weights")
        ]
    }
    
    public func registerCells() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellModel = cellModels[indexPath.row]
        switch cellModel.key {
        case .Logout:
            SessionManager.sharedInstance.logout({ [weak self] () -> Void in
                guard let strongSelf = self else { return }
                strongSelf.dismissViewControllerAnimated(true, completion: nil)
            })
        default:
            break
        }
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellModel = cellModels[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "UITableViewCell")
        }
        
        if let cell = cell {
            cell.textLabel?.text = cellModel.title
            cell.detailTextLabel?.text = cellModel.detail
            return cell
        }
        return UITableViewCell()
    }
}
