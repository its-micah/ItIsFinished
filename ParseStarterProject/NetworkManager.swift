//
//  NetworkManager.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/29/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

protocol NetworkProtocol {
    func finishedGatheringData()
    func endRefresh()
}

class NetworkManager {

    static let sharedInstance = NetworkManager()
    var feedArray: Array<PFObject> = [PFObject]()
    var userFeedArray: Array<PFObject> = [PFObject]()
    var delegate: NetworkProtocol?
    var followeeCount: Int?

    func loadLibs() -> Array<PFObject> {
        let query = PFQuery(className: "MadLib")
        query.orderByDescending("createdAt")
        query.cachePolicy = .CacheThenNetwork
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in

            if error == nil && objects?.count == self.feedArray.count {
                self.delegate?.endRefresh()
            }

            if error == nil && objects?.count > 0 && objects?.count != self.feedArray.count {
                print("received \(objects?.count) madlibs")
                self.feedArray.removeAll()
                for madLib in objects! {
                    self.feedArray.append(madLib)
                }
                self.delegate?.finishedGatheringData()

            }
        }
        return feedArray
    }



    func loadUserLibsWithUser(profileUser: User) -> Array<PFObject> {

        let query = PFQuery(className: "MadLib")
        query.whereKey("user", equalTo: profileUser)
        query.orderByDescending("createdAt")
        query.cachePolicy = .NetworkElseCache
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects?.count != 0 {
                print("received \(objects?.count) madlibs")
                self.userFeedArray.removeAll()

                for madLib in objects! {
                    self.userFeedArray.append(madLib)
                }

                self.delegate?.finishedGatheringData()
            }
        }
        return userFeedArray
    }


    func loadUserLibsWithFollowee(followees: Array<User>) {
        let query = PFQuery(className: "MadLib")
        query.orderByDescending("createdAt")
        query.cachePolicy = .CacheThenNetwork
        for followee in followees {
            query.whereKey("user", equalTo: followee)
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil && objects?.count != 0 {
                    print("received \(objects?.count) madlibs")
                    for madLib in objects! {
                        self.userFeedArray.append(madLib)
                        print(self.userFeedArray.count)
                    }
                }

            }
        }
    }


//    func loadFollowingLibs() {
//        let query = PFQuery(className: "Follow")
//        query.whereKey("from", equalTo: MadLibManager.sharedInstance.currentUser!)
//        query.cachePolicy = .CacheThenNetwork
//        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil && objects?.count > 0 && objects?.count != self.feedArray.count {
//                print("received \(objects?.count) followees")
//                //var followees : Array<User> = []
//                self.feedArray.removeAll()
//                for followee in objects! {
//                    let followedUser = followee.objectForKey("to") as! User
//                    NetworkManager.sharedInstance.loadUserLibsWithUser(followedUser)
//                    //followees.append(followedUser)
//                }
//                // NetworkManager.sharedInstance.loadUserLibsWithFollowee(followees)
//            } else {
//                //self.animateEmptyFeedView()
//            }
//        }
//
//    }

    func loadQuoteOfDay() -> String {
        let quoteOfDay = "If life gives you lemons, make"
        return quoteOfDay
    }


    func finishedGatheringData() -> Array<PFObject> {
        return feedArray
    }



}