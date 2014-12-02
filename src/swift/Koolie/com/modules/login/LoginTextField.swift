//
//  LoginTextField.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-02.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class LoginTextField:UITextField
{
    
    @IBInspectable var paddingTop:CGFloat = 10
    @IBInspectable var paddingBottom:CGFloat = 10
    @IBInspectable var paddingLeft:CGFloat = 10
    @IBInspectable var paddingRight:CGFloat = 10
    
    private var bottomBorder:UIView?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        //set up text
        self.backgroundColor = UIColor.clearColor()
        self.textColor = UIColor.COLORS.GREEN_1
        self.tintColor = UIColor.COLORS.GREEN_1
        self.font = UIFont.BODY_TYPE
        
        //setup border
        self.borderStyle = UITextBorderStyle.None
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.COLORS.GREEN_1.CGColor
        
        //setup bottom border
        let bottomBorderWidth:CGFloat = 0.5
        self.bottomBorder = UIView()
        self.bottomBorder?.frame = CGRectMake(0, self.frame.height-bottomBorderWidth, self.frame.width, bottomBorderWidth)
        self.bottomBorder?.backgroundColor = UIColor.COLORS.CYAN_1
        self.addSubview(self.bottomBorder!)
        
        //add observers
        self.addTarget(self, action: "onEditStart:", forControlEvents: UIControlEvents.EditingDidBegin)
        self.addTarget(self, action: "onEditEnd:", forControlEvents: UIControlEvents.EditingDidEnd)
        
        //reset styles
        self.onEditEnd(self)
    }
    
    func onEditStart(textField: UITextField)
    {
        self.layer.borderWidth = 1
        self.bottomBorder?.hidden = true
        
        //setup placeholder
        let placeholderAttr:NSMutableDictionary = NSMutableDictionary()
        placeholderAttr[NSForegroundColorAttributeName] = UIColor.COLORS.GREEN_3
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: placeholderAttr)
    }
    
    func onEditEnd(textField: UITextField)
    {
        self.layer.borderWidth = 0
        self.bottomBorder?.hidden = false
        
        //setup placeholder
        let placeholderAttr:NSMutableDictionary = NSMutableDictionary()
        placeholderAttr[NSForegroundColorAttributeName] = UIColor.COLORS.CYAN_1
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: placeholderAttr)
        
        //trim white space
        var whiteSpaceCharSet:NSCharacterSet = NSCharacterSet(charactersInString: " ")
        var newText:String = self.text.stringByTrimmingCharactersInSet(whiteSpaceCharSet)
        self.text = newText
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsetsMake(paddingTop, paddingLeft, paddingBottom, paddingRight)
        let edges = UIEdgeInsetsInsetRect(bounds, padding)
        return super.textRectForBounds(edges)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsetsMake(paddingTop, paddingLeft, paddingBottom, paddingRight)
        let edges = UIEdgeInsetsInsetRect(bounds, padding)
        return super.editingRectForBounds(edges)
    }
    
    deinit {
        self.removeTarget(self, action: "onEditStart:", forControlEvents: UIControlEvents.EditingDidBegin)
        self.removeTarget(self, action: "onEditEnd:", forControlEvents: UIControlEvents.EditingDidEnd)
    }
    
}