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
    private func register() {
        let username:String = self.usernameField!.text
        let email:String = self.emailField!.text
        let password:String = self.passwordField!.text
        let confirmpassword:String = self.confirmPasswordField!.text
        let isValid:Bool = self.validate(username, email: email, password: password, confirmPassword: confirmpassword)
        println(isValid)
    }
    
    // validate to make sure a username and password have been filled out
    private func validate(username:String, email:String, password:String, confirmPassword:String) -> Bool
    {
        if username.isEmpty || email.isEmpty || password.isEmpty {
            return false
        }
        
        if password != confirmPassword {
            return false
        }
        
        return true
    }
    
}