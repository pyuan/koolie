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
    
    //load profile image with the logged in user
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let user:PFUser! = LoginService.getCurrentUser()
        let file:PFFile? = user["image"] as? PFFile
        if file != nil {
            self.profileImage?.imageURL = file!.url
        }
    }
    
    @IBAction func logOut(sender:AnyObject?) {
        LoginService.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
        DebugService.print("User is now logged out")
    }
    
}