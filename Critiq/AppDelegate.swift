//
//  AppDelegate.swift
//  Critiq
//
//  Created by Rushan on 2017-07-03.
//  Copyright © 2017 RushanBenazir. All rights reserved.
//

import UIKit
import FBSDKCoreKit //facebook
import TwitterKit //twitter
import Firebase //database

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //firebase
        FirebaseApp.configure()

        //facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //twitter
        Twitter.sharedInstance().start(withConsumerKey: "pSpPGelBzixFVqxrwhFYSowXU", consumerSecret: "ibGZrizK5AUQCrNqm0MnqMa2G3SU19cN6jdhMZLuhjKw3pExRM")
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //facebook
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        //twitter
        let handled2 = Twitter.sharedInstance().application(app, open: url, options: options)
        
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


}

