//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/21/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import SCCollectionViewController
import CSStickyHeaderFlowLayout
import Parse
import UIKit

class ProfileViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NetworkProtocol, FollowProtocol {

    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    var userFeedArray = [PFObject]()
    let imagePicker = UIImagePickerController()
    var tapRecog = UITapGestureRecognizer()
    var reusableView = ProfileHeaderReusableView()
    var previousViewController: String?
    var bannerChanged: Bool = false
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        if let layout = self.collectionViewLayout as? CSStickyHeaderFlowLayout {
            layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.bounds.width, 200)
        }

        let headerNib = UINib(nibName: "ProfileHeaderView", bundle: nil)
        self.collectionView?.registerNib(headerNib, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
        NetworkManager.sharedInstance.delegate = self

    }

    override func viewWillAppear(animated: Bool) {

        backButton.enabled = true
        editButton.enabled = true

        if previousViewController != "FeedViewController" {

            user = MadLibManager.sharedInstance.currentUser!
            backButton.enabled = false
            backButton.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        } else {

            editButton.enabled = false
            editButton.tintColor = UIColor(white: 0, alpha: 0)

            if user?.username == MadLibManager.sharedInstance.currentUser?.username {

                user = MadLibManager.sharedInstance.currentUser!
                editButton.enabled = true
                editButton.tintColor = UIColor.whiteColor()

            }

        }

        if let user = user {
            NetworkManager.sharedInstance.loadUserLibsWithUser(user)
        } else {
            print("no user")
        }
        getBannerImage()

    }


    ///-------------------------
    /// MARK: Network Manager Delegate Method
    ///-------------------------

    func endRefresh() {
        print("refresh ended")
    }

    func finishedGatheringData() {
        userFeedArray = NetworkManager.sharedInstance.userFeedArray
        self.collectionView?.reloadData()
    }

    ///-------------------------
    /// MARK: CollectionView Delegate Methods
    ///-------------------------

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userFeedArray.count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width/1.05, collectionView.frame.size.height/1.8)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! FeedCell
        cell.configureWithPost(userFeedArray[indexPath.row])
        return cell
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! ProfileHeaderReusableView
        reusableView.delegate = self

        if user == MadLibManager.sharedInstance.currentUser! {
            tapRecog.addTarget(self, action: Selector("showImageGallery"))
            reusableView.overlayView.addGestureRecognizer(tapRecog)
            reusableView.followView.backgroundColor = UIColor.whiteColor()
            reusableView.followButton.hidden = true
        }
        
        reusableView.configureWithUserName(user!.username!)
        if let userImage = user!.profileImage {
            reusableView.configureWithUserImage(userImage)
        } else {
            user?.profilePicture?.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if imageData != nil {
                    self.reusableView.configureWithUserImage(UIImage(data: imageData!)!)
                }
            })
        }

        getBannerImage()


        return reusableView
    }

    func getBannerImage() {

        user?.bannerPicture?.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
            if imageData != nil {
                self.reusableView.bannerImageView.image = UIImage(data: imageData!)
                self.bannerChanged = false
            } else {
                print("no banner image found")
            }
        })

    }


    ///-------------------------
    /// MARK: Image Picker methods
    ///-------------------------


    func showImageGallery() {
        print("tapped")
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            reusableView.bannerImageView.contentMode = .ScaleAspectFill
            reusableView.bannerImageView.image = pickedImage
            let imageData = reusableView.bannerImageView.image!.lowestQualityJPEGNSData
            let imageFile = PFFile(name: "bannerImage.jpg", data: imageData)
            user?.bannerPicture = imageFile
            user?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if success {
                    print("banner image saved!")
                    self.bannerChanged = true
                } else {
                    print("banner image not saved")
                }
            })

        }

        dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func onBackButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
    }

    func followUser() {
        let otherUser = user
        let follow = PFObject(className: "Follow")
        follow.setObject(MadLibManager.sharedInstance.currentUser!, forKey: "from")
        follow.setObject(otherUser!, forKey: "to")
        follow.saveInBackground()
    }
    
}