//
//  FeedCell.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

protocol FeedCellProtocol {
    func showProfile()
}
 

class FeedCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: PFImageView!
    @IBOutlet weak var feedCellLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var delegate : FeedCellProtocol?
    let tapRecog = UITapGestureRecognizer()

    func configureWithPost(post: PFObject) -> FeedCell {
        let lib = post.objectForKey("newLib") as? String
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 9

        let attrString = NSMutableAttributedString(string: lib!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        feedCellLabel.attributedText = attrString
        return self
    }

    func configureWithUser(postUser: User) -> FeedCell {
        postUser.fetchInBackgroundWithBlock { (user: PFObject?, error: NSError?) -> Void in
            let name = postUser.objectForKey("username") as! String
            self.userNameLabel.text = name
            let image = postUser.objectForKey("profilePicture") as! PFFile
            self.configureWithImage(image)
        }
        return self
    }

    func configureWithImage(image: PFFile) {
        userImageView.image = UIImage(named: "profile-1")
        userImageView.file = image
        userImageView.loadInBackground()
    }

    func addTapRecog() {
        userImageView.userInteractionEnabled = true
        tapRecog.addTarget(self, action: Selector("showProfile"))
        userImageView.addGestureRecognizer(tapRecog)
    }

    func showProfile() {
        delegate?.showProfile()
    }

}