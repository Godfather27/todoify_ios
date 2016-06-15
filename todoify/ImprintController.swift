//
//  ViewController.swift
//  todoify
//
//  Created by Sebastian Huber on 03.03.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit

class ImprintController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var contributorsView = UIView()
    var legalTextView = UIView()
    
    let imageSize = 100 as CGFloat
    let textSize = 42 as CGFloat
    let padding = 50 as CGFloat
    let labelPadding = 30 as CGFloat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, (300 + 2*(imageSize + padding + textSize + labelPadding)))
        
        contributorsView = setContriubtorsView()
        legalTextView = setLegalTextView()
                
        self.title = "Impressum"
        
        scrollView.addSubview(contributorsView)
        scrollView.addSubview(legalTextView)
        view.addSubview(scrollView)
        
    }
    
    func setContriubtorsView() -> UIView!{
        let image1 = UIImageView(image: UIImage(named: "alex_thumb.png"))
        let image2 = UIImageView(image: UIImage(named: "sebastian_thumb.png"))
        let image3 = UIImageView(image: UIImage(named: "josef_thumb.png"))
        let image4 = UIImageView(image: UIImage(named: "pablo_thumb.png"))
        let label1 = UILabel(frame: CGRectMake(0, 0, imageSize, textSize))
        let label2 = UILabel(frame: CGRectMake(0, 0, imageSize, textSize))
        let label3 = UILabel(frame: CGRectMake(0, 0, imageSize, textSize))
        let label4 = UILabel(frame: CGRectMake(0, 0, imageSize, textSize))
        
        label1.center = CGPointMake((self.view.frame.size.width/4), (imageSize + padding + labelPadding))
        label1.textAlignment = NSTextAlignment.Center
        label1.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label1.numberOfLines = 2
        label1.text = "Alexander Gabriel"
        image1.frame = CGRectMake((self.view.frame.size.width/4-(imageSize/2)), padding, imageSize, imageSize)
        
        label2.center = CGPointMake((self.view.frame.size.width/4*3), (imageSize + padding + labelPadding))
        label2.textAlignment = NSTextAlignment.Center
        label2.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label2.numberOfLines = 2
        label2.text = "Sebastian Huber"
        image2.frame = CGRectMake((self.view.frame.size.width/4*3-(imageSize/2)), padding, imageSize, imageSize)
        
        label3.center = CGPointMake((self.view.frame.size.width/4), 2*(imageSize + padding + labelPadding))
        label3.textAlignment = NSTextAlignment.Center
        label3.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label3.numberOfLines = 2
        label3.text = "Josef Krabath"
        image3.frame = CGRectMake((self.view.frame.size.width/4-(imageSize/2)), (imageSize + padding + textSize + labelPadding), imageSize, imageSize)
        
        
        label4.center = CGPointMake((self.view.frame.size.width/4*3), 2*(imageSize + padding + labelPadding))
        label4.textAlignment = NSTextAlignment.Center
        label4.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label4.numberOfLines = 2
        label4.text = "Pablo Pernías"
        image4.frame = CGRectMake((self.view.frame.size.width/4*3-(imageSize/2)), (imageSize + padding + textSize + labelPadding), imageSize, imageSize)
        
        contributorsView.addSubview(label1)
        contributorsView.addSubview(label2)
        contributorsView.addSubview(label3)
        contributorsView.addSubview(label4)
        
        contributorsView.addSubview(image1)
        contributorsView.addSubview(image2)
        contributorsView.addSubview(image3)
        contributorsView.addSubview(image4)
        
        return contributorsView
    }
    
    func setLegalTextView() -> UIView! {
        let label1 = UILabel(frame: CGRectMake(10, 0, (scrollView.contentSize.width-20), CGFloat.max))
        
        label1.numberOfLines = 0
        label1.text = "Impressum\n" +
            "Angaben gemäß § 5 TMG:\n" +
            "\n" +
            "Fachhochschule Salzburg\n" +
            "MultiMediaTechnology - MMT\n" +
            "Campus Urstein Süd 1\n" +
            "A-5412 Puch/Salzburg\n" +
            "\n" +
            "Kontakt:\n" +
            "\n" +
            "Telefon: +43-(0)50-2211-0\n" +
        "E-Mail: office@fh-salzburg.ac.at\n"
        
        label1.sizeToFit()
        
        legalTextView.addSubview(label1)
        
        return legalTextView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        contributorsView.frame = CGRectMake(0, 0, scrollView.contentSize.width, 2*(imageSize + padding + textSize + labelPadding))
        legalTextView.frame = CGRectMake(0, contributorsView.frame.size.height, scrollView.contentSize.width, 3794)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

