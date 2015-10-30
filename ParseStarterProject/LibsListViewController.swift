//
//  LibsListViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/22/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit

class LibsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var libTableView: UITableView!
    var quotesArray = []
    var selectedQuote: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libTableView.delegate = self
        configureTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        libTableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let path = NSBundle.mainBundle().pathForResource("Quotes", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        
        quotesArray = dict!.objectForKey("Quotes") as! Array<String>
    }
    
    func configureTableView() {
        libTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //MARK : UITableViewDelegate
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 75
        return tableView.estimatedRowHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! LibListCell
        cell.configureWithQuote(quotesArray[indexPath.row] as! String)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotesArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedQuote = quotesArray[indexPath.row] as! String
        let createLibVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CreateLibVC") as! CreateLibViewController
        createLibVC.libText = selectedQuote
        self.navigationController?.pushViewController(createLibVC, animated: true)
    }
    
    
    
}