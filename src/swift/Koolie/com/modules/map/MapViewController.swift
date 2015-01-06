//
//  MapViewController.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-06.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController:UIViewController
{
    
    @IBOutlet weak var backButton:RoundIconButton?
    @IBOutlet weak var listButton:RoundIconButton?
    @IBOutlet weak var map:MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.05)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        self.map?.setRegion(region, animated: true)
        
        let annotation:MKPointAnnotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        self.map?.addAnnotation(annotation)
    }
    
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