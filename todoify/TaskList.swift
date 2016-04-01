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
        var requestURL: NSURL = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/api/69/open.json")!
        requests.append(NSMutableURLRequest(URL: requestURL))
        requestURL = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/api/69/closed.json")!
        requests.append(NSMutableURLRequest(URL: requestURL))
        requestURL = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/api/69/archived.json")!
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
                self.completedCallback();
            }
        
            task.resume()
        }
    }
    
    func onLoaded(completion: () -> Void){
        self.completedCallback = completion;
        fetchData();
    }
    
    
}