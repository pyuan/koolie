//
//  CheckInTextView.swift
//  Koolie
//
//  Created by Paul Yuan on 2015-01-06.
//  Copyright (c) 2015 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class CheckInTextView:UITextView
{
    
    let PlaceholderText:String = "Message?"
    
    @IBInspectable var paddingTop:CGFloat = 10
    @IBInspectable var paddingBottom:CGFloat = 10
    @IBInspectable var paddingLeft:CGFloat = 10
    @IBInspectable var paddingRight:CGFloat = 10
    
    private var bottomBorder:UIView?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        // set up text
        self.backgroundColor = UIColor.clearColor()
        self.textColor = UIColor.COLORS.CYAN_1
        self.tintColor = UIColor.COLORS.GREEN_1
        self.font = UIFont.BODY_TYPE
        self.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
        // setup border
        self.layer.borderColor = UIColor.COLORS.GREEN_1.CGColor
        self.layer.borderWidth = 1
        
        // trigger styles update
        self.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        self.textColor = UIColor.COLORS.GREEN_1
        if self.text == PlaceholderText {
            self.text = ""
        }
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool
    {
        //trim white space
        var whiteSpaceCharSet:NSCharacterSet = NSCharacterSet(charactersInString: " ")
        var newText:String = self.text.stringByTrimmingCharactersInSet(whiteSpaceCharSet)
        if newText.isEmpty {
            newText = PlaceholderText
            self.textColor = UIColor.COLORS.CYAN_1
        }
        self.text = newText

        return super.resignFirstResponder()
    }
    
}