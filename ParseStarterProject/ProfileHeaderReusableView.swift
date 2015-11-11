//
//  ProfileHeaderReusableView.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/28/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

protocol FollowProtocol {
    func followUser()
}

class ProfileHeaderReusableView: UICollectionReusableView {

    var delegate : FollowProtocol?

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followView: UIView!
    @IBOutlet weak var followIconImageView: UIImageView!

    @IBOutlet weak var followViewHeight: NSLayoutConstraint!

    var tapRecog: UITapGestureRecognizer = UITapGestureRecognizer()

    func configureWithUserName(name: String) {
        nameLabel.text = name
    }

    func configureWithUserImage(image: UIImage) {
        profileImageView.image = image
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30
    }

    @IBAction func onFollowButtonTapped(sender: AnyObject) {
        print("follow button tapped")

        followButton.transform = CGAffineTransformMakeScale(0.1, 0.1)

        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5.0, options: .AllowUserInteraction, animations: { () -> Void in
            self.followButton.transform = CGAffineTransformIdentity
            }, completion: nil)

        UIView.animateWithDuration(0.2) { () -> Void in
            self.followView.backgroundColor = UIColor(red: 156/255, green: 207/255, blue: 131/255, alpha: 1)
            self.followButton.setTitle("Following", forState: .Normal)
            self.followButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }

        self.delegate?.followUser()

    }

}