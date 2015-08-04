//
//  ParseLoginHelper.swift
//  Template Project
//
//  Created by Benjamin Encz on 4/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import Parse
import ParseUI


typealias ParseLoginHelperCallback = (PFUser?, NSError?) -> Void

/**
This class implements the 'PFLogInViewControllerDelegate' protocol. After a successfull login
it will call the callback function and provide a 'PFUser' object.
*/
class ParseLoginHelper : NSObject, NSObjectProtocol {
    static let errorDomain = "com.makeschool.parseloginhelpererrordomain"
    static let usernameNotFoundErrorCode = 1
    static let usernameNotFoundLocalizedDescription = "Could not retrieve Facebook username"
    
    let callback: ParseLoginHelperCallback
    
    init(callback: ParseLoginHelperCallback) {
        self.callback = callback
    }
}

extension ParseLoginHelper : PFLogInViewControllerDelegate {
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        // Determine if this is a Facebook login
        let isFacebookLogin = FBSDKAccessToken.currentAccessToken() != nil
        
        if !isFacebookLogin {
            // Plain parse login, we can return user immediately
            self.callback(user, nil)
        } else {
            
            let serializedAccessToken = NSKeyedArchiver.archivedDataWithRootObject(FBSDKAccessToken.currentAccessToken())
            NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.setObject(serializedAccessToken, forKey: "FacebookAccessToken")
            
            // if this is a Facebook login, fetch the username from Facebook
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).startWithCompletionHandler {
                (connection: FBSDKGraphRequestConnection!, result: AnyObject?, error: NSError?) -> Void in
                if let error = error {
                    // Facebook Error? -> hand error to callback
                    self.callback(nil, error)
                }
                
                if let fbUsername = result?["name"] as? String {
                    
                    let facebookID: String = result?["id"] as! String
                    
                    let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                    
                    user.setObject(pictureURL, forKey: "profilePicture")
                    
                    if let fbEmail = result?["email"] as? String {
                        user.email = fbEmail
                        
                    }
                    // assign Facebook name to PFUser
                    user.username = fbUsername
                    // store PFUser
                    user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // updated username could be stored -> call success
                            self.callback(user, error)
                        } else {
                            // updating username failed -> hand error to callback
                            self.callback(nil, error)
                        }
                    })
                } else {
                    // cannot retrieve username? -> create error and hand it to callback
                    let userInfo = [NSLocalizedDescriptionKey : ParseLoginHelper.usernameNotFoundLocalizedDescription]
                    let noUsernameError = NSError(
                        domain: ParseLoginHelper.errorDomain,
                        code: ParseLoginHelper.usernameNotFoundErrorCode,
                        userInfo: userInfo
                    )
                    self.callback(nil, error)
                }
            }
        }
    }
    
}

extension ParseLoginHelper : PFSignUpViewControllerDelegate {
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.callback(user, nil)
    }
    
}