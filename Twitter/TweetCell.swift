//
//  TweetCell.swift
//  Twitter
//
//  Created by Julia Yu on 2/22/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit
import TimeAgoInWords

let railsStrings = [
    "LessThan": "less than ",
    "About": "",
    "Over": "",
    "Almost": "",
    "Seconds": " seconds",
    "Minute": " minute",
    "Minutes": " minutes",
    "Hour": " hour",
    "Hours": " hours",
    "Day": " day",
    "Days": " days",
    "Months": " months",
    "Years": " years",
]

@objc protocol TweetCellDelegate {
    optional func tweetCell(tweetCell: TweetCell, didWantToReply value: Int)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetName: UILabel!
    @IBOutlet weak var tweetScreenName: UILabel!
    @IBOutlet weak var tweetTime: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var retweetTopConstraint: NSLayoutConstraint!
    
    weak var delegate: TweetCellDelegate?
    
    var data: Tweet? {
        didSet {
            self.setDataAsProperty()
        }
    }
    
    var row: Int?

    // --------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hideRetweeted()
        TimeAgoInWordsStrings.updateStrings(railsStrings)
    }
    
    // -------------------------------------- put the data in our view
    
    private func setDataAsProperty() {
        if let tweetText = self.data?.text {
            self.tweetTextLabel.text = tweetText as String
        }
        if let imageURL = self.data?.profileImageURL {
            self.loadProfileImage(imageURL)
        }
        if let tweetName = self.data?.name {
            self.tweetName.text = tweetName as String
        }
        if let screenName = self.data?.screenName {
            self.tweetScreenName.text = "@\(screenName as String)"
        }
        if let timestamp = self.data?.timestamp {
            let now = NSDate()
            let diff = now.timeIntervalSinceDate(timestamp)
            let timeago = NSDate(timeIntervalSinceNow: diff).timeAgoInWords()
            self.tweetTime.text = timeago
        }
        
        if let retweeted = self.data?.retweeted {
            if retweeted {
                if let userName = State.currentUser?.screenName {
                    showRetweeted(String(userName))
                }
            }
        }
    }
    
    // -------------------------------------- 
    
    func hideRetweeted() {
        self.retweetIcon.hidden = true
        self.retweetLabel.hidden = true
        self.retweetTopConstraint.constant = 0
        self.retweetLabel.text = ""
    }
    
    func showRetweeted(retweetedBy: String) {
        self.retweetIcon.hidden = false
        self.retweetLabel.hidden = false
        self.retweetTopConstraint.constant = 10
        self.retweetLabel.text = "\(retweetedBy) Retweeted"
    }
    
    // --------------------------------------
    
    func loadProfileImage(profileImageURL: NSURL) {
        self.profileImage.alpha = 0
        
        ImageLoader.loadImage(
            profileImageURL,
            imageview: self.profileImage,
            success: { () -> () in
                UIView.animateWithDuration(0.3,
                    animations:  {() in
                        self.profileImage.alpha = 1
                    }
                )
            },
            failure: { (error: NSError) -> () in
                self.profileImage.image = UIImage(named: "default")
                print("image load failure for profileImageURL: ", error.localizedDescription)
                self.profileImage.alpha = 1
            }
        )
    }

    @IBAction func onReply(sender: AnyObject) {
        self.delegate?.tweetCell?(self, didWantToReply: self.row!)
    }
}
