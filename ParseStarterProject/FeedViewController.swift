//
//  FeedViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit
import Parse
import ParseTwitterUtils

class FeedViewController: UIViewController,
UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FeedCellProtocol {
    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    @IBOutlet weak var emptyFeedView: UIView!
    var feedArray: Array<PFObject> = [PFObject]()
    var postUser: User?
    var loaded: Bool? = false

    override func viewDidLoad() {
        super.viewDidLoad()
        feedCollectionView.delegate = self
        feedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }

    
    override func viewWillAppear(animated: Bool) {
        loadLibs()
        self.emptyFeedView.alpha = 0
    }

    func loadLibs() {
        let query = PFQuery(className: "MadLib")
        query.orderByDescending("createdAt")
        query.cachePolicy = .CacheThenNetwork
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects?.count > 0 && objects?.count != self.feedArray.count {
                print("received \(objects?.count) madlibs")
                self.feedArray.removeAll()
                for var madLib in objects! {
                    self.feedArray.append(madLib)
                }
                self.feedCollectionView.reloadData()
                SVProgressHUD.dismiss()
            } else {
               self.animateEmptyFeedView()
            }
        }
    
    }
    
    func animateEmptyFeedView() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.emptyFeedView.alpha = 1.0
        })
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(feedCollectionView.frame.size.width/1.05, feedCollectionView.frame.size.height/1.8)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = feedCollectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? FeedCell
        if cell == nil {
            cell = FeedCell()
        }
        cell?.userImageView.image = UIImage(named: "profile")
        cell!.delegate = self
        cell!.configureWithPost(feedArray[indexPath.row])
        postUser = feedArray[indexPath.row].objectForKey("user") as? User
        cell!.configureWithUser(postUser!)
        cell!.addTapRecog()
        return cell!
    }

    func showProfile() {
        let selectedUser = postUser
        selectedUser?.convertToImageWithPFFile(selectedUser?.profilePicture)
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileVC.previousViewController = "FeedViewController"
        profileVC.user = selectedUser
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    
}