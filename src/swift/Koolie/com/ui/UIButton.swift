//
//  UIButton.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-02.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

extension UIButton
{
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = UIColor.COLORS.GREEN_1
        self.titleLabel?.font = UIFont.BODY_TYPE
    }
    
}