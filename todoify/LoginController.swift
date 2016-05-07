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
            let myURL = NSURL(string: "https://mmp2-gabriel-huber.herokuapp.com/api/gettoken")
            let myURLRequest : NSURLRequest = NSURLRequest(URL: myURL!)
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(myURLRequest){
                (data, response, error) -> Void in
                
                let readObject = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                let element = readObject as! NSDictionary
                TaskList.singleton.setUser((element.objectForKey("api_token") as? String)!)
            }
            
            task.resume()
            
            // NAVIGATE TO LIST VIEW CONTROLLER
        }
    }
}