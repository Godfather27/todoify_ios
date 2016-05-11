//
//  ListViewController.swift
//  todoify
//
//  Created by Sebastian Huber on 30.03.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    // define UI constants
    let standardColor = UIColor(red: (25/355), green: (152/355), blue: (220/355), alpha: (100/100))
    let grayColor = UIColor(red: (250/355), green: (250/355), blue: (250/355), alpha: (250/100))
    let statusboxWidth = 5 as CGFloat
    let buttonSize = 30 as CGFloat
    let padding = 10 as CGFloat
    let labelPadding = 15 as CGFloat
    let labelHeight = 20 as CGFloat
    let borderWidth = 1 as CGFloat
    var buttonOuterBoundingSize : CGFloat!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonOuterBoundingSize = (buttonSize + padding)
    }
    
    func checkNetworkStatus()->Int{
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            return -1
        case .Online(.WWAN):
            return 1
        case .Online(.WiFi):
            return 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let infoButton = UIBarButtonItem(title: "Info", style: .Plain, target: self, action: #selector(ListViewController.navigateToImprint));
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(ListViewController.logout));
        
        self.navigationItem.leftBarButtonItem = logoutButton
        self.navigationItem.rightBarButtonItem = infoButton
        
        self.tableView.rowHeight = 59 as CGFloat
    }
    
    override func viewDidAppear(animated: Bool) {
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // if no internet connection create no table section
        if(checkNetworkStatus() != 1){
            return 0
        }
        return TaskList.singleton.allTasks.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if no internet connection create no table row
        if(checkNetworkStatus() != 1){
            return 0
        }
        return TaskList.singleton.allTasks[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(checkNetworkStatus() != 1){
            return ""
        }
        switch section {
        case 0:
            return "open"
        case 1:
            return "closed"
        case 2:
            return "archived"
        default:
            return "failure"
        }
    }
    
    // Helper functions in CreateCellComponents.swift
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath)
        // if no internet connection return empty cell
        if(checkNetworkStatus() != 1){
            return cell
        }
        // remove old objects from cell
        for cellElements in cell.subviews {
            cellElements.removeFromSuperview()
        }
        
        let statusBox = createStatusBox(cell, indexPath: indexPath)
        let bottomBorder = createBottomBorder(cell)
        // Add top border to first cell per section
        if(indexPath.row == 0){
            let topBorder = createTopBorder(cell)
            cell.layer.addSublayer(topBorder)
        }
        let titleLabel = createTitleLabel(cell, indexPath: indexPath)
        let dueLabel = createDueLabel(cell, indexPath: indexPath)
        // Archive Button only for open and done Tasks
        if(indexPath.section != 2){
            let archiveTask = createArchiveTask(cell, indexPath: indexPath)
            cell.addSubview(archiveTask)
        }
        let checkTask = createCheckTask(cell, indexPath: indexPath)
        
        // add views to cell
        cell.layer.addSublayer(statusBox)
        cell.layer.addSublayer(bottomBorder)
        cell.addSubview(checkTask)
        cell.addSubview(titleLabel)
        cell.addSubview(dueLabel)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier! == "showImprint"){
            return
        } else if (segue.identifier! == "logout"){
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            return
        }
        let dvc = segue.destinationViewController as! DetailViewController
        dvc.locationIndex = super.tableView.indexPathForCell( sender as!UITableViewCell)!.row
        dvc.sectionIndex = super.tableView.indexPathForCell( sender as!UITableViewCell)!.section
    }
}
