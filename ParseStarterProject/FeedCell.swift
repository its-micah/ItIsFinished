//
//  FeedCell.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import UIKit

protocol FeedCellProtocol {
    func showProfile()
}
 

class FeedCell: UICollectionViewCell {
    
    @IBOutlet weak var feedCellLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
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

    func configureWithImage(image: PFFile) -> FeedCell {
        image.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
            if imageData != nil {
                self.userImageView.image = UIImage(data: imageData!)
            }
        })
        return self
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