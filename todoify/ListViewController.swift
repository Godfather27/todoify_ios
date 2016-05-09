//
//  ListViewController.swift
//  todoify
//
//  Created by Sebastian Huber on 30.03.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    func checkTask(sender: UIBarButtonItem) {
        TaskList.singleton.updateStatus(sender.tag, mode: true)
        TaskList.singleton.onLoadedData(){
            if(!NSThread.isMainThread()) {
                self.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: false)
            }
            else {
                self.tableView.reloadData();
            }
        }
    }
    
    func archiveTask(sender: UIBarButtonItem) {
        TaskList.singleton.updateStatus(sender.tag, mode: false)
    }
    
    func showInfo(sender: UIBarButtonItem) {
    }
    
    func navigateToImprint(sender: UIBarButtonItem) {
        navigationController!.pushViewController(storyboard!.instantiateViewControllerWithIdentifier("ImprintController") as UIViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let infoButton = UIBarButtonItem(title: "Info", style: .Plain, target: self, action: #selector(ListViewController.navigateToImprint));
        
        self.navigationItem.rightBarButtonItem = infoButton;
        
        self.tableView.rowHeight = 59 as CGFloat
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if(defaults.stringForKey("token") == nil){
            TaskList.singleton.onLoadedUser(){
                TaskList.singleton.onLoadedData(){
                    if(!NSThread.isMainThread()) {
                        self.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: false)
                    }
                    else {
                        self.tableView.reloadData();
                    }
                }
            }
        } else {
            TaskList.singleton.setUser()
            TaskList.singleton.onLoadedData(){
                if(!NSThread.isMainThread()) {
                    self.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: false)
                }
                else {
                    self.tableView.reloadData();
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TaskList.singleton.allTasks.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskList.singleton.allTasks[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "open"
        case 1:
            return "closed"
        case 2:
            return "archived"
        default:
            return "magic"
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath)
            
        // remove old objects from cell
        for cellElements in cell.subviews {
            cellElements.removeFromSuperview()
        }
        
        // define UI constants
        let standardColor = UIColor(red: (25/355), green: (152/355), blue: (220/355), alpha: (100/100))
        let grayColor = UIColor(red: (250/355), green: (250/355), blue: (250/355), alpha: (250/100))
        let statusboxWidth = 5 as CGFloat
        let buttonSize = 40 as CGFloat
        let padding = 10 as CGFloat
        let buttonOuterBoundingSize = (buttonSize + padding)
        let labelPadding = 15 as CGFloat
        let labelHeight = 20 as CGFloat
        let borderWidth = 1 as CGFloat
        
        // displays status of task (overdue, open, done/archived)
        let statusBox = CALayer()
        if(TaskList.singleton.allTasks[indexPath.section][indexPath.row].status == "closed" || TaskList.singleton.allTasks[indexPath.section][indexPath.row].status == "archived"){
            statusBox.borderColor = grayColor.CGColor
        } else {
            statusBox.borderColor = standardColor.CGColor
        }
        statusBox.frame = CGRect(x: 0, y: 0, width: statusboxWidth, height: cell.frame.size.height)
        statusBox.borderWidth = statusboxWidth
        
        let bottomBorder = CALayer()
        bottomBorder.borderColor = grayColor.CGColor
        bottomBorder.frame = CGRect(x: labelPadding, y: cell.frame.size.height - borderWidth, width: cell.frame.size.width - labelPadding, height: borderWidth)
        bottomBorder.borderWidth = borderWidth
        
        if(indexPath.row == 0){
            let topBorder = CALayer()
            topBorder.borderColor = grayColor.CGColor
            topBorder.frame = CGRect(x: labelPadding, y: 0, width: cell.frame.size.width - labelPadding, height: borderWidth)
            topBorder.borderWidth = borderWidth
            cell.layer.addSublayer(topBorder)
        }
        
        // shows title of task
        let titleLabel = UILabel(frame: CGRectMake(labelPadding, padding,(cell.frame.size.width - (3 * buttonOuterBoundingSize + labelPadding + padding)), labelHeight))
        titleLabel.textColor = UIColor.blackColor()
        if(TaskList.singleton.allTasks[indexPath.section][indexPath.row].status == "closed"){
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: TaskList.singleton.allTasks[indexPath.section][indexPath.row].title!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
        } else {
            titleLabel.text = TaskList.singleton.allTasks[indexPath.section][indexPath.row].title
        }
        titleLabel.font = UIFont.systemFontOfSize(17.0)
        
        // shows duedate of task
        let dueLabel = UILabel(frame: CGRectMake(labelPadding, padding + labelHeight,(cell.frame.size.width - (3 * buttonOuterBoundingSize + labelPadding + padding)), labelHeight))
        dueLabel.text = TaskList.singleton.allTasks[indexPath.section][indexPath.row].due
        dueLabel.textColor = UIColor.grayColor()
        dueLabel.font = UIFont.systemFontOfSize(12.0)
        
        // Buttons for marking tasks as done, archived and viewing task details
        let infoTask = UIButton(type: .Custom)
        infoTask.setImage(UIImage(named: "detail_task.png"), forState: UIControlState.Normal)
        infoTask.frame = CGRectMake((cell.frame.size.width - buttonOuterBoundingSize), cell.frame.size.height/2 - buttonSize/2, buttonSize, buttonSize)
        infoTask.tag = -1
        infoTask.addTarget(self, action: #selector(ListViewController.showInfo), forControlEvents: UIControlEvents.TouchDown)
        
        let archiveTask = UIButton(type: .Custom)
        archiveTask.setImage(UIImage(named: "archive_task.png"), forState: UIControlState.Normal)
        archiveTask.frame = CGRectMake((cell.frame.size.width - 2 * buttonOuterBoundingSize), cell.frame.size.height/2 - buttonSize/2, buttonSize, buttonSize)
        archiveTask.tag = TaskList.singleton.allTasks[indexPath.section][indexPath.row].id!
        archiveTask.addTarget(self, action: #selector(ListViewController.archiveTask), forControlEvents: UIControlEvents.TouchDown)
        
        let checkTask = UIButton(type: .Custom)
        checkTask.setImage(UIImage(named: "check_task.png"), forState: UIControlState.Normal)
        checkTask.frame = CGRectMake((cell.frame.size.width - 3 * buttonOuterBoundingSize), cell.frame.size.height/2 - buttonSize/2, buttonSize, buttonSize)
        checkTask.tag = TaskList.singleton.allTasks[indexPath.section][indexPath.row].id!
        checkTask.addTarget(self, action: #selector(ListViewController.checkTask), forControlEvents: UIControlEvents.TouchDown)
        
        // add views to cell
        cell.layer.addSublayer(statusBox)
        cell.layer.addSublayer(bottomBorder)
        cell.addSubview(infoTask)
        cell.addSubview(archiveTask)
        cell.addSubview(checkTask)
        cell.addSubview(titleLabel)
        cell.addSubview(dueLabel)
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dvc = segue.destinationViewController as! DetailViewController
        dvc.locationIndex = super.tableView.indexPathForCell( sender as!UITableViewCell)!.row
        dvc.sectionIndex = super.tableView.indexPathForCell( sender as!UITableViewCell)!.section
    }
    
}
