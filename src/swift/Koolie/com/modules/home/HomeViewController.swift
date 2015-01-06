//
//  HomeViewController.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-03.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController:UIViewController
{
    
    @IBOutlet var profileButton:UIButton?
    @IBOutlet var logoutButton:UIButton?
    @IBOutlet var profileImage:ProfileImageButton?
    
    // load profile image with the logged in user
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // hide nav controller
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // load user profile image, only reload if image is different
        let user:PFUser! = LoginService.getCurrentUser()
        let file:PFFile? = user["image"] as? PFFile
        if file != nil && self.profileImage!.imageURL != file!.url {
            self.profileImage?.imageURL = file!.url
        } else if file == nil {
            self.profileImage?.imageURL = ""
        }
    }
    
    @IBAction func onCheckInButton(sender:AnyObject?) {
        self.showMapView()
    }
    
    // show map screen
    private func showMapView() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
        let controller:UIViewController = storyboard.instantiateInitialViewController() as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onProfileButton(sender:AnyObject?) {
        self.showProfile()
    }
    
    @IBAction func onLogoutButton(sender:AnyObject?) {
        self.confirmLogOut()
    }
    
    // show confirm alert for logging out
    private func confirmLogOut()
    {
        let alert:UIAlertController = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertControllerStyle.Alert)
        let yes:UIAlertAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
            
            LoginService.logout()
            self.dismissViewControllerAnimated(true, completion: nil)
            DebugService.print("Log out user, back to login screen")
            
        })
        let no:UIAlertAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(no)
        alert.addAction(yes)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // show profile screen
    private func showProfile() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller:ProfileViewController = storyboard.instantiateInitialViewController() as ProfileViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}