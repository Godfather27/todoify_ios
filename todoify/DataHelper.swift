//
//  DataHelper.swift
//  todoify
//
//  Created by Sebastian Huber on 11.05.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit

extension ListViewController {
    func loadData(){
        if(Reach().hasInternetConnection()){
            setUserAndGetData()
        } else {
            // helper function in RenderHelper.swift
            renderWarning()
        }
    }
    
    func setUserAndGetData(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if(defaults.stringForKey("token") == nil){
            TaskList.singleton.onLoadedUser(){
                self.getData()
            }
        } else {
            TaskList.singleton.setUser()
            getData()
        }
    }
    
    func getData(){
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
