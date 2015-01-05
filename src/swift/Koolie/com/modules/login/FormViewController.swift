//
//  FormViewController.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-05.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class FormViewController:UIViewController, UITextFieldDelegate
{
    
    @IBOutlet var formContainer:UIView?
    
    private var originalPoint:CGPoint?
    private var spinner:SpinnerOverlay?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let notif:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        notif.addObserver(self, selector: "onKeyboardShow:", name: UIKeyboardDidShowNotification, object: nil)
        notif.addObserver(self, selector: "onKeyboardHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let notif:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        notif.removeObserver(self)
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
            self.performAction({() -> Void in
                self.submitForm()
            })
        }
        return true
    }
    
    // to be overridden when the form is submitted
    func submitForm() {
        
    }
    
    // perform an action after form resigns first responder
    func performAction(action:(() -> Void)?) {
        let field:AnyObject? = self.getFirstResponder()
        field?.resignFirstResponder()
        
        if field != nil {
            TimeUtils.performAfterDelay(0.5, completionHandler: {() -> Void in
                if action != nil {
                    action?()
                }
            })
        }
        else {
            action?()
        }
    }
    
    // get the element that is currently the first responder
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
        
        for var i:Int=0; i<self.formContainer?.subviews.count; i++ {
            var subview:UIView = self.formContainer?.subviews[i] as UIView
            if subview.isFirstResponder() {
                return subview
            }
        }
        
        return nil
    }
    
    // go back a screen, remove controller from parent nav controller
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showSpinner() {
        self.hideSpinner()
        self.spinner = SpinnerOverlay()
        self.spinner?.addToParentView(self.view)
    }
    
    func hideSpinner() {
        self.spinner?.removeFromSuperview()
    }
    
}