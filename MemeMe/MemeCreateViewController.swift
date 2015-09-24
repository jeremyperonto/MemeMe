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
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    
    struct Meme {
        var topString: String
        var bottomString: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
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
        topMemeTextField.text = "TOP"
        topMemeTextField.delegate = self
        
        bottomMemeTextField.defaultTextAttributes = memeTextAttributes //Overrides customizations to textFields, must be first.
        bottomMemeTextField.textAlignment = NSTextAlignment.Center
        bottomMemeTextField.text  = "BOTTOM"
        bottomMemeTextField.delegate = self
        
        view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //Uses NSNotificationCenter to listen for TextField interaction and move the keyboard
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
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

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.imagePickerView.image = image
                imagePickerView.contentMode = .ScaleAspectFit //NOTE: is this the right place?
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Cancelled")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("textFieldDidBeginEditing")
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Dismisses keyboard when user preseses return
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) { //Uses notification center to listen for keyboard
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        if bottomMemeTextField.editing {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            return keyboardSize.CGRectValue().height
        }
        else {
            return 0
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        //TODO: Fix toolbar
        //toolbar.frame.origin.y = 0
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topString: topMemeTextField.text!, bottomString: bottomMemeTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        //TODO: Add to memes array in AppDelegate
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar -- DOUBLE CHECK
        self.toolbar.hidden = true
        self.navbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar -- DOUBLE CHECK
        self.toolbar.hidden = false
        self.navbar.hidden = false
        
        return memedImage
    }
    
    @IBAction func shareMemeButtonPressed(sender: UIBarButtonItem) {
        
        let memedImage = self.generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                self.save(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
        
        topMemeTextField.text = "TOP"
        bottomMemeTextField.text = "BOTTOM"
        imagePickerView.image = nil
        
    }
    
}


