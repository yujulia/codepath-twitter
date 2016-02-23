//
//  Tweet.swift
//  Twitter
//
//  Created by Julia Yu on 2/22/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    
    
    var tweet: NSString?
    var timestamp: NSDate?
    
    var retweets: Int = 0
    var favorites: Int = 0
    
    var id: NSNumber?
    var tweeterName: NSString?
    var location: NSString?
    
    init(tweetData: NSDictionary) {
        
        self.tweet = tweetData["text"] as? String
        self.retweets = (tweetData["retweet_count"] as? Int) ?? 0
        self.favorites = (tweetData["favourites_count"] as? Int) ?? 0
        
        if let timestampStr = tweetData["created_at"] as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            self.timestamp = dateFormatter.dateFromString(timestampStr)
        
        }
    }
    
    class func tweetsWithArray(tweetsArray: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for tweetData in tweetsArray {
            let tweet = Tweet(tweetData: tweetData)
            tweets.append(tweet)
        }
        
        return tweets
    }
}