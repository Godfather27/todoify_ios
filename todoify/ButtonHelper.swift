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
                {
                    if(!NSThread.isMainThread()) {
                        self.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: false)
                    }
                    else {
                        self.tableView.reloadData();
                    }
                }, taskId: sender.tag, mode: true)
        }
    }
    
    // sets status of task to archived and saves to server
    func archiveTask(sender: UIBarButtonItem) {
        if(Reach().hasInternetConnection()){
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
}
