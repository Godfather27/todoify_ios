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
    @IBOutlet var KategorieCell : UITableViewCell!
    
    var locationIndex: Int = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        KategorieCell.textLabel!.text = TaskList.singleton.tasks[locationIndex].title
    }
}
