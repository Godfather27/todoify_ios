//
//  ExtString.swift
//  todoify
//
//  Created by Sebastian Huber on 11.05.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

extension String {
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}