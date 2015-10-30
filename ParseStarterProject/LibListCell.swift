//
//  LibListCell.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/22/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

class LibListCell: UITableViewCell {
    
    
    @IBOutlet weak var quoteLabel: UILabel!

    func configureWithQuote(quote: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7

        let attrString = NSMutableAttributedString(string: quote)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        quoteLabel.attributedText = attrString
    }
    
}