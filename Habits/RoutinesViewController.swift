//
//  RoutinesViewController.swift
//  Habits
//
//  Created by Ken Yu on 3/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit
import ObjectMapper

public
class RoutinesViewController: BaseViewController {
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // Class
    public static let kNibName = "RoutinesViewController"
    public static let kTitle = "Routines"
    
    // Private
    // Private
    private var cellModels: [BaseTableViewCellModel] = []
    private var routines: [Routine] = []
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: RoutinesViewController.kNibName, bundle: nil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavBar()
        setupTableView()
        fetchRoutines()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
        registerCells()
    }
    
    
    private func registerCells() {
        tableView.registerNib(BaseTableViewCell.kNib, forCellReuseIdentifier: BaseTableViewCell.kReuseIdentifier)
    }
    
    private func fetchRoutines() {
        guard let userId = SessionManager.sharedInstance.userId else { return }
        NetworkManager.sharedInstance.getRequest("/users/\(userId)/routines") { [weak self] (response) -> Void in
            guard let strongSelf = self else { return }
            
            switch response.result {
            case .Success(let JSON):
                strongSelf.routines = []
                
                guard let routines = JSON["routines"] as? [AnyObject] else { return }
                for routine in routines {
                    guard let routineModel = Mapper<Routine>().map(routine) else { continue }
                    strongSelf.routines.append(routineModel)
                }
            default:
                break
            }
            
            strongSelf.didFetchRoutines()
        }
    }
    
    private func didFetchRoutines() {
        updateCellModels()
        tableView.reloadData()
    }
    
    private func updateCellModels() {
        cellModels = []
        for routine in routines {
            let cellModel = BaseTableViewCellModel(routine.name)
            cellModels.append(cellModel)
        }
    }
    
    private func setupNavBar() {
        title = RoutinesViewController.kTitle
    }
    
    
    private func showRoutine(routine: Routine) {
        let routineViewController = RoutineViewController(routine: routine)
        navigationController?.pushViewController(routineViewController, animated: true)
    }
}

extension RoutinesViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let routine = routines[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        showRoutine(routine)
        
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
