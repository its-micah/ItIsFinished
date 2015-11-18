//
//  QuoteOfDayReusableView.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 11/9/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

class QuoteOfDayReusableView: UICollectionReusableView {

    @IBOutlet weak var quoteOfDayLabel: UILabel!

    func configureWithQuote() {

        let quote = MadLibManager.sharedInstance.getQuoteOfDay()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        paragraphStyle.lineSpacing = 8

        let attrString = NSMutableAttributedString(string: quote)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        quoteOfDayLabel.attributedText = attrString
    }


}