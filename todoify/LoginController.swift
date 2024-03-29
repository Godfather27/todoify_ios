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
        
        // skip login if already logged in
        let defaults = NSUserDefaults.standardUserDefaults()
        if(defaults.stringForKey("token") != nil && Reach().hasInternetConnection()){
            navigateToListView()
        }
        
        // continue with login procedure
        super.viewDidLoad()
        myWebView.delegate = self
        let myURL = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/ioslogin")
        let myURLRequest : NSURLRequest = NSURLRequest(URL: myURL!)
        myWebView.loadRequest(myURLRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // show loading spinner while loading webpage
    func webViewDidStartLoad(webView: UIWebView) {
        loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loadingSpinner.startAnimating()
        loadingSpinner.frame = CGRect(x: webView.frame.size.width/2-25, y: webView.frame.size.height/2-25, width: 50, height: 50)
        webView.addSubview(loadingSpinner)
    }
    
    // hide loading spinner when loading has ended
    func webViewDidFinishLoad(webView: UIWebView){
        loadingSpinner.stopAnimating()
        loadingSpinner.removeFromSuperview()
    }
    
    func navigateToListView() -> Void {
        performSegueWithIdentifier("goToListView", sender: nil)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.URL?.absoluteString.containsString("about:blank") == true) {
            loadingSpinner.stopAnimating()
            loadingSpinner.removeFromSuperview()
        } else if(request.URL?.absoluteString.containsString("https://mmp2-gabriel-huber.herokuapp.com/tasks") == true){
            loadingSpinner.stopAnimating()
            loadingSpinner.removeFromSuperview()
            navigateToListView()
        }
        return true
    }
    
    // hide backbutton - prevent double login procedure
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}