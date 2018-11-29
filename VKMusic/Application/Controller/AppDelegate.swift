//
//  AppDelegate.swift
//  VKMusic
//
//  Created by Robert on 10.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import UIKit
import SwiftyVK

var vkDelegate: SwiftyVKDelegate?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        vkDelegate = VKDelegateExample()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let token = UserDefaults.standard.value(forKey: "token"),let id = UserDefaults.standard.value(forKey: "id") {
            NetworkHelper.shared.token = token as? String
            NetworkHelper.shared.id = id as? String
            let musicVC = storyboard.instantiateViewController(withIdentifier: "MusicVC")
            self.window?.rootViewController = musicVC
            self.window?.makeKeyAndVisible()
        } else {
            let vc = storyboard.instantiateViewController(withIdentifier: "StartVC")
            self.window?.rootViewController = vc
            self.window?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.window?.makeKeyAndVisible()
        }
        
        
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @available(iOS 9.0, *)
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
        ) -> Bool {
        let app = options[.sourceApplication] as? String
        VK.handle(url: url, sourceApplication: app)
        return true
    }
    
    func application(
        _ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any
        ) -> Bool {
        VK.handle(url: url, sourceApplication: sourceApplication)
        return true
    }
    
    
}

