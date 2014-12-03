//
//  DebugService.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-03.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation

class DebugService
{
    
    //print a statement to the console, only print if in debug mode
    class func print(statement:AnyObject)
    {
        if DEBUG != 0 {
            println(statement)
        }
    }
    
}