//
//  MadLib.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//


import Foundation
import Parse

class MadLib: PFObject, PFSubclassing {
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "MadLib"
    }

    @NSManaged var madLib: String!
    @NSManaged var enteredText: String?
    @NSManaged var newLib: String!
    @NSManaged var user: User!
    @NSManaged var libID: String!

    convenience init(labelText: String, userText: String) {
        self.init()
        madLib = labelText
        enteredText = userText
        newLib = "\(madLib) \(enteredText!)"
    }
    

}