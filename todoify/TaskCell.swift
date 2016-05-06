//
//  TaskCell.swift
//  todoify
//
//  Created by Sebastian Huber on 06.05.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit


class TaskTableCell: UITableViewCell {
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var dueLabel : UILabel!
    @IBOutlet var infoTask : UIButton!
    @IBOutlet var archiveTask : UIButton!
    @IBOutlet var doneTask : UIButton!
    @IBOutlet var statusBox : CALayer!
}