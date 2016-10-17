//
//  AppDelegate.swift
//  WalletFinder
//
//  Created by Xi Han on 10/15/16.
//  Copyright © 2016 Xi's Brain Hole. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
    var lastKnownLatitude: Double? = nil
    var lastKnownLongitude: Double? = nil
    var defaults: UserDefaults! = nil

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
        defaults = UserDefaults.standard
        lastKnownLatitude = defaults.object(forKey: "lastKnownLatitude") as? Double
        lastKnownLongitude = defaults.object(forKey: "lastKnownLongitude") as? Double
        
		// Initialize Gimbal framework.
		Gimbal.setAPIKey("1ce025fb-6823-43a3-9fb1-a5fdc476518e", options: nil)
		Gimbal.start()
		
		print(GMBLPlaceManager.isMonitoring())
		
		let notificationCenter = UNUserNotificationCenter.current()
		notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
			
			// Crash if not granted for now.
			// TODO: add graceful messages.
			if (!granted) {
				exit(1)
			}
		}
		
		return true
	}
    
    private func storeLastKnownLocation() {
        if let lat = lastKnownLatitude, let lng = lastKnownLongitude {
            defaults.set(lat, forKey: "lastKnownLatitude")
            defaults.set(lng, forKey: "lastKnownLongitude")
        }
    }

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        storeLastKnownLocation()
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
        storeLastKnownLocation()
	}


}

