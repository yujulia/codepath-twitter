//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Julia Yu on 2/22/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let ESTIMATE_ROW_HEIGHT: CGFloat = 120.0
    let RESPONSE_LIMIT = 20
    let client = TwitterClient.sharedInstance
    
    var tweets: [Tweet]?
    
    // --------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
        self.loadTimeline()
    }
    
    // -------------------------------------- load the timeline
    
    private func loadTimeline() {
        client.homeTimeline({ (tweetArray: [Tweet]) -> () in
            self.tweets = tweetArray
            self.tableView.reloadData()
            
            }) { (error: NSError) -> () in
                print("couldnt get tweets", error.localizedDescription)
        }
    }
    
    // -------------------------------------- logout
    
    @IBAction func logoutTapped(sender: UIButton) {
        self.client.logout()
    }
}

// table view delegate 

extension TweetsViewController: UITableViewDelegate {
    
    // --------------------------------------
    
    private func setupTable() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = ESTIMATE_ROW_HEIGHT
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // --------------------------------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tweets = self.tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    // --------------------------------------
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.setLabelText(self.tweets![indexPath.row].text as! String)
        
        
        return cell
    }
}