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
}


class NetworkManager {

    static let sharedInstance = NetworkManager()
    var userFeedArray: Array<PFObject> = [PFObject]()
    var delegate: NetworkProtocol?

    func loadUserLibsWithUser(profileUser: User) -> Array<PFObject> {
        let query = PFQuery(className: "MadLib")
        query.whereKey("user", equalTo: profileUser)
        query.orderByDescending("createdAt")
        query.cachePolicy = .CacheThenNetwork
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects?.count != 0 {
                print("received \(objects?.count) madlibs")
                self.userFeedArray.removeAll()
                for var madLib in objects! {
                    self.userFeedArray.append(madLib)
                }
                self.delegate?.finishedGatheringData()
            }
        }
        return userFeedArray
    }



}