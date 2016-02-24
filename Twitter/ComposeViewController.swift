//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Julia Yu on 2/23/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadProfileImage(User.currentUser!.profileImageURL!)

        // Do any additional setup after loading the view.
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

    @IBAction func xClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
