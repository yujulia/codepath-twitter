//
//  LoginViewController.swift
//  Twitter
//
//  Created by Julia Yu on 2/22/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginTapped(sender: AnyObject) {
        
        let twitterClient = BDBOAuth1SessionManager(
            baseURL: NSURL(string: "https://api.twitter.com")!,
            consumerKey: "tlQEQS7zcKp93aO8qfn3IOenH",
            consumerSecret: "Hd5SmNqUmE09LnysMqoTWE2JMogm5yxYERBZGsA2Xbe4BDEwnJ"
        )
        
        twitterClient.deauthorize()
        twitterClient.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "twitterdemo://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("success", requestToken)
                
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(authURL)
                
            }) { (error: NSError!) -> Void in
                print(error.localizedDescription
            )
        }
        
    }

}
