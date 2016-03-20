//
//  RoutineViewController.swift
//  Habits
//
//  Created by Ken Yu on 3/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public
class RoutineViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    public static let kNibName = "RoutineViewController"
    public static let kTitle = "Routine"

    private var routine: Routine!
    private var cellModels: [BaseTableViewCellModel] = []

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init(routine: Routine) {
        self.init(nibName: RoutineViewController.kNibName, bundle: nil)
        self.routine = routine
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavBar()
        setupTableView()
        updateCellModels()
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
        registerCells()
    }
    
    
    private func registerCells() {
        tableView.registerNib(BaseTableViewCell.kNib, forCellReuseIdentifier: BaseTableViewCell.kReuseIdentifier)
    }
    
    private func updateCellModels() {
        cellModels = []
        for exercise in routine.exercises {
            let cellModel = BaseTableViewCellModel(exercise.name)
            cellModels.append(cellModel)
        }
    }
    
    private func setupNavBar() {
        title = routine.name
    }
}

extension RoutineViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellModel = cellModels[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier(BaseTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? BaseTableViewCell {
            cell.setup(cellModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellModel = cellModels[indexPath.row]
        return BaseTableViewCell.size(tableView.width, viewModel: cellModel).height
    }
}