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
import AVFoundation

class FeedViewController: UIViewController,
UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FeedCellProtocol, NetworkProtocol, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    @IBOutlet weak var emptyFeedView: UIView!
    @IBOutlet weak var animationImageView: UIImageView!
    let tapRecog = UITapGestureRecognizer()
    let refreshControl = UIRefreshControl()
    let audioPlayer = AVAudioPlayer()
    let customNavigationAnimationController = CustomNavigationAnimationController()
    var isRefreshing = false
    var feedArray = [PFObject]()
    var postUser: User? = nil
    var loaded: Bool? = false
    var selectedUser: User? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        feedCollectionView.delegate = self
        feedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout

        navigationController?.delegate = self

        refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        feedCollectionView.addSubview(refreshControl)

        NetworkManager.sharedInstance.delegate = self

        let headerNib = UINib(nibName: "QuoteOfDayView", bundle: nil)
        feedCollectionView.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "quoteOfDay")

        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont(name: "Eskapade Fraktur", size: 21)!]
    }

    
    override func viewWillAppear(animated: Bool) {
        refresh()
        self.emptyFeedView.alpha = 0

    }

    override func viewDidAppear(animated: Bool) {
        if MadLibManager.sharedInstance.libCreated == true {
            animateSavedLibView()
        }
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

    func animateSavedLibView() {
        print("animating view now")
        animationImageView.hidden = false

//        if let soundURL = NSBundle.mainBundle().URLForResource("thunder", withExtension: "mp3") {
//            var mySound: SystemSoundID = 0
//            AudioServicesCreateSystemSoundID(soundURL, &mySound)
//            // Play
//            AudioServicesPlaySystemSound(mySound);
//        }


        animationImageView.alpha = 1
        var imagesArray = [UIImage]()
        for name in ["savedLibAnimation_0.png", "savedLibAnimation_1.png", "savedLibAnimation_2.png", "savedLibAnimation_3.png", "savedLibAnimation_4.png", "savedLibAnimation_5.png", "savedLibAnimation_6.png", "savedLibAnimation_7.png", "savedLibAnimation_8.png", "csavedLibAnimation_9.png","savedLibAnimation_10.png", "savedLibAnimation_11.png", "savedLibAnimation_12.png", "savedLibAnimation_13.png", "savedLibAnimation_14.png", "savedLibAnimation_15.png", "savedLibAnimation_16.png", "savedLibAnimation_17.png", "savedLibAnimation_18.png", "savedLibAnimation_19.png", "csavedLibAnimation_20.png", "savedLibAnimation_21.png", "savedLibAnimation_22.png", "savedLibAnimation_23.png", "savedLibAnimation_24.png", "savedLibAnimation_25.png", "savedLibAnimation_26.png", "savedLibAnimation_27.png", "savedLibAnimation_28.png", "savedLibAnimation_29.png", "savedLibAnimation_30.png"] {
            if let image = UIImage(named: name) {
                imagesArray.append(image)
            }
        }

        animationImageView.animationImages = imagesArray
        animationImageView.animationDuration = 0.8
        animationImageView.animationRepeatCount = 1
        animationImageView.startAnimating()


        MadLibManager.sharedInstance.libCreated = false
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

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customNavigationAnimationController.reverse = operation == .Pop
        return customNavigationAnimationController
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