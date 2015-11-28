//
//  Quote.swift
//  ParseStarterProject-Swift
//
//  Created by Mick Lerche on 11/21/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class Quote: PFObject, PFSubclassing {

    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }

    static func parseClassName() -> String {
        return "Quote"
    }

    @NSManaged var Quote: String!

}