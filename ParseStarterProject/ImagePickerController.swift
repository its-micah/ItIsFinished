//
//  ImagePickerController.swift
//  ParseStarterProject-Swift
//
//  Created by Micah Lanier on 11/24/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation


typealias ImageSelectionHandler = (UIImage) -> Void


class ImagePickerController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    weak var presentingViewController: UIViewController?
    let imageView: UIImageView
    private var imageSelectedHandler: ImageSelectionHandler?

    init(presentingViewController: UIViewController, imageView: UIImageView) {
        self.presentingViewController = presentingViewController
        self.imageView = imageView
    }


    func present() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        presentingViewController?.presentViewController(imagePicker, animated: true, completion: nil)
    }

    func onImageSelection(handler: ImageSelectionHandler) {
        imageSelectedHandler = handler
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFill
            imageView.image = pickedImage

            //look

//            let imageData = reusableView.bannerImageView.image!.lowestQualityJPEGNSData
//            let imageFile = PFFile(name: "bannerImage.jpg", data: imageData)
//            user?.bannerPicture = imageFile
//            user?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
//                if success {
//                    print("banner image saved!")
//                    self.bannerChanged = true
//                } else {
//                    print("banner image not saved")
//                }
//            })

            imageSelectedHandler?(pickedImage)

        }

        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }




}