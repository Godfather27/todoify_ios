//
//  CreateCellComponents.swift
//  todoify
//
//  Created by Sebastian Huber on 11.05.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit

extension ListViewController {
    func createBottomBorder(cell : UITableViewCell) -> CALayer {
        let bottomBorder = CALayer()
        bottomBorder.borderColor = grayColor.CGColor
        bottomBorder.frame = CGRect(x: labelPadding, y: cell.frame.size.height - borderWidth, width: cell.frame.size.width - labelPadding, height: borderWidth)
        bottomBorder.borderWidth = borderWidth
        return bottomBorder
    }
    
    func createTopBorder(cell : UITableViewCell) -> CALayer {
        let topBorder = CALayer()
        topBorder.borderColor = grayColor.CGColor
        topBorder.frame = CGRect(x: labelPadding, y: 0, width: cell.frame.size.width - labelPadding, height: borderWidth)
        topBorder.borderWidth = borderWidth
        return topBorder
    }
    
    func createStatusBox(cell : UITableViewCell, indexPath: NSIndexPath) -> CALayer{
        let statusBox = CALayer()
        if(TaskList.singleton.allTasks[indexPath.section][indexPath.row].status == "closed" || TaskList.singleton.allTasks[indexPath.section][indexPath.row].status == "archived"){
            statusBox.borderColor = grayColor.CGColor
        } else {
            statusBox.borderColor = standardColor.CGColor
        }
        statusBox.frame = CGRect(x: 0, y: 0, width: statusboxWidth, height: cell.frame.size.height)
        statusBox.borderWidth = statusboxWidth
        return statusBox
    }
    
    func createTitleLabel(cell: UITableViewCell, indexPath : NSIndexPath) -> UILabel{
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
        return titleLabel
    }
    
    func createDueLabel(cell : UITableViewCell, indexPath: NSIndexPath)-> UILabel{
        let dueLabel = UILabel(frame: CGRectMake(labelPadding, padding + labelHeight,(cell.frame.size.width - (2 * buttonOuterBoundingSize + labelPadding + padding)), labelHeight))
        dueLabel.text = TaskList.singleton.allTasks[indexPath.section][indexPath.row].due
        dueLabel.textColor = UIColor.grayColor()
        dueLabel.font = UIFont.systemFontOfSize(12.0)
        return dueLabel
    }
    
    func createArchiveTask(cell: UITableViewCell, indexPath: NSIndexPath) -> UIButton{
        let archiveTask = UIButton(type: .Custom)
        if(TaskList.singleton.allTasks[indexPath.section][indexPath.row].status == "closed"){
            archiveTask.setImage(UIImage(named: "archive_closed.png"), forState: UIControlState.Normal)
        } else {
            archiveTask.setImage(UIImage(named: "archive_task.png"), forState: UIControlState.Normal)
        }
        archiveTask.frame = CGRectMake((cell.frame.size.width - buttonOuterBoundingSize), cell.frame.size.height/2 - buttonSize/2, buttonSize, buttonSize)
        archiveTask.tag = TaskList.singleton.allTasks[indexPath.section][indexPath.row].id!
        archiveTask.addTarget(self, action: #selector(ListViewController.archiveTask), forControlEvents: UIControlEvents.TouchDown)
        return archiveTask
    }
    
    func createCheckTask(cell: UITableViewCell, indexPath: NSIndexPath) -> UIButton {
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
        checkTask.addTarget(self, action: #selector(ListViewController.toggleTask), forControlEvents: UIControlEvents.TouchDown)
        return checkTask
    }
    
    func createGoToCalendarManagement(cell: UITableViewCell) -> UIButton {
        let manageCalendarsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 1000, height: 59))
        manageCalendarsButton.setTitle("manage Calendars", forState: .Normal)
        manageCalendarsButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        manageCalendarsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        manageCalendarsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        manageCalendarsButton.addTarget(self, action: #selector(goToCalenendarManager), forControlEvents: UIControlEvents.TouchDown)
        return manageCalendarsButton
    }
    
    func renderWarning(){
        let refreshController = UIAlertController(title: "Connection Error", message: "Your device doesn't have access to the internet currently", preferredStyle: .Alert)
        
        let refreshAction = UIAlertAction(title: "Refresh", style: .Cancel) { (action) in
            self.loadData()
        }
        
        let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        refreshController.addAction(refreshAction)
        refreshController.addAction(settingsAction)
        self.presentViewController(refreshController, animated: true) {
        }
    }
}