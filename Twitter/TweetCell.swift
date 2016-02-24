//
//  TweetCell.swift
//  Twitter
//
//  Created by Julia Yu on 2/22/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit

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
    
    var data: Tweet? {
        didSet {
            if let tweetText = self.data?.text {
                self.tweetTextLabel.text = tweetText as String
            }
            if let imageURL = self.data?.profileImageURL {
                self.loadProfileImage(imageURL)
            }
            
        }
    }

    // --------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hideRetweeted()
    }
    
    // -------------------------------------- 
    
    func hideRetweeted() {
        self.retweetIcon.hidden = true
        self.retweetLabel.hidden = true
        self.retweetTopConstraint.constant = 0
        self.retweetLabel.text = ""
    }
    
    func showRetweeted(retweetedBy: String?) {
        self.retweetIcon.hidden = false
        self.retweetLabel.hidden = false
        self.retweetTopConstraint.constant = 10
        self.retweetLabel.text = retweetedBy ?? "Retweeted by unknown"
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
                print("image load failure for profileImageURL: ", error.localizedDescription)
            }
        )
    }

}
