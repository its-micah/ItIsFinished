//
//  ProfileHeaderReusableView.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/28/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

class ProfileHeaderReusableView: UICollectionReusableView {


    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var nameLabel: UILabel!


    var tapRecog: UITapGestureRecognizer = UITapGestureRecognizer()

    func configureWithUserName(name: String) {
        nameLabel.text = name
    }

    func configureWithUserImage(image: UIImage) {
        profileImageView.image = image
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30
    }


}