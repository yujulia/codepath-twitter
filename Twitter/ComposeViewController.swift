//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Julia Yu on 2/23/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    let client = TwitterClient.sharedInstance
    
    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var charCount: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadProfileImage(State.currentUser!.profileImageURL!)
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
    
    // --------------------------------------
    
    @IBAction func onTweet(sender: AnyObject) {
        
        self.client.postTweet(
            self.textBox.text,
            success: { () -> () in
                print("twitted");
            }) { (error: NSError) -> () in
                print("post tweet error: ", error.localizedDescription)
        }
        
    }
    
    // --------------------------------------

    @IBAction func xClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        
        let stringLength = textView.text.characters.count
        
        if stringLength > 0 {
            // turn on button
        } else {
            // turn off button
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        //
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        //
    }
}
