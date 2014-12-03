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
        let currentUser:PFUser = PFUser.currentUser()
        return currentUser
    }
    
}