//
//  ViewWithDefaultBackground.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-02.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class ViewWithDefaultBackground:UIView
{
    
    class private var STATUS_BAR_HEIGHT : CGFloat { return 44 }
    
    private var background:UIImageView?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //insert background image
        let bgImage:UIImage = UIImage(named: "background")!
        self.background = UIImageView(image: bgImage)
        self.background?.frame = self.frame
        self.background?.contentMode = UIViewContentMode.ScaleAspectFill
        self.insertSubview(self.background!, atIndex: 0)
    }
    
}