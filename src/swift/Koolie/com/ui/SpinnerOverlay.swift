//
//  SpinnerOverlay.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-05.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class SpinnerOverlay:UIView
{
    
    private var spinner:UIActivityIndicatorView?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init() {
        super.init()
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = true
        self.spinner = UIActivityIndicatorView()
        self.spinner?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.spinner?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.spinner?.color = UIColor.COLORS.GREEN_1
        self.addSubview(self.spinner!)
    }
    
    func addToParentView(parentView:UIView) {
        parentView.addSubview(self)
        self.frame = parentView.frame
        self.spinner?.center = self.center
        self.spinner?.startAnimating()
    }
    
}