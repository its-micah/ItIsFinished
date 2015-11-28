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
    var objectCount = 0
    var feedArrayCount = 0
    var followeeCount: Int?
    var quoteOfTheDay: String? = ""

    func loadLibs() -> Array<PFObject> {
        let query = PFQuery(className: "MadLib")
        query.orderByDescending("createdAt")
        query.cachePolicy = .CacheThenNetwork
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in

            if let objects = objects {
                self.objectCount = objects.count
            }

            if error == nil && self.objectCount > 0 {
                print("received \(objects?.count) madlibs")
                self.feedArray.removeAll()
                for madLib in objects! {
                    self.feedArray.append(madLib)
                }

                self.feedArrayCount = self.feedArray.count
                self.objectCount = 0
            }
            self.delegate?.finishedGatheringData()

        }
        return feedArray
    }



    func loadUserLibsWithUser(profileUser: User) -> Array<PFObject> {

        let query = PFQuery(className: "MadLib")
        query.whereKey("user", equalTo: profileUser)
        query.orderByDescending("createdAt")
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

    func loadFollowingLibs() -> Array<PFObject> {
        if MadLibManager.sharedInstance.currentUser != nil {

            let query = PFQuery(className: "Follow")
            query.whereKey("from", equalTo: MadLibManager.sharedInstance.currentUser!)

            let libsFromFollowers = PFQuery(className: "MadLib")
            libsFromFollowers.whereKey("user", matchesKey: "to", inQuery: query)

            let libsFromCurrentUser = PFQuery(className: "MadLib")
            libsFromCurrentUser.whereKey("user", equalTo: MadLibManager.sharedInstance.currentUser!)

            let finalQuery = PFQuery.orQueryWithSubqueries([libsFromFollowers, libsFromCurrentUser])
            finalQuery.orderByDescending("createdAt")
            finalQuery.cachePolicy = .CacheThenNetwork

            finalQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil && objects?.count > 0 {
                    print("received \(objects?.count) madlibs")
                    self.feedArray.removeAll()
                    for madLib in objects! {
                        self.feedArray.append(madLib)
                    }
                    self.delegate?.finishedGatheringData()
                }
            }
        }

        return feedArray
    }

    func loadQuoteOfDay() {
        let query = PFQuery(className: "Quote")

        // this is the number of days to add or subtract from today to test with
        let daysToAdd = 3
        let testingDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: daysToAdd, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))

        // this is a testing where clause
        //query.whereKey("StartDate", greaterThan: testingDate!)

        // this is the production where clause
        query.whereKey("StartDate", greaterThan: NSDate())

        query.orderByAscending("StartDate")
        query.limit = 1;
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects?.count > 0 {
                print("received \(objects?.count) quote")
                self.quoteOfTheDay = objects![0].objectForKey("Quote") as? String
                self.delegate?.finishedGatheringData()
            }
        }
    }

    func getQuoteOfDay() -> String {
        return self.quoteOfTheDay!
    }

    func finishedGatheringData() -> Array<PFObject> {
        return feedArray
    }
}