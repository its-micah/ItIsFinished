//
//  CellExtensions.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/26/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import UIKit


protocol DataProtocol {

    func updateTableView()

}

class SearchCell : UITableViewCell {
    
    var delegate: DataProtocol?


    func getImage(data: PFFile) {
        data.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            if data != nil {
                self.imageView?.image = UIImage(data: data!)
                self.delegate!.updateTableView()
            }
        }

    }


}


