//
//  CircularImage.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-03.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class CircularImage:UIImageView
{
    
    var imageURL:String = "" {
        didSet
        {
            let url:NSURL? = NSURL(string: imageURL)!
            if url != nil {
                let imageData:NSData? = NSData(contentsOfURL: url!)
                if imageData != nil {
                    self.image = UIImage(data: imageData!)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width/2
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0
    }
    
}