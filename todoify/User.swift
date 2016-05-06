//
//  User.swift
//  todoify
//
//  Created by Sebastian Huber on 06.05.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import Foundation


class User{
    var token : String?
    
    init(json : NSDictionary){
        token = json.objectForKey("token") as? String
    }
}