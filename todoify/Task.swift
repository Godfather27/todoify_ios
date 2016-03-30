//
//  Task.swift
//  todoify
//
//  Created by Sebastian Huber on 30.03.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import MapKit
import Foundation

class Task{
    var id : Int?
    var description : String?
    var autor : String?
    var participants : String?
    var due : String?
    var title : String?
    
    init(json: NSDictionary){
        //print(json)
        id = json.objectForKey("id") as? Int
        description = json.objectForKey("description") as? String
        autor = json.objectForKey("autor") as? String
        participants = json.objectForKey("participants") as? String
        due = json.objectForKey("due") as? String
        title = json.objectForKey("title") as? String
    }
}