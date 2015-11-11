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

        if textField.text == "" {

            let alertView = UIAlertController(title: "WOAH NOW", message: "You didn't finish it!", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK, Whatever", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)

        } else {
            view.endEditing(true)
            let newLib = MadLib(labelText: madLibText.text!, userText: textField.text!)
            newLib.user = PFUser.currentUser() as! User
            newLib.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if success {
                    SVProgressHUD.show()
                    print("MadLib saved")
                    self.tabBarController?.selectedIndex = 0
                    let firstNavController = self.tabBarController?.selectedViewController as! UINavigationController
                    firstNavController.popToRootViewControllerAnimated(true)
                } else {
                    print("\(error?.debugDescription)")
                }
            }
        }
    }
    
}