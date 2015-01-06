//
//  LoginService.swift
//  Koolie
//
//  Created by Paul Yuan on 2014-12-02.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation

class LoginService
{
    
    // login with a username and password
    class func login(username:String, password:String, onResult: ((user:PFUser!, error:NSError!)->Void)?) {
        PFUser.logInWithUsernameInBackground(username, password: password, block: onResult)
    }
    
    // clear out user session
    class func logout() {
        PFUser.logOut()
    }
    
    // retrieve the currently logged in user
    class func getCurrentUser() -> PFUser?
    {
        let currentUser:PFUser? = PFUser.currentUser()
        return currentUser
    }
    
    // update the user, only update profile image if the flag is set to true
    class func updateUser(username:String, password:String, imageData:NSData?, updateProfileImage:Bool, onUpdate:(()->Void)?, onError:((error:NSError!)->Void)?)
    {
        let user:PFUser! = LoginService.getCurrentUser()
        user.username = username
        
        if !password.isEmpty {
            user.password = password
        }
        
        if updateProfileImage {
            if imageData != nil {
                let imageFile:PFFile = PFFile(name:"profile.png", data:imageData)
                user["image"] = imageFile
            } else {
                user.removeObjectForKey("image")
            }
        }
        
        user.saveInBackgroundWithBlock({(success:Bool!, error:NSError!) -> Void in
            if success == true {
                onUpdate?()
            } else {
                onError?(error: error)
                DebugService.print(error)
            }
        })
    }
    
}