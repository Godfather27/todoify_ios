//
//  Task.swift
//  todoify
//
//  Created by Sebastian Huber on 30.03.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import Foundation

class Task{
    var id : Int?
    var description : String?
    var autor : String?
    var participants : String?
    var due : String?
    var title : String?
    var status : String?
    
    init(json: NSDictionary, taskStatus: String){
        id = json.objectForKey("id") as? Int
        description = json.objectForKey("description") as? String
        autor = json.objectForKey("autor") as? String
        participants = json.objectForKey("participants") as? String
        title = json.objectForKey("title") as? String
        
        if(taskStatus.containsString("open")){
            status = "open"
        } else if (taskStatus.containsString("closed")){
            status = "closed"
        } else if(taskStatus.containsString("archived")){
            status = "archived"
        }
        
        due = json.objectForKey("due") as? String
        due = (due! as NSString).substringToIndex(10)
        var day, month, year : String
        year =   due![0 ..< 4]
        month = due![5 ..< 7]
        day =  due![8 ..< 10]
        due = "\(day).\(month).\(year)"
    }
}