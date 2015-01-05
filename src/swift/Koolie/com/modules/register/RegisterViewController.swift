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
            self.submitForm()
        })
    }
    
    @IBAction func onBackButton(sender:AnyObject?) {
        self.performAction({() -> Void in
            self.back()
        })
    }
    
    override func submitForm() {
        self.register()
    }
    
    // register user
    private func register() {
        
    }
    
    // validate to make sure a username and password have been filled out
    private func validate(username:String, password:String) -> Bool
    {
        if username.isEmpty || password.isEmpty {
            return false
        }
        
        return true
    }
    
}