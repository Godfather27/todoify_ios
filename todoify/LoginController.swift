//
//  LoginController.swift
//  todoify
//
//  Created by Sebastian Huber on 07.05.16.
//  Copyright © 2016 FH Salzburg. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var myWebView: UIWebView!
    
    override func viewDidLoad() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if(defaults.stringForKey("token") != nil){
            navigateToListView()
        }
        super.viewDidLoad()
        myWebView.delegate = self
        let myURL = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/")
        let myURLRequest : NSURLRequest = NSURLRequest(URL: myURL!)
        myWebView.loadRequest(myURLRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        if(webView.request?.URL?.absoluteString == "https://mmp2-gabriel-huber.herokuapp.com/tasks"){
            navigateToListView()
        }
    }
    
    func navigateToListView() -> Void {
        TaskList.singleton.setUser()
        performSegueWithIdentifier("goToListView", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}