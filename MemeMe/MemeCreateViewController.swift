//
//  MemeCreateViewController.swift
//  MemeMe
//
//  Created by Jeremy Peronto on 7/16/15.
//  Copyright (c) 2015 Jeremy Peronto. All rights reserved.
//

import UIKit

class MemeCreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topMemeTextField: UITextField!
    @IBOutlet weak var bottomMemeTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    
    let memeTextAttributes = [
        
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSBackgroundColorAttributeName : UIColor.clearColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0)
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topMemeTextField.defaultTextAttributes = memeTextAttributes //Overrides customizations to textFields, must be first.
        topMemeTextField.textAlignment = NSTextAlignment.Center
        topMemeTextField.text = "Top"
        
        //TODO: Properly center; adjust height; set char max?
        
        bottomMemeTextField.defaultTextAttributes = memeTextAttributes //Overrides customizations to textFields, must be first.
        bottomMemeTextField.textAlignment = NSTextAlignment.Center
        bottomMemeTextField.text  = "Bottom"
        
        view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
    }
    
    @IBAction func takePhotoButtonPressed(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func selectPhotoButtonPressed(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)

    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.imagePickerView.image = image
                imagePickerView.contentMode = .ScaleAspectFit //NOTE: is this the right place?
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        println("Cancelled")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "Top" || textField.text == "Bottom" {
            textField.text == ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //TODO: Dismiss keyboard when user preses return
        textField.resignFirstResponder()
        //bottomMemeTextField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) { //Uses notification center to listen for keyboard
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribuFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }

}
