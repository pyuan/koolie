//
//  MapViewController.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-06.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import AddressBookUI
import MapKit

class MapViewController:FormViewController, CLLocationManagerDelegate
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
    private var locationManager:CLLocationManager?
    private var checkInMarker:MKPointAnnotation?
    private var currentLocation:CLLocation?
    
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
        self.checkInAddress?.text = "Getting your current location..."
        self.checkInMessage?.delegate = self
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        // set default mode
        self.mode = Mode.CheckIn
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.drawCheckInBackground()
        self.updateMarker()
        
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        //self.manager?.startMonitoringSignificantLocationChanges()
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
    
    // MARK: get the user's location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        let location:CLLocation = locations.last as CLLocation
        self.currentLocation = location
        self.locationManager?.stopUpdatingLocation()
        let lat:CLLocationDegrees = location.coordinate.latitude
        let lng:CLLocationDegrees = location.coordinate.longitude
        self.centerMap(latitude: lat, longitude: lng) //zoom in on map
        DebugService.print("Current location: \(location)")
    }
    
    // center the map to a location
    private func centerMap(latitude lat:CLLocationDegrees!, longitude lng:CLLocationDegrees!)
    {
        // set map view region
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let viewRegion:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location, Constants.DISTANCES.RadiusInMile.rawValue * Constants.DISTANCES.MetersPerMile.rawValue, Constants.DISTANCES.RadiusInMile.rawValue * Constants.DISTANCES.MetersPerMile.rawValue)
        self.map?.setRegion(viewRegion, animated: false)
        
        // offset center of map
        var center:CLLocationCoordinate2D = location
        center.latitude += self.map!.region.span.latitudeDelta * 0.35
        self.map?.setCenterCoordinate(center, animated: false)
        
        // update the centered address
        self.getAddressFromLocation(latitude: lat, longitude: lng, onAddress: {(address:String!) -> Void in
            self.checkInAddress!.text = address
        })
        
        // add checkin annotation
        self.map?.removeAnnotation(self.checkInMarker)
        self.checkInMarker = MKPointAnnotation()
        self.checkInMarker?.setCoordinate(location)
        self.checkInMarker?.title = "Big Ben"
        self.checkInMarker?.subtitle = "London"
        self.map?.addAnnotation(self.checkInMarker)
    }
    
    // update address by reverse geocoding a latitude and longitude
    private func getAddressFromLocation(latitude lat:CLLocationDegrees!, longitude lng:CLLocationDegrees!, onAddress:((address:String!)->Void)?)
    {
        let location:CLLocation = CLLocation(latitude: lat, longitude: lng)
        let geoCoder:CLGeocoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks:[AnyObject]!, error:NSError!) -> Void in
            
            if placemarks != nil && placemarks.count > 0 {
                let placemark:CLPlacemark = placemarks.first as CLPlacemark
                let arr:NSArray = placemark.addressDictionary["FormattedAddressLines"] as NSArray
                let address:String = arr.componentsJoinedByString(", ")
                onAddress?(address: address)
            }
            
        })
    }
    
}