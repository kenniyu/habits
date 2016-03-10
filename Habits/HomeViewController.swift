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
        
        createCellModels()
        setupTableView()
        setupStyles()
        setupAccessibility()
        
        setupGestureRecognizers()
    }
    
    public func setupTableView() {
        registerCells()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.contentInset = UIEdgeInsetsMake(0, 0, HomeViewController.kButtonHeight, 0)
        tableView.reloadData()
    }
    
    public func createCellModels() {
        let billAmount: Float = HomeViewController.kBillTotal
        let numParticipants: Float = HomeViewController.kNumParticipants
        sliderCellModels = [
            SwipeTableViewCellModel("Foo Bar", detail: "\(billAmount/numParticipants)", percent: 1/numParticipants, max: billAmount),
            SwipeTableViewCellModel("Man Whore", detail: "\(billAmount/numParticipants)", percent: 1/numParticipants, max: billAmount),
            SwipeTableViewCellModel("Herp Derp", detail: "\(billAmount/numParticipants)", percent: 1/numParticipants, max: billAmount),
            SwipeTableViewCellModel("Bar Baz", detail: "\(billAmount/numParticipants)", percent: 1/numParticipants, max: billAmount)
        ]
    }
    
    public func setupGestureRecognizers() {
        cellSwipeGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        if let gesture = cellSwipeGesture {
            gesture.delegate = self
            view.addGestureRecognizer(gesture)
        }
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

extension HomeViewController: UIGestureRecognizerDelegate {
    public func handlePanGesture(sender: UIPanGestureRecognizer) {
        guard let selectedCellIndexPath = tableView.indexPathForRowAtPoint(sender.locationInView(sender.view)) else { return }
        guard let cell = tableView.cellForRowAtIndexPath(selectedCellIndexPath) as? SwipeTableViewCell else { return }
        
        if draggedCell == nil {
            draggedCell = cell
        } else if let draggedCell = draggedCell {
            if cell == draggedCell {
                // Dragged cell exists, and it matches our most recently set draggedCell
            } else {
                // If we drag to a point outside of current cell, disable swipe gesture
                animateCell(draggedCell, reveal: false)
                cellSwipeGesture?.enabled = false
                return
            }
        }
        
        maxCellLeft = maxCellLeft ?? -1 * cell.width * SwipeTableViewCell.kDeleteButtonWidthRatio
        
        let translationPoint = sender.translationInView(cell)
        // Move the view's center using the gesture
        let xPoint = translationPoint.x
        
        cell.mainView.left = translationPoint.x/2
        
        if sender.state == .Began || sender.state == .Changed {
            // Swiping
        } else {
            var isEdit = false
            if xPoint < maxCellLeft {
                isEdit = true
            }
            animateCell(cell, reveal: isEdit)
        }
    }
    
    public func animateCell(cell: SwipeTableViewCell, reveal: Bool) {
        UIView.animateWithDuration(kCellAnimation, animations: { () -> Void in
            if let maxCellLeft = self.maxCellLeft where reveal {
                cell.mainView.left = maxCellLeft
            } else {
                cell.mainView.left = 0
            }
            }) { (completed) -> Void in
                // Always enable swipe gesture after any cell stops animation
                self.draggedCell = nil
                self.cellSwipeGesture?.enabled = true
        }
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
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
            cell.swipeTableViewCellDelegate = self
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
        animateCell(cell, reveal: false)
    }
}

extension HomeViewController: SwipeTableViewCellDelegate {
    public func didTapDeleteButton(cell: SwipeTableViewCell) {
        animateCell(cell, reveal: false)
        // Remove the cell
    }
}