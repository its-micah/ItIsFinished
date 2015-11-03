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

class ProfileViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NetworkProtocol {

    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    var userFeedArray: Array<PFObject> = [PFObject]()
    let imagePicker = UIImagePickerController()
    var tapRecog: UITapGestureRecognizer = UITapGestureRecognizer()
    var reusableView = ProfileHeaderReusableView()
    var previousViewController: String?
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
        if previousViewController != "FeedViewController" {
            user = MadLibManager.sharedInstance.currentUser
            backButton.enabled = false
            backButton.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        } else {
            editButton.enabled = false
            editButton.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }

        NetworkManager.sharedInstance.loadUserLibsWithUser(user!)
    }

    func finishedGatheringData() {
        userFeedArray = NetworkManager.sharedInstance.userFeedArray
        self.collectionView?.reloadData()
    }

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

        if user == MadLibManager.sharedInstance.currentUser {
            tapRecog.addTarget(self, action: Selector("showImageGallery"))
            reusableView.overlayView.addGestureRecognizer(tapRecog)
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

        user?.bannerPicture?.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
            if imageData != nil {
                self.reusableView.bannerImageView.image = UIImage(data: imageData!)
            } else {
                print("no banner image found")
            }
        })

        return reusableView
    }

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
    
}