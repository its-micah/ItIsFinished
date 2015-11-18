//
//  SearchViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/22/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DataProtocol {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchResults = [PFObject]()
    var selectedUser: User? = nil



    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self


    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCellWithIdentifier("cell") as! SearchCell
        let user = searchResults[indexPath.row] as! User
        cell.delegate = self
        cell.textLabel?.text = user.username
        cell.getImage(user.profilePicture!)

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        queryWithString(searchBar.text!)
        searchBar.resignFirstResponder()
    }

    func updateTableView() {
        searchTableView.reloadData()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        let foundUser = searchResults[indexPath.row] as! User
        profileVC.previousViewController = "FeedViewController"
        profileVC.user = foundUser
        self.navigationController?.pushViewController(profileVC, animated: true)

    }

    func queryWithString(searchText: String) {
        let query = PFUser.query()
        query!.whereKey("username", equalTo: searchText)
        query!.whereKey("username", containsString: searchText)
        query!.getFirstObjectInBackgroundWithBlock { (foundUser: PFObject?, error: NSError?) -> Void in
            if foundUser != nil {
                self.searchResults.append(foundUser!)
                self.searchTableView.reloadData()
                
            } else {
                let alertView = UIAlertController(title: "WOAH NOW", message: "That user doesn't exist.", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }

    }


}