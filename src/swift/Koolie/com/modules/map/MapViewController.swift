//
//  MapViewController.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-06.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class MapViewController:UIViewController
{
    
    @IBOutlet weak var backButton:RoundIconButton?
    @IBOutlet weak var listButton:RoundIconButton?
    
    @IBAction func onBackButton(sender:AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onListButton(sender:AnyObject?) {
        self.showListView()
    }
    
    // show the list view
    private func showListView() {
        let storyboard:UIStoryboard = UIStoryboard(name: "List", bundle: nil)
        let controller:UIViewController = storyboard.instantiateInitialViewController() as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}