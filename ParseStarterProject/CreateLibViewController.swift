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

@IBDesignable class CreateLibViewController: UIViewController, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    @IBInspectable @IBOutlet weak var madLibText: UILabel!
    @IBOutlet weak var textField: UITextField!
    var libText: String?

    @IBOutlet weak var itIsFinishedButton: UIButton!
    @IBOutlet weak var wizardImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6

        let attrString = NSMutableAttributedString(string: libText!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        madLibText.attributedText = attrString

        navigationController?.delegate = self

        itIsFinishedButton.layer.borderWidth = 2.0
        itIsFinishedButton.layer.borderColor = UIColor(red: 150/255, green: 150/255, blue: 142/255, alpha: 1).CGColor

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
                    //SVProgressHUD.show()

                    //Look into ViewModel here

                    print("MadLib saved")
                    self.tabBarController?.selectedIndex = 0
                    let firstNavController = self.tabBarController?.selectedViewController as! UINavigationController
                    MadLibManager.sharedInstance.libCreated = true
                    firstNavController.popToRootViewControllerAnimated(true)
                    //self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print("\(error?.debugDescription)")
                }
            }
        }
    }
    
}