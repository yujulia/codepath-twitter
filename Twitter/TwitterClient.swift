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
    
}
