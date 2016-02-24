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
    let placeholder = "What's Happening?"
    
    @IBOutlet weak var composeBtn: UIButton!
    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var charCount: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    // --------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.composeBtn.enabled = false
        self.loadProfileImage(State.currentUser!.profileImageURL!)
        
        self.textBox.delegate = self
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
        
        // nothing to post
        
        if !self.composeBtn.enabled {
            return
        }
        
        // something to post
        
        self.client.postTweet(
            self.textBox.text,
            success: { () -> () in
                self.closeView()
            }) { (error: NSError) -> () in
                print("post tweet error: ", error.localizedDescription)
        }
    }
    
    // --------------------------------------
    
    private func closeView() {
        self.textBox.text = ""
        self.composeBtn.enabled = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // --------------------------------------

    @IBAction func xClick(sender: AnyObject) {
        self.closeView()
    }
}

extension ComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        
        let stringLength = textView.text.characters.count
        
        if stringLength > 0 {
            self.composeBtn.enabled = true
        } else {
            self.composeBtn.enabled = false
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        //
        print("begin edit")
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        //
        print("end edit")
    }
}
