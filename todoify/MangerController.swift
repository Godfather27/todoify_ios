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
    
    var loadingSpinner = UIActivityIndicatorView()
    
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
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loadingSpinner.startAnimating()
        loadingSpinner.frame = CGRect(x: webView.frame.size.width/2-25, y: webView.frame.size.height/2-25, width: 50, height: 50)
        webView.addSubview(loadingSpinner)
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        loadingSpinner.stopAnimating()
        loadingSpinner.removeFromSuperview()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.URL?.absoluteString.containsString("https://mmp2-gabriel-huber.herokuapp.com/sync/calendars") == true){
            let myURL1 = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/sync/sync")
            let myURLRequest1 : NSURLRequest = NSURLRequest(URL: myURL1!)
            let session1 = NSURLSession.sharedSession()
            
            let task1 = session1.dataTaskWithRequest(myURLRequest1){
                (data, response, error) -> Void in
            }
            task1.resume()
            performSegueWithIdentifier("returnToTasks", sender: nil)
        } else if(request.URL?.absoluteString.containsString("https://mmp2-gabriel-huber.herokuapp.com/tasks") == true){
            loadingSpinner.stopAnimating()
            loadingSpinner.removeFromSuperview()
            let myURL = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/sync/ios_select")
            let myURLRequest : NSURLRequest = NSURLRequest(URL: myURL!)
            myWebView.loadRequest(myURLRequest)
        }
        return true
    }
}
