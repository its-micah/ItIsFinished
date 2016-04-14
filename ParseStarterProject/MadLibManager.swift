//
//  MadLibManager.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class MadLibManager {
    
    static let sharedInstance = MadLibManager()

    var currentUser = PFUser.currentUser() as? User
    var quoteOfDay: String?
    var libCreated: Bool?

    private init(){
        print("")
    }

    func convertToImageWithPFFile(file: PFFile?) {
        file?.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
            if imageData != nil {
                self.currentUser!.profileImage = UIImage(data: imageData!)
            }
        })
    }


    func getQuoteOfDay() -> String {
        quoteOfDay = NetworkManager.sharedInstance.getQuoteOfDay()
        return quoteOfDay!
    }


    
}