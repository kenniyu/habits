//
//  CreateTaskViewController.swift
//  Habits
//
//  Created by Ken Yu on 3/13/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import UIKit
import Color_Picker_for_iOS

public protocol CreateTaskViewControllerDelegate {
    func didTapDoneButton(exerciseName: String, exerciseSetCellModels: [ExerciseSetTableViewCellModel])
}

public
class CreateTaskViewController: BaseViewController {
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // Class
    public static let kNibName = "CreateTaskViewController"
    public static let kTitle = "Create Exercise"
    
    // Public
    public var createTaskViewControllerDelegate: CreateTaskViewControllerDelegate?
    
    // Private
    private var cellModels: [ExerciseSetTableViewCellModel] = []
    private var tableHeaderView: CreateExerciseTableHeaderView?
    private var tableFooterView: CreateExerciseTableFooterView?
    private var exerciseName: String?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavBar()
        setupTableView()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: CreateTaskViewController.kNibName, bundle: nil)
    }
    
    public func setupTableView() {
        tableView.backgroundColor = Styles.Colors.LightGray
        // setup table header view
        setupTableHeaderView()
        // setup table footer view
        setupTableFooterView()
        
        registerCells()
        tableView.reloadData()
    }
    
    public func registerCells() {
        tableView.registerClass(CreateExerciseTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: CreateExerciseTableViewHeaderView.kReuseIdentifier)
        tableView.registerNib(ExerciseSetTableViewCell.nib, forCellReuseIdentifier: ExerciseSetTableViewCell.reuseId)
    }
    
    public func setupTableHeaderView() {
        tableHeaderView = CreateExerciseTableHeaderView(frame: CGRectMake(0, 0, tableView.width, CreateExerciseTableHeaderView.kHeight))
        tableHeaderView?.createExerciseTableHeaderViewDelegate = self
        guard let tableHeaderView = tableHeaderView else { return }
        tableView.tableHeaderView = tableHeaderView
    }
    
    public func setupTableFooterView() {
        tableFooterView = CreateExerciseTableFooterView(frame: CGRectMake(0, 0, tableView.width, CreateExerciseTableFooterView.kHeight))
        tableFooterView?.createExerciseTableFooterViewDelegate = self
        guard let tableFooterView = tableFooterView else { return }
        tableView.tableFooterView = tableFooterView
    }
    
    public func setupNavBar() {
        addCloseButton()
        
        let doneButton = createDoneButton()
        addRightBarButtons([doneButton])
        
        title = CreateTaskViewController.kTitle
    }
    
    public override func done() {
        guard let exerciseName = exerciseName where exerciseName != "" else { return }
        guard cellModels.count > 0 else { return }
        for cellModel in cellModels {
            guard let weight = cellModel.weight where weight > 0 else { return }
            guard let reps = cellModel.reps where reps > 0 else { return }
        }
        createTaskViewControllerDelegate?.didTapDoneButton(exerciseName, exerciseSetCellModels: cellModels)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateTaskViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if cellModels.count == 0 {
            return CGFloat.min
        }
        return CreateExerciseTableViewHeaderView.kSectionHeaderHeight
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewModel = cellModels[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier(ExerciseSetTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? ExerciseSetTableViewCell {
            cell.setup(viewModel)
            cell.exerciseSetTableViewCellDelegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let viewModel = cellModels[indexPath.row]
        return ExerciseSetTableViewCell.size(tableView.width, viewModel: viewModel).height
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let tableViewHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(CreateExerciseTableViewHeaderView.kReuseIdentifier) as? CreateExerciseTableViewHeaderView {
            tableViewHeaderView.setup()
            return tableViewHeaderView
        }
        return nil
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
}

extension CreateTaskViewController: ExerciseSetTableViewCellDelegate {
    public func weightDidChange(cell: ExerciseSetTableViewCell, weight: String) {
        guard let weight = Double(weight) else { return }
        guard let indexPath = tableView.indexPathForCell(cell) else { return }
        let cellModel = cellModels[indexPath.row]
        cellModel.weight = weight
    }
    
    public func repsDidChange(cell: ExerciseSetTableViewCell, reps: String) {
        guard let reps = Int(reps) else { return }
        guard let indexPath = tableView.indexPathForCell(cell) else { return }
        let cellModel = cellModels[indexPath.row]
        cellModel.reps = reps
    }
}

extension CreateTaskViewController: CreateExerciseTableFooterViewDelegate {
    public func didTapAddSetButton() {
        let newSetNumber = tableView.numberOfRowsInSection(0) + 1
        let newCellModel = ExerciseSetTableViewCellModel(newSetNumber, weight: 0, reps: 0)
        cellModels.append(newCellModel)
        tableView.reloadData()
        
        let newCellIndexPath = NSIndexPath(forRow: cellModels.count - 1, inSection: 0)
        if let cell = tableView.cellForRowAtIndexPath(newCellIndexPath) as? ExerciseSetTableViewCell {
            cell.weightTextField.becomeFirstResponder()
        }
    }
}

extension CreateTaskViewController: CreateExerciseTableHeaderViewDelegate {
    public func didChangeExerciseTextField(exerciseName: String) {
        self.exerciseName = exerciseName
    }
}

extension CreateTaskViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        view.endEditing(true)
    }
}