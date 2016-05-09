//
//  DetailViewController.swift
//  todoify
//
//  Created by Sebastian Huber on 06.05.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UITableViewController {
    @IBOutlet var DetailCell : UITableViewCell!
    
    var locationIndex: Int = 0
    var sectionIndex: Int = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let label = UILabel(frame: CGRectMake(0, 0, 300, 1000))
        label.text = TaskList.singleton.allTasks[sectionIndex][locationIndex].description
        label.center = CGPointMake(150, 500)
        label.textAlignment = NSTextAlignment.Left
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        DetailCell.contentView.addSubview(label)
    }
}
