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

        if PFUser.currentUser() == nil {

            dispatch_async(dispatch_get_main_queue(), { () -> Void in

                self.presentLogInScreen()

            })

        } else {
            print("did log in")
        }


    }


    
    func presentLogInScreen() {
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("login")
        self.presentViewController(loginVC!, animated: true, completion: nil)
    }
    
}