//
//  ListViewController.swift
//  todoify
//
//  Created by Sebastian Huber on 30.03.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit

extension UIButton {
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let buttonSize = self.frame.size
        let widthToAdd = (44-buttonSize.width > 0) ? 44-buttonSize.width : 0
        let heightToAdd = (44-buttonSize.height > 0) ? 44-buttonSize.height : 0
        let largerFrame = CGRect(x: 0-(widthToAdd/2), y: 0-(heightToAdd/2), width: buttonSize.width+widthToAdd, height: buttonSize.height+heightToAdd)
        return (CGRectContainsPoint(largerFrame, point)) ? self : nil
    }
}

class ListViewController: UITableViewController {
    
    func checkTask(sender: UIBarButtonItem){
        if(checkNetworkStatus() == 1){
            TaskList.singleton.onLoadedUpdate({
                if(!NSThread.isMainThread()) {
                    self.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: false)
                }
                else {
                    self.tableView.reloadData();
                }
                }, taskId: sender.tag, mode: true)
        }
    }
    
    func archiveTask(sender: UIBarButtonItem) {
        if(checkNetworkStatus() == 1){
            TaskList.singleton.onLoadedUpdate(
                {
                    if(!NSThread.isMainThread()) {
                        self.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: false)
                    }
                    else {
                        self.tableView.reloadData();
                    }
                }, taskId: sender.tag, mode: false)
        }
    }
    
    func navigateToImprint(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showImprint", sender: sender)
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
    
    func logoutCompleted() {
        self.performSegueWithIdentifier("logout", sender: nil)        
    }
    
    func logout(){
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            return
        }
        alertController.addAction(cancelAction)
        
        let LogoutAction = UIAlertAction(title: "Logout", style: .Default) { (action) in
            NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "token")
            NSUserDefaults.standardUserDefaults().synchronize()
            TaskList.singleton.user = nil
            NSURLSession.sharedSession().resetWithCompletionHandler({
                self.performSelectorOnMainThread(#selector(ListViewController.logoutCompleted), withObject: nil, waitUntilDone: false)
            })
            
        }
        alertController.addAction(LogoutAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkNetworkStatus()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let infoButton = UIBarButtonItem(title: "Info", style: .Plain, target: self, action: #selector(ListViewController.navigateToImprint));
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(ListViewController.logout));
        
        self.navigationItem.leftBarButtonItem = logoutButton
        self.navigationItem.rightBarButtonItem = infoButton
        
        self.tableView.rowHeight = 59 as CGFloat
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewDidAppear(animated: Bool) {
        if(checkNetworkStatus() == 1){
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(checkNetworkStatus() == 1){
            return TaskList.singleton.allTasks.count
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(checkNetworkStatus() == 1){
            return TaskList.singleton.allTasks[section].count
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(checkNetworkStatus() == 1){
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
        } else {
            return "Connection Error"
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath)
        
        if(checkNetworkStatus() == 1){
            // remove old objects from cell
            for cellElements in cell.subviews {
                cellElements.removeFromSuperview()
            }
            
            // define UI constants
            let standardColor = UIColor(red: (25/355), green: (152/355), blue: (220/355), alpha: (100/100))
            let grayColor = UIColor(red: (250/355), green: (250/355), blue: (250/355), alpha: (250/100))
            let statusboxWidth = 5 as CGFloat
            let buttonSize = 30 as CGFloat
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
            let titleLabel = UILabel(frame: CGRectMake(labelPadding, padding,(cell.frame.size.width - (2 * buttonOuterBoundingSize + labelPadding + padding)), labelHeight))
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
            let dueLabel = UILabel(frame: CGRectMake(labelPadding, padding + labelHeight,(cell.frame.size.width - (2 * buttonOuterBoundingSize + labelPadding + padding)), labelHeight))
            dueLabel.text = TaskList.singleton.allTasks[indexPath.section][indexPath.row].due
            dueLabel.textColor = UIColor.grayColor()
            dueLabel.font = UIFont.systemFontOfSize(12.0)
            
            // Buttons for marking tasks as done, archived and viewing task details
            if(TaskList.singleton.allTasks[indexPath.section][indexPath.row].status != "archived"){
                let archiveTask = UIButton(type: .Custom)
                if(TaskList.singleton.allTasks[indexPath.section][indexPath.row].status == "closed"){
                    archiveTask.setImage(UIImage(named: "archive_closed.png"), forState: UIControlState.Normal)
                } else {
                    archiveTask.setImage(UIImage(named: "archive_task.png"), forState: UIControlState.Normal)
                }
                archiveTask.frame = CGRectMake((cell.frame.size.width - buttonOuterBoundingSize), cell.frame.size.height/2 - buttonSize/2, buttonSize, buttonSize)
                archiveTask.tag = TaskList.singleton.allTasks[indexPath.section][indexPath.row].id!
                archiveTask.addTarget(self, action: #selector(ListViewController.archiveTask), forControlEvents: UIControlEvents.TouchDown)
                cell.addSubview(archiveTask)
            }
            let checkTask = UIButton(type: .Custom)
            if(TaskList.singleton.allTasks[indexPath.section][indexPath.row].status != "open"){
                checkTask.setImage(UIImage(named: "redo.png"), forState: UIControlState.Normal)
            } else {
                checkTask.setImage(UIImage(named: "check_task.png"), forState: UIControlState.Normal)
            }
            if(TaskList.singleton.allTasks[indexPath.section][indexPath.row].status != "archived"){
                checkTask.frame = CGRectMake((cell.frame.size.width - 2 * buttonOuterBoundingSize), cell.frame.size.height/2 - buttonSize/2, buttonSize, buttonSize)
            } else {
                checkTask.frame = CGRectMake((cell.frame.size.width - buttonOuterBoundingSize), cell.frame.size.height/2 - buttonSize/2, buttonSize, buttonSize)
            }
            checkTask.tag = TaskList.singleton.allTasks[indexPath.section][indexPath.row].id!
            checkTask.addTarget(self, action: #selector(ListViewController.checkTask), forControlEvents: UIControlEvents.TouchDown)
            
            // add views to cell
            cell.layer.addSublayer(statusBox)
            cell.layer.addSublayer(bottomBorder)
            cell.addSubview(checkTask)
            cell.addSubview(titleLabel)
            cell.addSubview(dueLabel)
            
            return cell
        } else {
            let label = UILabel(frame: CGRectMake(20,0,cell.frame.size.width,cell.frame.size.height))
            label.text = "Your device has no internet connection"
            label.textColor = UIColor.redColor()
            label.font = UIFont.systemFontOfSize(14.0)
            
            cell.addSubview(label)
            
            return cell
        }
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
