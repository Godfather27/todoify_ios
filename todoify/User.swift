//
//  User.swift
//  todoify
//
//  Created by Sebastian Huber on 06.05.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import Foundation


class User{
    let token : String?
    
    init(apiToken : String){
        token = apiToken
    }
}