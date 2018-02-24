//
//  AppDelegate.swift
//  CLLocation-App
//
//  Created by Mario Acero on 2/23/18.
//  Copyright © 2018 Mario Acero. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        LocationManager.shared.updateTrackingMethod(.Combined)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        LocationManager.shared.updateTrackingMethod(.Background)
        
//        let region = Circular
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        LocationManager.shared.updateTrackingMethod(.Foreground)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        LocationManager.shared.updateTrackingMethod(.Foreground)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        LocationManager.shared.updateTrackingMethod(.None)
    }


}

