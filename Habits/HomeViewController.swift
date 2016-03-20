//
//  HomeViewController.swift
//  Habits
//
//  Created by Ken Yu on 3/9/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public
class HomeViewController: BaseViewController {
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonContainerView: UIView!
    
    // Class
    public static let kNibName = "HomeViewController"
    public static let kButtonHeight: CGFloat = 60
    public static let kBillTotal: Float = 200
    public static let kNumParticipants: Float = 4
    public static let kTitle = "Routine"
    
    // Public
    public var sliderCellModels: [[SwipeTableViewCellModel]] = []
    public var sectionHeaderCellModels: [BaseTableViewHeaderFooterViewModel] = []
    
    // Private
    private var maxCellLeft: CGFloat?
    private var kCellAnimation: NSTimeInterval = 0.2
    private var isEditing: Bool = false
    private var draggedCell: SwipeTableViewCell? = nil
    private var cellSwipeGesture: UIPanGestureRecognizer?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: HomeViewController.kNibName, bundle: nil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = HomeViewController.kTitle
        
        setupNavBar()
        createCellModels()
        setupStyles()
        setupTableView()
        setupAccessibility()
        
        login()
    }
    
    public func login() {
        NetworkManager.sharedInstance.getRequest("/token") { (response) -> Void in
            switch response.result {
            case .Success(let JSON):
                guard let token = JSON["token"] as? String else { return }
                print("token = \(token)")
            default:
                print("HELO")
            }
        }
    }
    
    public func setupNavBar() {
        let addButton = createAddButton()
        addRightBarButtons([addButton])
    }
    
    public override func add() {
        print("Tapped add")
        let createTaskViewController = CreateTaskViewController()
        createTaskViewController.createTaskViewControllerDelegate = self
        let navigationController = UINavigationController(rootViewController: createTaskViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    public func setupTableView() {
        registerCells()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.contentInset = UIEdgeInsetsMake(topBarHeight(), 0, HomeViewController.kButtonHeight, 0)
//        tableView.separatorStyle = .None
        tableView.reloadData()
    }
    
    public func createCellModels() {
        // TODO: Load from core data
        sliderCellModels = []
    }
    
    private func setupAccessibility() {
    }
    
    private func setupStyles() {
        buttonContainerView.backgroundColor = Styles.Colors.Gray
    }
    
    private func registerCells() {
        tableView.registerClass(BaseTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: BaseTableViewHeaderFooterView.kReuseIdentifier)
        tableView.registerNib(SwipeTableViewCell.nib, forCellReuseIdentifier: SwipeTableViewCell.reuseId)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sliderCellModels.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewModel = sliderCellModels[indexPath.section][indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier(SwipeTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? SwipeTableViewCell {
            cell.setup(viewModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sliderCellModels[section].count
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let viewModel = sliderCellModels[indexPath.section][indexPath.row]
        return SwipeTableViewCell.size(tableView.width, viewModel: viewModel).height
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? SwipeTableViewCell else { return }
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

extension HomeViewController: SwipeTableViewCellDelegate {
    public func didTapDeleteButton(cell: SwipeTableViewCell) {
        // Remove the cell
    }
}

extension HomeViewController: CreateTaskViewControllerDelegate {
    public func didTapDoneButton(exerciseName: String, exerciseSetCellModels: [ExerciseSetTableViewCellModel]) {
        var sectionCellModels: [SwipeTableViewCellModel] = []
        
        for exerciseSetCellModel in exerciseSetCellModels {
            guard let weight = exerciseSetCellModel.weight else { continue }
            guard let reps = exerciseSetCellModel.reps else { continue }
            let title = "Set \(exerciseSetCellModel.set) - \(weight) lbs x \(reps)"
            let cellModel = SwipeTableViewCellModel(title, current: 0, swipeMax: 1)
            sectionCellModels.append(cellModel)
        }
        
        let headerCellModel = BaseTableViewHeaderFooterViewModel(exerciseName)
        sectionHeaderCellModels.append(headerCellModel)
        sliderCellModels.append(sectionCellModels)
        tableView.reloadData()
    }
}