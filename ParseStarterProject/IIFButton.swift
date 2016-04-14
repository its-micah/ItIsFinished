//
//  IIFButton.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 1/16/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation

class IIFButton: UIButton {


    override var highlighted: Bool {
        didSet {
            if highlighted {
                self.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 142/255, alpha: 1)
            } else {
                self.backgroundColor = UIColor.clearColor()
            }
        }
    }

}