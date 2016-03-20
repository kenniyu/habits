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
    // IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // Class
    public static let kNibName = "RoutineViewController"
    public static let kTitle = "Routine"

    // Private
    private var routine: Routine!
    private var cellModels: [[BaseTableViewCellModel]] = []
//    private var sliderCellModels: [[SwipeTableViewCellModel]] = []
    private var sectionHeaderCellModels: [BaseTableViewHeaderFooterViewModel] = []

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
        updateModels()
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
        registerCells()
    }
    
    
    private func registerCells() {
        tableView.registerClass(BaseTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: BaseTableViewHeaderFooterView.kReuseIdentifier)

        tableView.registerNib(BaseTableViewCell.kNib, forCellReuseIdentifier: BaseTableViewCell.kReuseIdentifier)
        tableView.registerNib(SwipeTableViewCell.nib, forCellReuseIdentifier: SwipeTableViewCell.reuseId)
    }
    
    private func updateModels() {
        // Cell Models
        cellModels = []
        for exercise in routine.exercises {
            var sectionModels: [BaseTableViewCellModel] = []
            for (index, set) in exercise.sets.enumerate() {
                let cellModel = BaseTableViewCellModel("Set \(index)")
                sectionModels.append(cellModel)
            }
            cellModels.append(sectionModels)
        }
        
        // Header models
        sectionHeaderCellModels = []
        for exercise in routine.exercises {
            let headerModel = BaseTableViewHeaderFooterViewModel(exercise.name)
            sectionHeaderCellModels.append(headerModel)
        }
    }
    
    private func setupNavBar() {
        title = routine.name
    }
}

extension RoutineViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cellModels.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewModel = cellModels[indexPath.section][indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier(BaseTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? BaseTableViewCell {
            cell.setup(viewModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels[section].count
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let viewModel = cellModels[indexPath.section][indexPath.row]
        return BaseTableViewCell.size(tableView.width, viewModel: viewModel).height
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? BaseTableViewCell else { return }
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(BaseTableViewHeaderFooterView.kReuseIdentifier) as? BaseTableViewHeaderFooterView {
            let sectionHeaderModel = sectionHeaderCellModels[section]
            headerView.setup(sectionHeaderModel)
            return headerView
        }
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return BaseTableViewHeaderFooterView.kSectionHeaderHeight
    }
}