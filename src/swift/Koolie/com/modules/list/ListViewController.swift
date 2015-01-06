//
//  ListViewController.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-06.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class ListViewController:UIViewController
{
    
    @IBOutlet weak var backButton:RoundIconButton?
    
    @IBAction func onBackButton(sender:AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}