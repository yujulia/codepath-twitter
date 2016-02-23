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
    @IBOutlet weak var retweetedIcon: UIImageView!
    @IBOutlet weak var retweetedText: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.retweetedIcon.hidden = true
//        self.retweetedText.hidden = true

        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabelText(tweetText: String){
        tweetTextLabel.text = tweetText
    }

}
