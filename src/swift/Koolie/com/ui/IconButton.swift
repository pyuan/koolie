//
//  IconButton.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-03.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class IconButton:UIButton
{
    
    @IBInspectable var iconName:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        
        let icon:UIImage = UIImage(named: iconName)!
        self.setImage(icon, forState: UIControlState.Normal)
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
}