//
//  Constants.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-02.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation

class Constants {
    
    enum PARSE:String {
        case APPLICATION_ID = "m12v58wdZMJEU4Rr4mbGOTavLioKCdfbWvsHrMyX"
        case CLIENT_KEY = "gO2EV3EeB4v6hYbXZ2HLfgbes1pt6KLLhtkiTvSc"
    }
    
    enum USER_PREFERNCES_KEYS:Int {
        case USERNAME
        case PASSWORD
    }
    
    enum DISTANCES:CLLocationDistance {
        case MetersPerMile = 1609.344
        case RadiusInMile = 0.1
    }
    
}