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
import QuartzCore

class MapViewController:FormViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    
    let MapOffsetLongitude:CLLocationDegrees = 0.37 // to align with check-in container view at the bottom
    
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
    private var currentLocation:CLLocationCoordinate2D?
    
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
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        //self.manager?.startMonitoringSignificantLocationChanges()
        
        self.map?.delegate = self
        
        // set default mode
        self.mode = Mode.CheckIn
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.drawCheckInBackground()
        self.updateCheckinContainer()
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
    
    private func updateCheckinContainer() {
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
        self.locationManager?.stopUpdatingLocation()
        let location:CLLocation = locations.last as CLLocation
        self.centerMap(coordinates: location.coordinate)
        DebugService.print("Current location: \(location)")
    }
    
    // center and zoom the map to a location
    private func centerMap(coordinates coord:CLLocationCoordinate2D!)
    {
        // set map view region
        let viewRegion:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coord, Constants.DISTANCES.RadiusInMile.rawValue * Constants.DISTANCES.MetersPerMile.rawValue, Constants.DISTANCES.RadiusInMile.rawValue * Constants.DISTANCES.MetersPerMile.rawValue)
        self.map?.setRegion(viewRegion, animated: false)
        
        // offset center of map
        let offsetCenter:CLLocationCoordinate2D = self.getCoordinateWithOffset(coordinates: coord)
        self.map?.setCenterCoordinate(offsetCenter, animated: false)
    }
    
    // move check-in marker to center of map
    private func centerMarker(coodinates coord:CLLocationCoordinate2D!)
    {
        //self.map?.removeAnnotation(self.checkInMarker)
        if self.checkInMarker == nil {
            self.checkInMarker = MKPointAnnotation()
            self.checkInMarker?.setCoordinate(coord)
            self.checkInMarker?.title = "Big Ben"
            self.checkInMarker?.subtitle = "London"
            self.map?.addAnnotation(self.checkInMarker)
        }
        
        UIView.animateWithDuration(0.25, animations: {() -> Void in
            self.checkInMarker!.setCoordinate(coord)
        })
    }
    
    // update address by reverse geocoding a latitude and longitude
    private func getAddressFromLocation(coordinate coord:CLLocationCoordinate2D!, onAddress:((address:String!)->Void)?)
    {
        let location:CLLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
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
    
    // MARK: map center change, replot checkin marker
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        let adjustedCoord:CLLocationCoordinate2D = self.getCoordinateWithoutOffset(coordinates: self.map!.centerCoordinate)
        self.currentLocation = adjustedCoord
        self.centerMarker(coodinates: adjustedCoord)
        
        // update the centered address
        self.getAddressFromLocation(coordinate: adjustedCoord, onAddress: {(address:String!) -> Void in
            self.checkInAddress!.text = address
        })
    }
    
    // MARK: animated newly added annotation view
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!)
    {
        let bounce:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounce.values = [0.01, 1.1, 0.8, 1.0]
        bounce.keyTimes = [0.0, 0.5, 0.75, 1.0]
        bounce.duration = 0.25
        
        for view:MKAnnotationView in views as [MKAnnotationView] {
            let endFrame:CGRect = view.frame
            view.frame = CGRectOffset(endFrame, 0, -500)
            view.alpha = 0
            
            UIView.animateWithDuration(0.35, delay: 0.5, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
                
                view.frame = endFrame
                view.alpha = 1.0
                
                }, completion: {(finished:Bool) -> Void in
                    view.layer.addAnimation(bounce, forKey: "bounce")
                })
        }
    }
    
    // calculate the coordinates with the map position offset
    private func getCoordinateWithOffset(coordinates coord:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        var loc:CLLocationCoordinate2D = coord
        loc.latitude += self.map!.region.span.latitudeDelta * MapOffsetLongitude
        return loc
    }
    
    // calculate the coordinates without the map position offset
    private func getCoordinateWithoutOffset(coordinates coord:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        var loc:CLLocationCoordinate2D = coord
        loc.latitude -= self.map!.region.span.latitudeDelta * MapOffsetLongitude
        return loc
    }
    
}