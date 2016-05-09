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
    var tasks = Array<Task>()
    var userCompletedCallback : () -> Void = {};
    var dataCompletedCallback : () -> Void = {};
    let baseUrl = "https://mmp2-gabriel-huber.herokuapp.com"
    var user : User!
    
    init(){
    }
    
    func setUser(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if(( defaults.stringForKey("token")) == nil){
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
        } else {
            self.user = User()
        }
    }
    
    func fetchData() {
        print("start fetching")
        print(user.token)
        var requests = Array<NSMutableURLRequest>()
        var requestURL = NSURL(string: "\(baseUrl)/api/\(user.token!)/open.json")!
        print("\(baseUrl)/api/\(user.token!)/open.json")
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
                    self.tasks.append(Task(json: jsoneintrag as! NSDictionary, type: urlRequest.URL!.absoluteString))
                }
                self.dataCompletedCallback()
            }
        
            task.resume()
        }
    }
    
    func onLoadedUser(userCompletion: () -> Void){
        self.userCompletedCallback = userCompletion;
    }
    
    func onLoadedData(dataCompletion: () -> Void){
        self.dataCompletedCallback = dataCompletion;
        fetchData();
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
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            let readObject = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
            let element = readObject as! NSDictionary
            self.tasks[self.getResentTask(taskId)].status = element.objectForKey("status") as? String
            
            self.dataCompletedCallback()
        }
        
        task.resume()
    }
    
    func getResentTask(taskId : Int) -> Int{
        for i in 0...self.tasks.count{
            if(self.tasks[i].id == taskId){
                return i
            }
        }
        return -1
    }
    
    
}