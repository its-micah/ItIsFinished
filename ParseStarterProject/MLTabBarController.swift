//
//  MLTabBarController.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import SVProgressHUD
import Parse
import UIKit

class MLTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUserLogin()
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setDefaultStyle(.Custom)

        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.lightGrayColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
            if let selectedImage = item.selectedImage {
                item.selectedImage = selectedImage.imageWithColor(UIColor.darkGrayColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
    
    
    func checkUserLogin() {
    
        let userName = ""
        let password = ""
        
        User.logInWithUsernameInBackground(userName, password: password) { (var user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("did log in")
                user = MadLibManager.sharedInstance.currentUser
            } else {
                self.presentLogInScreen()
            }
        }
    
    }


    
    func presentLogInScreen() {
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("login")
        self.presentViewController(loginVC!, animated: true, completion: nil)
    }
    
}