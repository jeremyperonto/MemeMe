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
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func takePhotoButtonPressed(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func selectPhotoButtonPressed(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)

    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imagePickerView.image = image
                imagePickerView.contentMode = .ScaleAspectFit //NOTE: is this the right place?
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Cancelled")
        dismissViewControllerAnimated(true, completion: nil)
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
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
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
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topString: topMemeTextField.text!, bottomString: bottomMemeTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        //Add to memes array in AppDelegate
        
        //Alternate to below [TEST]: (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        toolbar.hidden = true
        navbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        toolbar.hidden = false
        navbar.hidden = false
        
        return memedImage
        
    }
    
    @IBAction func shareMemeButtonPressed(sender: UIBarButtonItem) {
        
        if imagePickerView.image != nil {
            
            let memedImage = generateMemedImage()
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
        else {
            let alertController = UIAlertController(title: "Hold up", message: "Be sure to make the meme your own before sharing", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
        }
        
    }
    
        @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
            
            topMemeTextField.text = "TOP"
            bottomMemeTextField.text = "BOTTOM"
            imagePickerView.image = nil
            
        }
}


