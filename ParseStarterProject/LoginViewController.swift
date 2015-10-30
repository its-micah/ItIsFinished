/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var registerVC: ProfileInfoViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onButtonTapped(sender: AnyObject) {
        let user = User()
        user.username = usernameField.text
        user.password = passwordField.text
        
        User.logInWithUsernameInBackground(user.username!, password: user.password!) { (var user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                SVProgressHUD.show()
                PFQuery.clearAllCachedResults()
                user = MadLibManager.sharedInstance.currentUser
                user?.objectId = user?.valueForKey("objectId") as? String
                self.setUserImage()
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                let alertView = UIAlertController(title: "WOAH NOW", message: "You don't have an account, please register.", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }

       
    }


    func setUserImage() {
        let currentUserImageFile = MadLibManager.sharedInstance.currentUser.profilePicture
        MadLibManager.sharedInstance.currentUser.convertToImageWithPFFile(currentUserImageFile)
    }
    
    @IBAction func onRegisterButtonTapped(sender: AnyObject) {

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
}
