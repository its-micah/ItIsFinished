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
import ParseTwitterUtils

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

    @IBAction func onTwitterButtonTapped(sender: AnyObject) {

        PFTwitterUtils.logInWithBlock {
            (user: PFUser?, var error: NSError?) -> Void in
            if var user = user {
                if user.isNew {
                    SVProgressHUD.show()
                    print("User signed up and logged in with Twitter!")
                    let newUser = MadLibManager.sharedInstance.currentUser
                    let twitterUsername = PFTwitterUtils.twitter()?.screenName
                    newUser.username = twitterUsername
    
                    let requestString = ("https://api.twitter.com/1.1/users/show.json?screen_name=" + twitterUsername!)

                    let verify: NSURL = NSURL(string: requestString)!

                    let request: NSMutableURLRequest = NSMutableURLRequest(URL: verify)

                    PFTwitterUtils.twitter()?.signRequest(request)

                    var response: NSURLResponse?

                    do {
                        let data: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                        let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                        let urlString = result.objectForKey("profile_image_url_https") as! String
                        let hiResUrlString = urlString.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)


                        let twitterPhotoUrl = NSURL(string: hiResUrlString)
                        let imageData = NSData(contentsOfURL: twitterPhotoUrl!)

                        let imageFile = PFFile(name: "profilePic.jpg", data: imageData!)
                        newUser.profilePicture = imageFile
                        newUser.convertToImageWithPFFile(imageFile)

                        newUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                            if success {
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        })

                    } catch {
                        print("error with synchronouss request")
                    }


                } else {
                    print("User logged in with Twitter!")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }

            } else {

                print("Uh oh. The user cancelled the Twitter login.")

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
