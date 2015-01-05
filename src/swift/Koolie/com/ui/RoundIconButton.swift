//
//  RoundIconButton.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-05.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundIconButton:UIButton
{
    
    @IBInspectable var iconName:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.width/2
        self.layer.borderColor = UIColor.COLORS.GREEN_1.CGColor
        self.layer.borderWidth = 3
        self.backgroundColor = UIColor.COLORS.CYAN_4
        
        let icon:UIImage = UIImage(named: iconName)!
        self.setImage(icon, forState: UIControlState.Normal)
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    }
    
}