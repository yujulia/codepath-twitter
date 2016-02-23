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
        
        let client = TwitterClient.sharedInstance
        
        client.login({ (token: String) -> () in
                print("login success");
                client.authorize(token)
            }) { (error: NSError) -> () in
                print("login failure: ", error.localizedDescription)
        }
    }
}
