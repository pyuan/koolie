//
//  RegisterViewController.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-05.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class RegisterViewController:FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    enum ValidationResult:Int {
        case NoUserNameError
        case NoEmailError
        case NoPasswordError
        case PasswordsMisMatchError
        case NoError
    }
    
    @IBOutlet var usernameField:UITextField?
    @IBOutlet var passwordField:UITextField?
    @IBOutlet var confirmPasswordField:UITextField?
    @IBOutlet var emailField:UITextField?
    @IBOutlet var signUpButton:UIButton?
    @IBOutlet var profileImage:ProfileImageButton?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.formContainer?.backgroundColor = UIColor.clearColor()
        self.usernameField?.delegate = self
        self.passwordField?.delegate = self
        self.confirmPasswordField?.delegate = self
        self.emailField?.delegate = self
    }
    
    @IBAction func onSignUpButton(sender:AnyObject?) {
        self.performAction({() -> Void in
            self.register()
        })
    }
    
    @IBAction func onBackButton(sender:AnyObject?) {
        self.performAction({() -> Void in
            self.back()
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
                self.profileImage!.imageURL = ""
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
        })
    }
    
    // register user
    private func register()
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
            case ValidationResult.NoPasswordError:
                msg = "Please fill in your password."
                break
            case ValidationResult.PasswordsMisMatchError:
                msg = "Please make sure your confirmed password matches your password."
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
            LoginService.signUpUser(username, password: password, email: email, imageData: imageData, onSignUp: {() -> Void in
                
                self.hideSpinner();
                self.back()
                
                }, onError: {(error:NSError!) -> Void in
                    
                    self.hideSpinner();
                    let msg:String = error.userInfo!["error"] as String
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
        
        if password.isEmpty {
            return ValidationResult.NoPasswordError
        }
        
        if password != confirmPassword {
            return ValidationResult.PasswordsMisMatchError
        }
        
        return ValidationResult.NoError
    }
    
}