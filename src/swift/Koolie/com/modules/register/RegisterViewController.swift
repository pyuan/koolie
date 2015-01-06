//
//  RegisterViewController.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-05.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController:FormViewController
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
            DebugService.print("No error, register user")
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