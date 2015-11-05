//
//  LibsListViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import SVProgressHUD
import Parse
import UIKit

@IBDesignable class CreateLibViewController: UIViewController {
    
    @IBInspectable @IBOutlet weak var madLibText: UILabel!
    @IBOutlet weak var textField: UITextField!
    var libText: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10

        let attrString = NSMutableAttributedString(string: libText!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        madLibText.attributedText = attrString

    }

    override func viewDidDisappear(animated: Bool) {
        textField.text = ""
    }
    
    @IBAction func onSubmitButtonTapped(sender: AnyObject) {
        view.endEditing(true)
        SVProgressHUD.show()
        let newLib = MadLib(labelText: madLibText.text!, userText: textField.text!)
        newLib.user = PFUser.currentUser() as! User
        newLib.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("MadLib saved")
                self.navigationController?.popToRootViewControllerAnimated(true)
            } else {
                print("\(error?.debugDescription)")
            }
        }
    }
    
}