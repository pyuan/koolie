//
//  LoginViewController.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-02.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController:UIViewController, UITextFieldDelegate
{

    @IBOutlet var usernameField:UITextField?
    @IBOutlet var passwordField:UITextField?
    @IBOutlet var loginButton:UIButton?
    @IBOutlet var registerButton:UIButton?
    @IBOutlet var formContainer:UIView?
    
    private var originalPoint:CGPoint?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.formContainer?.backgroundColor = UIColor.clearColor()
        self.usernameField?.delegate = self
        self.passwordField?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        let notif:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        notif.addObserver(self, selector: "onKeyboardShow:", name: UIKeyboardDidShowNotification, object: nil)
        notif.addObserver(self, selector: "onKeyboardHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        //if already logged in, send user to home
        let user:PFUser? = LoginService.getCurrentUser()
        DebugService.print("Current user: \(user)")
        if user != nil {
            self.goToHome()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let notif:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        notif.removeObserver(self)
    }
    
    @IBAction func login(sender:AnyObject?)
    {
        let field:AnyObject? = self.getFirstResponder()
        field?.resignFirstResponder()
        
        if field != nil {
            TimeUtils.performAfterDelay(0.5, completionHandler: {() -> Void in
                self.doLogin()
            })
        }
        else {
            self.doLogin()
        }
    }
    
    @IBAction func register(sender:AnyObject?) {
        self.doRegister()
    }
    
    func onKeyboardShow(notification:NSNotification)
    {
        if self.originalPoint == nil
        {
            let info:[NSObject:AnyObject]  = notification.userInfo!
            let value:AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
            let rawFrame:CGRect = value.CGRectValue()
            let keyboardFrame:CGRect = view.convertRect(rawFrame, fromView: nil)
            self.slideUp(keyboardFrame.height)
        }
    }
    
    func onKeyboardHide(notification:NSNotification)
    {
        if self.originalPoint != nil {
            self.slideBack()
        }
    }
    
    func slideUp(keyboardHeight:CGFloat)
    {
        self.originalPoint = self.view.frame.origin
        let slideUpAmount:CGFloat = keyboardHeight - (self.view.frame.height - (self.formContainer!.frame.origin.y + self.formContainer!.frame.height))
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
            
            self.view.frame.origin = CGPointMake(self.originalPoint!.x, -slideUpAmount)
            
            }, completion: {(finished:Bool) -> Void in })
    }
    
    func slideBack()
    {
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
            
            self.view.frame.origin = self.originalPoint!
            self.originalPoint = nil
            
            }, completion: {(finished:Bool) -> Void in })
    }
    
    //go to the next field when return/next is tapped
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        var tag:Int = textField.tag + 1
        var nextField:UIView? = self.view.viewWithTag(tag)
        if nextField != nil {
            nextField?.becomeFirstResponder()
        }
        else {
            TimeUtils.performAfterDelay(0.5, completionHandler: {() -> Void in
                self.doLogin()
            })
        }
        return true
    }
    
    // perform login after keyboard animates away
    private func doLogin()
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
            LoginService.login(username, password: password, onResult: {(user:PFUser!, error:NSError!) -> Void in
                if user != nil {
                    self.goToHome()
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
    
    //take user to home if logged in
    private func goToHome() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let controller:UIViewController = storyboard.instantiateInitialViewController() as UIViewController
        self.presentViewController(controller, animated: true, completion: nil)
        DebugService.print("User is logged in, go to home")
    }
    
    // validate to make sure a username and password have been filled out
    private func validate(username:String, password:String) -> Bool
    {
        if username.isEmpty || password.isEmpty {
            return false
        }
        
        return true
    }
    
    //perform register after keyboard animates away
    private func doRegister()
    {
        println("register")
    }
    
    //get the element that is currently the first responder
    private func getFirstResponder() -> AnyObject?
    {
        if self.isFirstResponder() {
            return self
        }
        
        for var i:Int=0; i<self.view.subviews.count; i++ {
            var subview:UIView = self.view.subviews[i] as UIView
            if subview.isFirstResponder() {
                return subview
            }
        }
        
        return nil
    }
    
    //unwind function
    func unwindToLogin(segue:UIStoryboardSegue) {
        
    }
    
}