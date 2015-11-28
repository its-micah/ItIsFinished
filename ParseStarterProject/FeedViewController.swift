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
UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FeedCellProtocol, NetworkProtocol {
    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    @IBOutlet weak var emptyFeedView: UIView!
    let tapRecog = UITapGestureRecognizer()
    let refreshControl = UIRefreshControl()
    var isRefreshing = false
    var feedArray = [PFObject]()
    var postUser: User? = nil
    var loaded: Bool? = false
    var selectedUser: User? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        feedCollectionView.delegate = self
        feedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout

        refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        feedCollectionView.addSubview(refreshControl)

        NetworkManager.sharedInstance.delegate = self

        let headerNib = UINib(nibName: "QuoteOfDayView", bundle: nil)
        feedCollectionView.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "quoteOfDay")
    }

    
    override func viewWillAppear(animated: Bool) {
        refresh()
        self.emptyFeedView.alpha = 0
    }


    func refresh() {
        NetworkManager.sharedInstance.loadFollowingLibs()
        NetworkManager.sharedInstance.loadQuoteOfDay()
    }

    func endRefresh() {
        print("refreshing ended")
    }

    func finishedGatheringData() {

        feedArray = NetworkManager.sharedInstance.feedArray

        if feedArray.count > 0 {
            emptyFeedView.alpha = 0
            self.feedCollectionView.reloadData()
            refreshControl.endRefreshing()
        } else {
            animateEmptyFeedView()
        }

    }


    func animateEmptyFeedView() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.emptyFeedView.alpha = 1.0
        })
    }

    func showProfile() {
        selectedUser!.convertToImageWithPFFile(selectedUser!.profilePicture)
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileVC.previousViewController = "FeedViewController"
        profileVC.user = selectedUser
        self.navigationController?.pushViewController(profileVC, animated: true)
    }

    func showSharingWithImageAndText(image: UIImage, text: String) {
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [text, image],
            applicationActivities: nil)
        let presentationController = activityViewController.popoverPresentationController
        presentationController?.sourceView = self.view
        presentationController?.sourceRect = CGRect(
            origin: CGPointZero,
            size: CGSize(width: self.view.frame.width / 1.2, height: self.view.frame.height / 1.2))

        self.presentViewController(activityViewController, animated: true, completion: nil)
    }

    func showCreateLib() {
        print("tapped")

        let createLibVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CreateLibVC") as! CreateLibViewController
        createLibVC.libText = MadLibManager.sharedInstance.quoteOfDay

        self.navigationController?.pushViewController(createLibVC, animated: true)
    }


    ///-------------------------
    /// MARK: CollectionView Delegate Methods
    ///-------------------------


    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(feedCollectionView.frame.size.width/1.05, 200)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(feedCollectionView.frame.size.width/1.05, feedCollectionView.frame.size.height/1.8)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = feedCollectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! FeedCell
        cell.userImageView.image = UIImage(named: "profile")
        cell.userNameLabel.text = ""
        cell.userImageView.image = nil
        cell.delegate = self
        cell.postUser = nil
        cell.postUser = feedArray[indexPath.row].objectForKey("user") as? User
        cell.configureWithPost(feedArray[indexPath.row])
        cell.addTapRecog()
        cell.setNeedsLayout()
        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "quoteOfDay", forIndexPath: indexPath) as! QuoteOfDayReusableView
        reusableView.configureWithQuote()
        tapRecog.addTarget(self, action: Selector("showCreateLib"))
        reusableView.addGestureRecognizer(tapRecog)
        return reusableView
    }

    
    
}