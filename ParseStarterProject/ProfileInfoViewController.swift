//
//  ProfileInfoViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 10/21/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import UIKit

class ProfileInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let imagePicker = UIImagePickerController()



    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("showCameraPicker"))
        avatarImageView.userInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapRecognizer)
        imagePicker.delegate = self
    }
    
    @IBAction func onDoneButtonTapped(sender: AnyObject) {
        let newUser = MadLibManager.sharedInstance.currentUser
        
        newUser.fullName = nameTextField.text
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        let imageData = avatarImageView.image?.lowestQualityJPEGNSData
        let imageFile = PFFile(name: "profilePic.jpg", data: imageData!)
        newUser.profilePicture = imageFile
        newUser.convertToImageWithPFFile(imageFile)
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    func showCameraPicker() {
        print("tapped")
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImageView.contentMode = .ScaleAspectFill
            avatarImageView.image = pickedImage
        }

        dismissViewControllerAnimated(true, completion: nil)
    }
    
}