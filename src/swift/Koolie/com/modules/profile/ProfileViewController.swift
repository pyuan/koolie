//
//  ProfileViewController.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-05.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class ProfileViewController:FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    enum ValidationResult:Int {
        case NoUserNameError
        case NoEmailError
        case PasswordsMisMatchError
        case NoError
    }
    
    @IBOutlet var usernameField:UITextField?
    @IBOutlet var passwordField:UITextField?
    @IBOutlet var confirmPasswordField:UITextField?
    @IBOutlet var emailField:UITextField?
    @IBOutlet var updateButton:UIButton?
    @IBOutlet var revertButton:UIButton?
    @IBOutlet var profileImage:ProfileImageButton?
    
    private var updateProfileImage:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formContainer?.backgroundColor = UIColor.clearColor()
        self.usernameField?.delegate = self
        self.passwordField?.delegate = self
        self.confirmPasswordField?.delegate = self
        self.emailField?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.revert(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.revert(true)
    }
    
    @IBAction func onUpdateButton(sender:AnyObject?) {
        self.performAction({() -> Void in
            self.update()
        })
    }
    
    @IBAction func onBackButton(sender:AnyObject?) {
        self.performAction({() -> Void in
            self.back()
        })
    }
    
    @IBAction func onRevertButton(sender:AnyObject?) {
        self.performAction({() -> Void in
            self.revert(true)
        })
    }
    
    @IBAction func onProfileImage(sender:AnyObject?) {
        self.performAction({() -> Void in
            let alert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let takePhoto:UIAlertAction = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
                self.showImagePicker(UIImagePickerControllerSourceType.Camera)
            })
            let choosePhoto:UIAlertAction = UIAlertAction(title: "Choose a Photo", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
                self.showImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
            })
            let deletePhoto:UIAlertAction = UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.Destructive, handler: {(action:UIAlertAction!) -> Void in
                self.profileImage?.imageURL = ""
                self.updateProfileImage = true
            })
            let cancel:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(takePhoto)
            alert.addAction(choosePhoto)
            alert.addAction(deletePhoto)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    // open the imagepickercontroller with the specified type
    private func showImagePicker(type:UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let picker:UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = type
            picker.mediaTypes = [kUTTypeImage]
            self.presentViewController(picker, animated: true, completion: nil)
        } else {
            let alert:UIAlertController = UIAlertController(title: nil, message: "Photo source not available.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: UIImagePickerController delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: {() -> Void in
            let chosenImage:UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
            self.profileImage?.setImage(chosenImage, forState: UIControlState.Normal)
            self.updateProfileImage = true
        })
    }
    
    // revert fields to saved user data, only load profile image when the view did appear for slow network connection
    private func revert(loadProfileImage:Bool) {
        let user:PFUser = LoginService.getCurrentUser()!
        self.usernameField?.text = user.username
        self.emailField?.text = user.email
        self.passwordField?.text = user.password
        self.confirmPasswordField?.text = ""
        
        if loadProfileImage {
            let file:PFFile? = user["image"] as? PFFile
            if file != nil {
                self.profileImage?.imageURL = file!.url
            } else {
                self.profileImage?.imageURL = ""
            }
        }
    }
    
    // register user
    private func update()
    {
        let username:String = self.usernameField!.text
        let email:String = self.emailField!.text
        let password:String = self.passwordField!.text
        let confirmpassword:String = self.confirmPasswordField!.text
        let result:ValidationResult = self.validate(username, email: email, password: password, confirmPassword: confirmpassword)
        
        if result != ValidationResult.NoError
        {
            var msg:String = ""
            switch result {
            case ValidationResult.NoUserNameError:
                msg = "Please fill in your user name."
                break
            case ValidationResult.NoEmailError:
                msg = "Please fill in your email."
                break
            case ValidationResult.PasswordsMisMatchError:
                msg = "Please make sure your confirmed new password matches your new password."
                break
            default:
                break
            }
            
            let alert:UIAlertController = UIAlertController(title: "Sorry", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
            let ok:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            DebugService.print("No validation error, updating user...")
            self.showSpinner()
            
            let imageData:NSData? = self.profileImage!.isDefaultImage() ? nil : UIImagePNGRepresentation(self.profileImage?.imageView?.image)
            LoginService.updateUser(username, password: password, imageData: imageData, updateProfileImage: self.updateProfileImage, onUpdate: {() -> Void in
                
                self.back()
                
                }, onError: {(error:NSError!) -> Void in
                    
                    let msg:String = "An error occurred while updating your user, please try again"
                    let alert:UIAlertController = UIAlertController(title: "Sorry", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
                    let ok:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(ok)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
            })
        }
    }
    
    // validate to make sure a username and password have been filled out
    private func validate(username:String, email:String, password:String, confirmPassword:String) -> ValidationResult
    {
        if username.isEmpty {
            return ValidationResult.NoUserNameError
        }
        
        if email.isEmpty {
            return ValidationResult.NoEmailError
        }
        
        if password != confirmPassword {
            return ValidationResult.PasswordsMisMatchError
        }
        
        return ValidationResult.NoError
    }
    
}