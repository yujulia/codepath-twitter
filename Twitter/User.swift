//
//  User.swift
//  Twitter
//
//  Created by Julia Yu on 2/22/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: NSString?
    var screenName: NSString?
    var tagline: NSString?
    var profileURL: NSURL?
    
    init(userData: NSDictionary) {
        
        self.name = userData["name"] as? String
        self.screenName = userData["screen_name"] as? String
        self.tagline = userData["description"] as? String
        
        let profileImageURLStr = userData["profile_image_url"] as? String
        if let profileImageURL = profileImageURLStr {
            self.profileURL = NSURL(string: profileImageURL)
        }
        
    }
}
