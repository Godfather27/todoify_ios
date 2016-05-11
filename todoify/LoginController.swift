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
    
    var loadingSpinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let status = checkNetworkStatus()
        let defaults = NSUserDefaults.standardUserDefaults()
        if(defaults.stringForKey("token") != nil || status == -1){
            navigateToListView()
        }
        super.viewDidLoad()
        myWebView.delegate = self
        let myURL = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/ioslogin")
        let myURLRequest : NSURLRequest = NSURLRequest(URL: myURL!)
        myWebView.loadRequest(myURLRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        if(webView.request?.URL?.absoluteString.containsString("google") == false){
            loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            loadingSpinner.startAnimating()
            loadingSpinner.frame = CGRect(x: webView.frame.size.width/2-25, y: webView.frame.size.height/2-25, width: 50, height: 50)
            webView.addSubview(loadingSpinner)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        if(webView.request?.URL?.absoluteString.containsString("google") == false){
            loadingSpinner.stopAnimating()
            loadingSpinner.removeFromSuperview()
        }
        if(webView.request?.URL?.absoluteString == "https://mmp2-gabriel-huber.herokuapp.com/tasks"){
            navigateToListView()
        }
    }
    
    func navigateToListView() -> Void {
        performSegueWithIdentifier("goToListView", sender: nil)
    }
    
    func checkNetworkStatus()->Int{
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            return -1
        case .Online(.WWAN):
            return 1
        case .Online(.WiFi):
            return 1
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}