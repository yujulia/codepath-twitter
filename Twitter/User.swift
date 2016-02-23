//
//  User.swift
//  Twitter
//
//  Created by Julia Yu on 2/22/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit

private let CURRENT_USER_KEY: String = "currentUser"

class User: NSObject {
    
    var name: NSString?
    var screenName: NSString?
    var tagline: NSString?
    var profileURL: NSURL?
    var userData: NSDictionary?
    
    
    init(userData: NSDictionary) {
        
        self.userData = userData
        self.name = userData["name"] as? String
        self.screenName = userData["screen_name"] as? String
        self.tagline = userData["description"] as? String
        
        let profileImageURLStr = userData["profile_image_url"] as? String
        if let profileImageURL = profileImageURLStr {
            self.profileURL = NSURL(string: profileImageURL)
        }
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        
        get {
            // no user cached, search the store
            if _currentUser == nil {
    
                let store = NSUserDefaults.standardUserDefaults()
                let userDataJSON = store.objectForKey(CURRENT_USER_KEY) as? NSData
        
                if let userDataJSON = userDataJSON {
                    let userDataDictionary = try! NSJSONSerialization.JSONObjectWithData(userDataJSON, options: []) as! NSDictionary
                    let user = User(userData: userDataDictionary)
                    self._currentUser = user
                } else {
                    return nil // no user
                }
            }
        
            return self._currentUser
        }
        
        set(user) {
            let store = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let userDataJSON = try! NSJSONSerialization.dataWithJSONObject(user.userData!, options: [])
                store.setObject(userDataJSON, forKey: CURRENT_USER_KEY)
            } else {
                store.setObject(nil, forKey: CURRENT_USER_KEY)
            }
            store.synchronize()
        }
    }
    
    
}
