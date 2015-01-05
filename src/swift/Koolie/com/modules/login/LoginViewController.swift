//
//  LoginViewController.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-02.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController:FormViewController
{
    
    @IBOutlet var usernameField:UITextField?
    @IBOutlet var passwordField:UITextField?
    @IBOutlet var signInButton:UIButton?
    @IBOutlet var registerButton:UIButton?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // hide nav bar
        self.navigationController?.navigationBarHidden = true
        
        self.formContainer?.backgroundColor = UIColor.clearColor()
        self.usernameField?.delegate = self
        self.passwordField?.delegate = self
        
        //pre-populate with user preferences if available
        let savedUserName:String? = UserPreferencesService.getPreference(Constants.USER_PREFERNCES_KEYS.USERNAME) as? String
        self.usernameField?.text = savedUserName
        
        let savedPassword:String? = UserPreferencesService.getPreference(Constants.USER_PREFERNCES_KEYS.PASSWORD) as? String
        self.passwordField?.text = savedPassword
        
        //hide views so logged in user will bypass without seeing login
        self.formContainer?.hidden = true
        self.registerButton?.hidden = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //if already logged in, send user to home
        let completionHandler:() -> Void = {() -> Void in
            self.formContainer?.hidden = false
            self.registerButton?.hidden = false
        }
        
        let user:PFUser? = LoginService.getCurrentUser()
        DebugService.print("Current user: \(user)")
        if user != nil {
            self.goToHome(completionHandler)
        } else {
            completionHandler()
        }
    }
    
    @IBAction func onSignInButton(sender:AnyObject?)
    {
        self.performAction({() -> Void in
            self.login()
        })
    }
    
    @IBAction func onRegisterButton(sender:AnyObject?) {
        self.performAction({() -> Void in
            let storyboard:UIStoryboard = UIStoryboard(name: "Register", bundle: nil)
            let controller:UIViewController = storyboard.instantiateInitialViewController() as UIViewController
            self.navigationController?.pushViewController(controller, animated: true)
        })
    }
    
    // perform login
    private func login()
    {
        let username:String = self.usernameField!.text
        let password:String = self.passwordField!.text
        let isValid:Bool = self.validate(username, password: password)
        if !isValid
        {
            let msg:String = "Please fill in your user name and password"
            let alert:UIAlertController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
            let ok:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            self.showSpinner()
            LoginService.login(username, password: password, onResult: {(user:PFUser!, error:NSError!) -> Void in
                self.hideSpinner()
                if user != nil
                {
                    self.goToHome(nil)
                    DebugService.print("User is logged in, go to home")
                    
                    //update user preferences with username and password
                    UserPreferencesService.setPreference(Constants.USER_PREFERNCES_KEYS.USERNAME, value: username)
                    UserPreferencesService.setPreference(Constants.USER_PREFERNCES_KEYS.PASSWORD, value: password)
                }
                else {
                    let msg:String = "Either your user name or password is incorrect, please try again."
                    let alert:UIAlertController = UIAlertController(title: "Sorry", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
                    let ok:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(ok)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    // perform logout
    private func logOut() {
        LoginService.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
        DebugService.print("User is now logged out")
    }
    
    //take user to home if logged in
    private func goToHome(completionHandler: (() -> Void)?) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let controller:UIViewController = storyboard.instantiateInitialViewController() as UIViewController
        self.presentViewController(controller, animated: true, completion: completionHandler)
    }
    
    // validate to make sure a username and password have been filled out
    private func validate(username:String, password:String) -> Bool
    {
        if username.isEmpty || password.isEmpty {
            return false
        }
        
        return true
    }
    
    //unwind function
    func unwindToLogin(segue:UIStoryboardSegue) {
        
    }
    
}