//
//  ButtonHelper.swift
//  todoify
//
//  Created by Sebastian Huber on 11.05.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit

extension ListViewController {
    // Toggles status of task and saves to server
    func toggleTask(sender: UIBarButtonItem){
        if(Reach().hasInternetConnection()){
            TaskList.singleton.onLoadedUpdate(
                {(prev : Array<Int>) in
                    var prev2 = prev
                    if(prev[0] != 0){
                        prev2.append(0)
                    } else {
                        prev2.append(1)
                    }
                    if(!NSThread.isMainThread()) {
                        self.performSelectorOnMainThread(#selector(ListViewController.updateTable), withObject: prev2, waitUntilDone: false)
                    }
                    else {
                        self.updateTable(prev2);
                    }
                }, taskId: sender.tag, mode: true)
        }
    }
    
    func updateTable(prev : Array<Int>) {
        let indexPath1 = NSIndexPath(forRow: prev[1], inSection: prev[0])
        let indexPath2 = NSIndexPath(forRow: TaskList.singleton.allTasks[prev[2]].count - 1, inSection: prev[2])
        CATransaction.begin()
        tableView.beginUpdates()
        self.tableView.moveRowAtIndexPath(indexPath1, toIndexPath: indexPath2)
        CATransaction.setCompletionBlock { () -> Void in
            self.tableView.reloadRowsAtIndexPaths([indexPath2], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        tableView.endUpdates()
        CATransaction.commit()
    }
    
    // sets status of task to archived and saves to server
    func archiveTask(sender: UIBarButtonItem) {
        if(Reach().hasInternetConnection()){
            
            TaskList.singleton.onLoadedUpdate(
                {(prev : Array<Int>) in
                    var prev2 = prev
                    prev2.append(2)
                    if(!NSThread.isMainThread()) {
                        self.performSelectorOnMainThread(#selector(ListViewController.updateTable), withObject: prev2, waitUntilDone: false)
                    }
                    else {
                        self.updateTable(prev2);
                    }
                }, taskId: sender.tag, mode: false)
        }
    }
    
    // navigates to imprint
    func navigateToImprint(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showImprint", sender: sender)
    }
    
    // callback of logout
    func logoutCompleted() {
        self.performSegueWithIdentifier("logout", sender: nil)
    }
    
    // logs out the user
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
        }
    }
    
    // navigates to manage Calendars
    func goToCalenendarManager(sender: UIButton!) {
        self.performSegueWithIdentifier("manager", sender: nil)
    }
}
