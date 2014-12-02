//
//  GradientButton.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-02.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@IBDesignable class GradientButton:UIButton
{
    
    enum TYPES:Int {
        case GREEN
        case CYAN
    }
    
    @IBInspectable var type:Int = TYPES.GREEN.rawValue
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        var textColor:UIColor = type == TYPES.GREEN.rawValue ? UIColor.COLORS.CYAN_4 : UIColor.COLORS.CYAN_1
        self.tintColor = textColor
        
        //setup gradient background
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 0
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = self.layer.bounds
        
        var colors:[CGColorRef]?
        if self.type == TYPES.GREEN.rawValue {
            colors = [UIColor.COLORS.GREEN_2.CGColor, UIColor.COLORS.GREEN_1.CGColor]
        } else {
            colors = [UIColor.COLORS.CYAN_4.CGColor, UIColor.COLORS.CYAN_3.CGColor]
        }
        
        gradient.colors = colors
        gradient.locations = [0, 1.0]
        self.layer.insertSublayer(gradient, atIndex: 0)
    }
    
}