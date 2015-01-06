//
//  ProfileImageButton.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-05.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class ProfileImageButton:UIButton
{
    
    var imageURL:String = "" {
        didSet
        {
            let url:NSURL? = NSURL(string: imageURL)!
            if url != nil && !self.imageURL.isEmpty {
                let imageData:NSData? = NSData(contentsOfURL: url!)
                if imageData != nil {
                    self.setImage(UIImage(data: imageData!), forState: UIControlState.Normal)
                }
                self.hasDefaultImage = false
            } else {
                self.setImage(UIImage(named: "default_profile"), forState: UIControlState.Normal)
                self.hasDefaultImage = true
            }
        }
    }
    
    private var hasDefaultImage:Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        self.backgroundColor = UIColor.COLORS.CYAN_4
        self.imageView?.tintColor = UIColor.COLORS.GREEN_1
        self.imageURL = "" // set to default image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width/2
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0
    }
    
    func isDefaultImage() -> Bool {
        return self.hasDefaultImage
    }
    
    override func setImage(image: UIImage?, forState state: UIControlState) {
        super.setImage(image, forState: state)
        self.hasDefaultImage = image == nil
    }
    
}