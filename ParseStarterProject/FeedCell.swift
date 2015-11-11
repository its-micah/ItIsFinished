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
    func showSharingWithImageAndText(image: UIImage, text: String)
    var selectedUser: User? {get set}
}
 

class FeedCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: PFImageView!
    @IBOutlet weak var feedCellLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var delegate : FeedCellProtocol?
    let tapRecog = UITapGestureRecognizer()
    var postUser: User?

    override func prepareForReuse() {
        super.prepareForReuse()
        FeedViewController().postUser = nil

    }

    func configureWithPost(post: PFObject) {
        let lib = post.objectForKey("newLib") as? String
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 9

        let attrString = NSMutableAttributedString(string: lib!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        feedCellLabel.attributedText = attrString

        if postUser != nil {

            postUser!.fetchIfNeededInBackgroundWithBlock { (user: PFObject?, error: NSError?) -> Void in
                let name = user!.objectForKey("username") as! String
                self.userNameLabel.text = name
                let image = user!.objectForKey("profilePicture") as! PFFile
                self.configureWithImage(image)
            }
        }

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

    @IBAction func shareButtonTapped(sender: AnyObject) {
        print("tapped cell")
        UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height))
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        self.layer.renderInContext(context)
        let screenShot: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        let TwitterText = "#ItIsFinished"
        delegate?.showSharingWithImageAndText(screenShot, text: TwitterText)

    }


    func showProfile() {
        delegate?.selectedUser = postUser
        delegate?.showProfile()
    }

}