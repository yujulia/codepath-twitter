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
    let refreshControl = UIRefreshControl()
    
    var loading: Bool = false

    // --------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
        self.loadTimeline()
        self.setupRefresh()
    }
    
    // -------------------------------------- load the timeline
    
    private func loadTimeline() {
        
        self.isLoading()
        client.homeTimeline({ () -> () in
            self.tableView.reloadData()
            self.notLoading()
        }) { (error: NSError) -> () in
                print("couldnt get tweets", error.localizedDescription)
        }
    }
    
    private func isLoading() {
        self.loading = true
        self.refreshControl.endRefreshing()
    }
    
    private func notLoading() {
        self.loading = false
        self.refreshControl.endRefreshing()
    }
    
    // ------------------------------------------ set up refresh control
    
    private func setupRefresh() {
        self.refreshControl.tintColor = UIColor.blackColor()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
    }
    
    //-------------------------------------------- pull to refresh load data
    
    func refresh(refreshControl: UIRefreshControl) {
        self.loadTimeline()
    }
    
    // -------------------------------------- logout
    
    @IBAction func logoutTapped(sender: UIButton) {
        self.client.logout()
    }
    
    // -------------------------------------- logout
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "TweetDetailSegue" {
            let detailViewController = segue.destinationViewController as! TweetDetailViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let currentCellData = State.homeTweets?[indexPath!.row]
            
            detailViewController.data = currentCellData
        }
        if segue.identifier == "ComposeSegue" {
            let composeViewController = segue.destinationViewController as! ComposeViewController
            composeViewController.delegate = self
            
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                let currentCellData = State.homeTweets?[indexPath!.row]
                composeViewController.replyToTweet = currentCellData
            }
        }
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
        
        if let tweets = State.homeTweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    // --------------------------------------
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        if let cellData = State.homeTweets?[indexPath.row] {
            cell.data = cellData
        }

        cell.delegate = self
    
        return cell
    }
}

// tweet cell delegate

extension TweetsViewController: TweetCellDelegate {
    func tweetCell(tweetCell: TweetCell, didWantToReply value: TweetCell) {

        self.performSegueWithIdentifier("ComposeSegue", sender: value)
    }
}

// compose delegate

extension TweetsViewController: ComposeViewControllerDelegate {
    
    func composeViewController(composeViewController: ComposeViewController, didTweet value: Tweet) {
        
        State.homeTweets?.insert(value, atIndex: 0)
        
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
        self.tableView.endUpdates()
    }
}