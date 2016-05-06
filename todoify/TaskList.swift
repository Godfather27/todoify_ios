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
    var completedCallback : () -> Void = {};
    
    init(){
    }
    
    func fetchData() {
        var requests = Array<NSMutableURLRequest>()
        var requestURL: NSURL = NSURL(string: "http://localhost:3000/api/628/open.json")!
        requests.append(NSMutableURLRequest(URL: requestURL))
        requestURL = NSURL(string: "http://localhost:3000/api/628/closed.json")!
        requests.append(NSMutableURLRequest(URL: requestURL))
        requestURL = NSURL(string: "http://localhost:3000/api/628/archived.json")!
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
                self.completedCallback()
            }
        
            task.resume()
        }
    }
    
    func onLoaded(completion: () -> Void){
        self.completedCallback = completion;
        fetchData();
    }
    
    func updateStatus(taskId : Int, mode : Bool){
        if (mode){
            print("toggle \(taskId)")
        } else {
            print("archive \(taskId)")
        }

        var request : NSMutableURLRequest
        if (mode){
            request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/api/toggle")!)
        } else {
            request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/api/archive")!)
        }
        request.HTTPMethod = "POST"
        let postString = "user=628&task= \(taskId)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            let readObject = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
            let element = readObject as! NSDictionary
            self.tasks[self.getResentTask(taskId)].status = element.objectForKey("status") as? String
            
            self.completedCallback()
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