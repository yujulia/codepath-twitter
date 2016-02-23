//
//  TwitterClient.swift
//  Twitter
//
//  Created by Julia Yu on 2/22/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

private let BASE_URL = "https://api.twitter.com"
private let CONSUMER_KEY = "tlQEQS7zcKp93aO8qfn3IOenH"
private let CONSUMER_SECRET = "Hd5SmNqUmE09LnysMqoTWE2JMogm5yxYERBZGsA2Xbe4BDEwnJ"

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(
        baseURL: NSURL(string: BASE_URL)!,
        consumerKey: CONSUMER_KEY,
        consumerSecret: CONSUMER_SECRET
    )
    
    var loginSuccess: ((String) -> ())?
    var loginFailure: ((NSError) -> ())?
    
    // ----------------------------------------- 
    
    func login(success: (String)->(), failure: (NSError) ->() ) {
        
        self.loginSuccess = success
        self.loginFailure = failure
        
        self.deauthorize()
        self.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "twitterdemo://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(authURL)
            
            }) { (error: NSError!) -> Void in
                self.loginFailure?(error)
        }
    }
    
    
    // ----------------------------------------- 
    func handleOpenURL(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        self.fetchAccessTokenWithPath(
            "oauth/access_token",
            method: "POST",
            requestToken: requestToken,
            success: { (credentials: BDBOAuth1Credential!) -> Void in
                
                print("got credentails", credentials)
                self.loginSuccess?("yeah logged in")
                
//                self.verifyCredentials()
//
//                TwitterClient.sharedInstance.homeTimeline(
//                    { (tweets: [Tweet]) -> () in
//                        for t in tweets {
//                            print(t.text)
//                        }
//                    },
//                    failure: { (error: NSError) -> () in
//                        print(error.localizedDescription)
//                    }
//                )
//                
                
            }) { (error: NSError!) -> Void in
                print(error.localizedDescription)
        }
    }
    
    // ----------------------------------------- 
    
    func verifyCredentials() {
        self.GET(
            "1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let user = response as? NSDictionary
                let userModel = User(userData: user!)
                
                print(userModel.name)
                
                
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error)
        }
    }
    
    // ----------------------------------------- 
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        self.GET(
            "1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                if let allTweets = response as? [NSDictionary] {
                    let tweets = Tweet.tweetsWithArray(allTweets)
                    success(tweets)
                }
                
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }

    }
}
