//
//  TaskList.swift
//  todoify
//
//  Created by Sebastian Huber on 30.03.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import Foundation
import UIKit

class TaskList{
    static let singleton = TaskList()
    var allTasks = Array(count: 3, repeatedValue: Array<Task>())
    var userCompletedCallback : () -> Void = {};
    var dataCompletedCallback : () -> Void = {};
    var updateCompletedCallback : () -> Void = {}
    let baseUrl = "https://mmp2-gabriel-huber.herokuapp.com"
    var user : User!
    let semaphore = dispatch_semaphore_create(1)
    
    init(){
    }
    
    func setUser(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if( defaults.stringForKey("token") == nil){
            let myURL1 = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/apitoken")
            let myURLRequest1 : NSURLRequest = NSURLRequest(URL: myURL1!)
            let session1 = NSURLSession.sharedSession()
            
            let task1 = session1.dataTaskWithRequest(myURLRequest1){
                (data, response, error) -> Void in
                
                let myURL = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/api/gettoken")
                let myURLRequest : NSURLRequest = NSURLRequest(URL: myURL!)
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithRequest(myURLRequest){
                    (data, response, error) -> Void in
                    
                    let readObject = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                    let element = readObject as! NSDictionary
                    
                    defaults.setValue((element.objectForKey("api_token") as? String)!, forKey: "token")
                    defaults.synchronize()
                    
                    self.user = User()
                    
                    self.userCompletedCallback()
                }
                task.resume()
            }
            task1.resume()
            
        } else {
            self.user = User()
        }
    }
    
    func fetchData() {
        allTasks[0] = Array<Task>()
        allTasks[1] = Array<Task>()
        allTasks[2] = Array<Task>()
        var requests = Array<NSMutableURLRequest>()
        var requestURL = NSURL(string: "\(baseUrl)/api/\(user.token!)/open.json")!
        
        requests.append(NSMutableURLRequest(URL: requestURL))
        requestURL = NSURL(string: "\(baseUrl)/api/\(user.token!)/closed.json")!
        requests.append(NSMutableURLRequest(URL: requestURL))
        requestURL = NSURL(string: "\(baseUrl)/api/\(user.token!)/archived.json")!
        requests.append(NSMutableURLRequest(URL: requestURL))
        
        let session = NSURLSession.sharedSession()
        for urlRequest in requests{
            let task = session.dataTaskWithRequest(urlRequest){
                (data, response, error) -> Void in
                
                let readObject = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                let liste = readObject as! NSArray
                for jsoneintrag in liste {
                    if(urlRequest.URL!.absoluteString.containsString("open")){
                        self.allTasks[0].append(Task(json: jsoneintrag.objectForKey("task") as! NSDictionary, taskStatus: jsoneintrag.objectForKey("status") as! String))
                    } else if(urlRequest.URL!.absoluteString.containsString("closed")){
                        self.allTasks[1].append(Task(json: jsoneintrag.objectForKey("task") as! NSDictionary, taskStatus: jsoneintrag.objectForKey("status") as! String))
                    } else if(urlRequest.URL!.absoluteString.containsString("archived")){
                        self.allTasks[2].append(Task(json: jsoneintrag.objectForKey("task") as! NSDictionary, taskStatus: jsoneintrag.objectForKey("status") as! String))
                    }
                }
                self.dataCompletedCallback()
            }
            
            task.resume()
        }
    }
    
    func onLoadedUser(userCompletion: () -> Void){
        self.userCompletedCallback = userCompletion;
        TaskList.singleton.setUser()
    }
    
    func onLoadedData(dataCompletion: () -> Void){
        self.dataCompletedCallback = dataCompletion;
        fetchData();
    }
    
    func onLoadedUpdate(updateCompletion: () -> Void, taskId: Int, mode: Bool){
        self.updateCompletedCallback = updateCompletion
        updateStatus(taskId, mode: mode)
        
    }
    
    func updateStatus(taskId : Int, mode : Bool){
        var request : NSMutableURLRequest
        if (mode){
            request = NSMutableURLRequest(URL: NSURL(string: "\(baseUrl)/api/toggle")!)
        } else {
            request = NSMutableURLRequest(URL: NSURL(string: "\(baseUrl)/api/archive")!)
        }
        request.HTTPMethod = "POST"
        let postString = "user=\(user.token!)&task=\(taskId)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        
        // self.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: false)
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            let readObject = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
            let element = readObject as! NSDictionary
            if(element["status"] != nil){
                self.updateTasks(taskId, element: element)
            }
            self.updateCompletedCallback()
        }
        
        task.resume()
    }
    
    func updateTasks(taskId : Int, element : NSDictionary){
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        let position = self.getResentTask(taskId)
        switch element.objectForKey("status") as! String{
        case "open":
            self.allTasks[position[0]][position[1]].status = "open"
            self.allTasks[0].append(self.allTasks[position[0]].removeAtIndex(position[1]))
            break
        case "closed":
            self.allTasks[position[0]][position[1]].status = "closed"
            self.allTasks[1].append(self.allTasks[position[0]].removeAtIndex(position[1]))
            break
        case "archived":
            self.allTasks[position[0]][position[1]].status = "archived"
            self.allTasks[2].append(self.allTasks[position[0]].removeAtIndex(position[1]))
            break
        default:
            break
        }
        dispatch_semaphore_signal(semaphore)
    }
    
    func getResentTask(taskId : Int) -> Array<Int>{
        for i in 0...self.allTasks.count-1{
            if(self.allTasks[i].count == 0){
                continue
            }
            for j in 0...self.allTasks[i].count-1{
                if(self.allTasks[i][j].id == taskId){
                    return [i,j]
                }
            }
        }
        return [-1,-1]
    }
    
    
}