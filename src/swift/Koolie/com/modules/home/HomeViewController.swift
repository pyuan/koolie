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
        }
    }
    
    @IBAction func onCheckInButton(sender:AnyObject?) {
        LoginService.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onProfileButton(sender:AnyObject?) {
        self.showProfile()
    }
    
    // show profile screen
    private func showProfile() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller:ProfileViewController = storyboard.instantiateInitialViewController() as ProfileViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}