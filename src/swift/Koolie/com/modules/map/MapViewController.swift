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

class MapViewController:FormViewController
{
    
    enum Mode:Int {
        case CheckIn
        case Update
    }
    
    @IBOutlet weak var backButton:RoundIconButton?
    @IBOutlet weak var listButton:RoundIconButton?
    @IBOutlet weak var map:MKMapView?
    @IBOutlet weak var checkInContainer:UIView?
    @IBOutlet weak var checkInAddress:UILabel?
    @IBOutlet weak var checkInMessage:CheckInTextView?
    @IBOutlet weak var checkInButtonsContainer:UIView?
    @IBOutlet weak var checkInUpdateButtonsContainer:UIView?
    
    private var checkInBackgroundLayer:CAShapeLayer?
    
    private var mode:Mode? {
        didSet {
            self.checkInButtonsContainer?.hidden = self.mode == Mode.Update
            self.checkInUpdateButtonsContainer?.hidden = !self.checkInButtonsContainer!.hidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkInContainer?.backgroundColor = UIColor.clearColor()
        self.checkInContainer?.alpha = 0.0
        self.checkInAddress?.font = UIFont.systemFontOfSize(12)
        self.checkInAddress?.textColor = UIColor.whiteColor()
        self.checkInMessage?.delegate = self
        
        // add test annotation
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.05)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        self.map?.setRegion(region, animated: true)
        
        let annotation:MKPointAnnotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        self.map?.addAnnotation(annotation)
        
        // set default mode
        self.mode = Mode.CheckIn
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.drawCheckInBackground()
        self.updateMarker()
    }
    
    // draw background for checkin container
    private func drawCheckInBackground()
    {
        self.checkInBackgroundLayer?.removeFromSuperlayer()
        
        let mask:CAShapeLayer = CAShapeLayer()
        mask.frame = self.view.layer.bounds
        let w:CGFloat = self.checkInContainer!.layer.frame.width
        let h:CGFloat = self.checkInContainer!.layer.frame.height
        let triangleSize:CGFloat = 25
        let path:CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, triangleSize/2)
        CGPathAddLineToPoint(path, nil, w/2 - triangleSize/2, triangleSize/2)
        CGPathAddLineToPoint(path, nil, w/2, 0)
        CGPathAddLineToPoint(path, nil, w/2 + triangleSize/2, triangleSize/2)
        CGPathAddLineToPoint(path, nil, w, triangleSize/2)
        CGPathAddLineToPoint(path, nil, w, h)
        CGPathAddLineToPoint(path, nil, 0, h)
        CGPathAddLineToPoint(path, nil, 0, 0)
        mask.path = path
        self.checkInContainer?.layer.mask = mask
        
        self.checkInBackgroundLayer = CAShapeLayer()
        self.checkInBackgroundLayer?.frame = self.view.bounds
        self.checkInBackgroundLayer?.path = path
        self.checkInBackgroundLayer?.fillColor = UIColor.COLORS.CYAN_4.CGColor
        self.checkInContainer?.layer.insertSublayer(self.checkInBackgroundLayer, atIndex: 0)
        
        // fade in container
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
        
            self.checkInContainer!.alpha = 1.0
            
        }, completion: nil)
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
    
    private func updateMarker() {
        self.checkInMessage?.setContentOffset(CGPointZero, animated: false)
    }
    
    // MARK: prevent being able to start new line using the return key so keyboard can be hidden
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
}