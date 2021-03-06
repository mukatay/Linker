//
//  AppDelegate.swift
//  Template Project
//
//  Created by Benjamin Encz on 5/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import ParseUI
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var parseLoginHelper: ParseLoginHelper!
    
    override init() {
        super.init()
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            } else  if let user = user {
                if !PFFacebookUtils.isLinkedWithUser(user) {
                    PFFacebookUtils.linkUserInBackground(PFUser.currentUser()!, withPublishPermissions: ["publish_actions"], block: { (success, error) -> Void in
                        if success {
                            self.showMainInterface()
                        }
                    })
                } else {
                    self.showMainInterface()
                }
            }
        }
    }
    
    func showMainInterface() {
        println("About to serialize access token with permissions: \(FBSDKAccessToken.currentAccessToken().permissions)")
        
        let serializedAccessToken = NSKeyedArchiver.archivedDataWithRootObject(FBSDKAccessToken.currentAccessToken())
        NSUserDefaults(suiteName: "group.mukatay.TestShareDefaults")?.setObject(serializedAccessToken, forKey: "FacebookAccessToken")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        self.window?.rootViewController = tabBarController
    }
    
    func showLoginInterface() {
        let loginViewController = MyLoginViewController()
        loginViewController.facebookPermissions = ["public_profile", "email", "user_friends"]
        loginViewController.fields = .Facebook
        loginViewController.delegate = parseLoginHelper
        loginViewController.signUpController?.delegate = parseLoginHelper
        
        self.window?.rootViewController = loginViewController
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.enableDataSharingWithApplicationGroupIdentifier("group.mukatay.TestShareDefaults")
        Parse.setApplicationId("ErcD8FgZDmstg9zQfZ2HVCrJ1JwXFWPCdFZerCgJ", clientKey: "bybCVI9UELUynBuJqSWPxNxTJ3AeFJM1zA9oYVF4")
        
        let acl = PFACL()
        acl.setPublicReadAccess(true)
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        let user = PFUser.currentUser()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        if (user != nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let startViewController = storyboard.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
            self.window?.rootViewController = startViewController
        } else {
            showLoginInterface()
        }
        
        self.window?.makeKeyAndVisible()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url,sourceApplication: sourceApplication, annotation: annotation)
    }
    
}

