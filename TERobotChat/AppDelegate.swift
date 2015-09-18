//
//  AppDelegate.swift
//  TERobotChat
//
//  Created by offcn on 15/9/6.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

import UIKit
import Parse

let api_url = "http://www.tuling123.com/openapi/api"
let api_key = "8610ed6b182032551a7ecdc9623e8422"
let userId = "130351"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        var cvc = ChatViewController()
        cvc.title = "Terry"
        UINavigationBar.appearance().tintColor = UIColor(red: 0.05, green: 0.47, blue: 0.71, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.05, green: 0.47, blue: 0.71, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        var NChatVc = UINavigationController(rootViewController: cvc)
        self.window?.rootViewController = NChatVc
        Parse.setApplicationId("00AhindLshaBhYM4trW3HIcKvfsT4XiGc6JsNWal", clientKey: "wRK6DEmQvpwLEzpxfveIX6L8ZB9rzWfz7zSAoPR8")
        
        var query = PFQuery(className: "Messages")
        query.orderByAscending("sentDate")
        query.findObjectsInBackgroundWithBlock({(objects,error)->Void in
        
            for object in objects as! [PFObject] {
                let inComing:Bool = object["incoming"] as! Bool
                let text:String = object["text"] as! String
                let sendDate:NSDate = object["sentDate"] as! NSDate
                println("\(object.objectId!)\n\(inComing)\n\(text)\n\(sendDate)")
            
            
            }
        
        })
        self.window?.makeKeyAndVisible()
        return true
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

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

