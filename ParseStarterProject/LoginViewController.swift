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

    override func viewWillAppear(animated: Bool) {
        if MadLibManager.sharedInstance.currentUser != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
            SVProgressHUD.dismiss()
        }
    }


    @IBAction func onTwitterButtonTapped(sender: AnyObject) {

        PFTwitterUtils.logInWithBlock {(user: PFUser?, error: NSError?) -> Void in

            if let user = user {

                if user.isNew {

                    let userID = PFTwitterUtils.twitter()?.userId
                    let twitterUsername = PFTwitterUtils.twitter()?.screenName
                    user.username = twitterUsername

                    var requestString = ("https://api.twitter.com/1.1/users/show.json?")

                    if userID!.characters.count > 0 {
                        requestString = requestString.stringByAppendingString("user_id=" + userID!)
                    } else if (twitterUsername?.characters.count > 0) {
                        requestString = requestString.stringByAppendingString("screen_name=" + twitterUsername!)
                    } else {
                        let alertView = UIAlertController(title: "WOAH NOW", message: "Something went wrong", preferredStyle: .Alert)
                        alertView.addAction(UIAlertAction(title: "OK, Whatever", style: .Default, handler: nil))
                        self.presentViewController(alertView, animated: true, completion: nil)
                        return;
                    }

                    let verify: NSURL = NSURL(string: requestString)!

                    let request: NSMutableURLRequest = NSMutableURLRequest(URL: verify)

                    PFTwitterUtils.twitter()?.signRequest(request)

                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
                        completionHandler:{(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                SVProgressHUD.show()
                                do {
                                    let newUser = user as! User
                                    let result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                                    let urlString = result.objectForKey("profile_image_url_https") as! String
                                    let hiResUrlString = urlString.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                    let twitterPhotoUrl = NSURL(string: hiResUrlString)
                                    let imageData = NSData(contentsOfURL: twitterPhotoUrl!)
                                    let twitterImage = UIImage(data: imageData!)
                                    let compressedImage = twitterImage?.highQualityJPEGNSData
                                    let imageFile = PFFile(name: "profilePic.jpg", data: compressedImage!)
                                    newUser.profilePicture = imageFile

                                    newUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                        if success {
                                            MadLibManager.sharedInstance.currentUser = newUser
                                            MadLibManager.sharedInstance.currentUser!.convertToImageWithPFFile(imageFile)
                                            SVProgressHUD.dismiss()
                                            self.dismissViewControllerAnimated(true, completion: nil)
                                        }
                                    })

                                }

                                catch {
                                    print(error)
                                }
                                
                            }
                    })


                } else {
                    print("User logged in with Twitter!")
                    self.dismissViewControllerAnimated(true, completion: nil)
                    MadLibManager.sharedInstance.currentUser = (user as! User)

                }

            }

        }


    }





    func setUserImage() {
        let currentUserImageFile = MadLibManager.sharedInstance.currentUser!.profilePicture
        MadLibManager.sharedInstance.currentUser!.convertToImageWithPFFile(currentUserImageFile)
    }
    
    @IBAction func onRegisterButtonTapped(sender: AnyObject) {

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
}
