//
//  User.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/19/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse



class User: PFUser {
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }

    func convertToImageWithPFFile(file: PFFile?) {
        file?.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
            if imageData != nil {
                self.profileImage = UIImage(data: imageData!)
            }
        })
    }
    
    @NSManaged var profilePicture: PFFile?
    @NSManaged var bannerPicture: PFFile?
    @NSManaged var fullName: String?
    @NSManaged var bio: String?
    @NSManaged var website: String?
    var userID: String?
    var profileImage: UIImage?
}