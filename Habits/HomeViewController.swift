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
    public static let kTitle = "Habits"
    
    // Public
    public var sliderCellModels: [SwipeTableViewCellModel] = []
    
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
        
        createCellModels()
        setupStyles()
        setupTableView()
        setupAccessibility()
    }
    
    public func setupTableView() {
        registerCells()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.contentInset = UIEdgeInsetsMake(topBarHeight(), 0, HomeViewController.kButtonHeight, 0)
        tableView.separatorStyle = .None
        tableView.reloadData()
    }
    
    public func createCellModels() {
        let billAmount: Float = HomeViewController.kBillTotal
        let numParticipants: Float = HomeViewController.kNumParticipants
        sliderCellModels = [
            SwipeTableViewCellModel("Foo Bar", detail: "\(billAmount/numParticipants)", current: 10, habitMax: 20),
            SwipeTableViewCellModel("Herp Derp", detail: "\(billAmount/numParticipants)", current: 10, habitMax: 20),
            SwipeTableViewCellModel("Bar Baz", detail: "\(billAmount/numParticipants)", current: 10, habitMax: 20)
        ]
    }
    
    
    private func setupAccessibility() {
    }
    
    private func setupStyles() {
        buttonContainerView.backgroundColor = Styles.Colors.Gray
    }
    
    private func registerCells() {
        tableView.registerNib(SwipeTableViewCell.nib, forCellReuseIdentifier: SwipeTableViewCell.reuseId)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewModel = sliderCellModels[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier(SwipeTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? SwipeTableViewCell {
            cell.setup(viewModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sliderCellModels.count
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let viewModel = sliderCellModels[indexPath.row]
        return SwipeTableViewCell.size(tableView.width, viewModel: viewModel).height
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? SwipeTableViewCell else { return }
    }
}

extension HomeViewController: SwipeTableViewCellDelegate {
    public func didTapDeleteButton(cell: SwipeTableViewCell) {
        // Remove the cell
    }
}