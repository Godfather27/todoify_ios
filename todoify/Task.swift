//
//  Task.swift
//  todoify
//
//  Created by Sebastian Huber on 30.03.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

extension String {
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}

import MapKit
import Foundation

class Task{
    var id : Int?
    var description : String?
    var autor : String?
    var participants : String?
    var due : String?
    var title : String?
    var status : String?
    
    init(json: NSDictionary, type: String){
        id = json.objectForKey("id") as? Int
        description = json.objectForKey("description") as? String
        autor = json.objectForKey("autor") as? String
        participants = json.objectForKey("participants") as? String
        title = json.objectForKey("title") as? String

        status = type[48 ..< (type.characters.count - 5)]
        
        due = json.objectForKey("due") as? String
        due = (due! as NSString).substringToIndex(10)
        var day, month, year : String
        year =   due![0 ..< 4]
        month = due![5 ..< 7]
        day =  due![8 ..< 10]
        due = "\(day).\(month).\(year)"
    }
}