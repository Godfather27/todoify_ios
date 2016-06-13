//
//  MangerController.swift
//  todoify
//
//  Created by Sebastian Huber on 13.06.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit

class MangerController: UIViewController, UIWebViewDelegate {
    @IBOutlet var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView.delegate = self
        let myURL = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/sync/ios_select")
        let myURLRequest : NSURLRequest = NSURLRequest(URL: myURL!)
        myWebView.loadRequest(myURLRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        if(webView.request?.URL?.absoluteString != "https://mmp2-gabriel-huber.herokuapp.com/sync/ios_select"){
            performSegueWithIdentifier("returnToTasks", sender: nil)
        }
    }
}
