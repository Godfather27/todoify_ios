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
    //@IBOutlet var DetailCell : UITableViewCell!
    
    @IBOutlet var DescriptionLabel : UILabel!
    @IBOutlet var AuthorLabel : UILabel!
    @IBOutlet var AuthorInitialLabel : UILabel!
    
    @IBOutlet var TitleLabel : UILabel!
    @IBOutlet var DueLabel : UILabel!
    
    @IBOutlet var ParticipatsLabel : UILabel!


    
    var locationIndex: Int = 0
    var sectionIndex: Int = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /*let label = UILabel(frame: CGRectMake(0, 0, 300, 1000))
        label.text = TaskList.singleton.allTasks[sectionIndex][locationIndex].description
        label.center = CGPointMake(150, 500)
        label.textAlignment = NSTextAlignment.Left
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        DetailCell.contentView.addSubview(label)*/
        
        DescriptionLabel.text = TaskList.singleton.allTasks[sectionIndex][locationIndex].description
        DescriptionLabel.center = CGPointMake(150, 500)
        DescriptionLabel.textAlignment = NSTextAlignment.Left
        DescriptionLabel.sizeToFit()
        
        AuthorLabel.text = TaskList.singleton.allTasks[sectionIndex][locationIndex].autor
        let author: String = AuthorLabel.text!
        AuthorInitialLabel.text = author[0..<1].uppercaseString
        
        TitleLabel.text = TaskList.singleton.allTasks[sectionIndex][locationIndex].title
        DueLabel.text = TaskList.singleton.allTasks[sectionIndex][locationIndex].due
        
        TitleLabel.center = CGPointMake(150, 10)
        TitleLabel.sizeToFit()

        DueLabel.center = CGPointMake(150, 10)
        
        ParticipatsLabel.text = TaskList.singleton.allTasks[sectionIndex][locationIndex].participants
        

    }
}
