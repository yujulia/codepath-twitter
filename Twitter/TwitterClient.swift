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
    
    // ----------------------------------------- 
    
    func login(success: (String)->(), failure: (NSError) ->() ) {
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "twitterdemo://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                success(requestToken.token)
            }) { (error: NSError!) -> Void in
                failure(error)
        }
    }
    
    func authorize(token: String) {
        let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
        UIApplication.sharedApplication().openURL(authURL)
    }
    
    // ----------------------------------------- 
    
    func verifyCredentials() {
        GET(
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
        
        GET(
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
