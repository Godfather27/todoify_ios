//
//  TaskList.swift
//  todoify
//
//  Created by Sebastian Huber on 30.03.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import Foundation

class TaskList{
    static let singleton = TaskList()
    var tasks = Array<Task>()
    
    init(){
//        let dataURL = NSBundle.mainBundle().URLForResource(
//            "test", withExtension: "json")
//        let data = NSData(contentsOfURL: dataURL!)
//        let readObject = try? NSJSONSerialization.JSONObjectWithData(data!,
//            options: NSJSONReadingOptions())
//        let liste = readObject as! NSArray
//        var locs = Array<Task>()
//        
//        for jsoneintrag in liste {
//            // Die “init” Funktion der Klasse “Hundeeinrichtung” extrahiert die
//            // Daten aus dem Dictionary
//            locs.append(Task(json: jsoneintrag as! NSDictionary))
//        }
//        tasks = locs // locations ist property vom Singleton
        
//        THIS IS THE urlRequest
        
        let requestURL: NSURL = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/api/174/open.json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        var locs = Array<Task>()
        
        let task = session.dataTaskWithRequest(urlRequest){
            
            (data, response, error) -> Void in
            
            let readObject = try? NSJSONSerialization.JSONObjectWithData(data!,
                options: NSJSONReadingOptions())
            let liste = readObject as! NSArray
            for jsoneintrag in liste {
                // Die “init” Funktion der Klasse “Task” extrahiert die
                // Daten aus dem Dictionary
                locs.append(Task(json: jsoneintrag as! NSDictionary))
            }
            print(locs)
        }
        
        task.resume()
        
        sleep(5)
        
        tasks = locs // locations ist property vom Singleton
        print(tasks)
    }
}