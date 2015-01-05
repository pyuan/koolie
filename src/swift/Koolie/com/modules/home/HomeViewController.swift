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
    @IBOutlet var profileImage:CircularImage?
    
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
    
    @IBAction func onProfileButton(sender:AnyObject?) {
        self.showProfile()
    }
    
    // show profile screen
    private func showProfile() {
        /*
        let storyboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let controller:LoginViewController = storyboard.instantiateInitialViewController() as LoginViewController
        self.navigationController?.pushViewController(controller, animated: true)
        */
        LoginService.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}