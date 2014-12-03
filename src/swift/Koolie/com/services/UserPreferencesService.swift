//
//  UserPreferencesService.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-03.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation

class UserPreferencesService
{
    
    //retrieve a user preference with key
    class func getPreference(key:Constants.USER_PREFERNCES_KEYS) -> AnyObject?
    {
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var value:AnyObject? = defaults.valueForKey(key.rawValue.description)
        return value
    }
    
    //set a user preference
    class func setPreference(key:Constants.USER_PREFERNCES_KEYS, value:String?)
    {
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: key.rawValue.description)
    }
    
}