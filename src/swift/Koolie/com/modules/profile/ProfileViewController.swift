//
//  ProfileViewController.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-05.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController:FormViewController
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
        self.updateProfileImage = false
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
    
    // revert fields to saved user data, only load profile image when the view did appear for slow network connection
    private func revert(loadProfileImage:Bool) {
        let user:PFUser = LoginService.getCurrentUser()!
        self.usernameField?.text = user.username
        self.emailField?.text = user.email
        self.passwordField?.text = user.password
        self.confirmPasswordField?.text = ""
        
        if loadProfileImage {
            let file:PFFile? = user["image"] as? PFFile
            if file != nil && self.profileImage!.imageURL != file!.url {
                self.profileImage?.imageURL = file!.url
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
            
            let imageData:NSData? = UIImagePNGRepresentation(self.profileImage?.imageView?.image)
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