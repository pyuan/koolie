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
    
    @IBAction func logOut(sender:AnyObject?) {
        LoginService.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
        DebugService.print("User is now logged out")
    }
    
}