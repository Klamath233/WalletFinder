//
//  MainScreenViewController.swift
//  WalletFinder
//
//  Created by Xi Han on 10/15/16.
//  Copyright © 2016 Xi's Brain Hole. All rights reserved.
//

import UIKit
import UserNotifications

class MainScreenViewController: UIViewController, GMBLPlaceManagerDelegate, GMBLBeaconManagerDelegate {

	var _manager: GMBLBeaconManager! = nil
	var _placeManager: GMBLPlaceManager! = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		_manager = GMBLBeaconManager()
		_manager.delegate = self
		_manager.startListening()
		
		_placeManager = GMBLPlaceManager()
		_placeManager.delegate = self
		
		print("view did load")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func beaconManager(_ manager: GMBLBeaconManager!, didReceive sighting: GMBLBeaconSighting!) {
		if (sighting.beacon.identifier == "9HHA-R7F2Q") { // my wallet beacon
			let startedNotification = UNMutableNotificationContent()
			startedNotification.title = "Wallet Finder"
			startedNotification.body = "Your wallet is nearby! Signal strength: \(sighting.rssi)"
			startedNotification.categoryIdentifier = "message"
			UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "did_receive_sighting", content: startedNotification, trigger: nil), withCompletionHandler: nil)
		}
	}
	
	func placeManager(_ manager: GMBLPlaceManager!, didEnd visit: GMBLVisit!) {
		if (visit.place.identifier == "4C79341D0DC34F7F88B82436DF975DC6")  { // my wallet place
			let startedNotification = UNMutableNotificationContent()
			startedNotification.title = "Wallet Finder"
			startedNotification.body = "You left your wallet behind! Last known location: \(visit.place.attributes)"
			startedNotification.categoryIdentifier = "message"
			UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "did_end_visit", content: startedNotification, trigger: nil), withCompletionHandler: nil)

		}
	}
	
	func placeManager(_ manager: GMBLPlaceManager!, didBegin visit: GMBLVisit!) {
		if (visit.place.identifier == "4C79341D0DC34F7F88B82436DF975DC6")  { // my wallet place
			let startedNotification = UNMutableNotificationContent()
			startedNotification.title = "Wallet Finder"
			startedNotification.body = "Your wallet is nearby! Last known location: \(visit.place.attributes)"
			startedNotification.categoryIdentifier = "message"
			UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "did_begin_visit", content: startedNotification, trigger: nil), withCompletionHandler: nil)
			
		}
	}
	
	func placeManager(_ manager: GMBLPlaceManager!, didReceive sighting: GMBLBeaconSighting!, forVisits visits: [AnyObject]!) {
		if (sighting.beacon.identifier == "9HHA-R7F2Q") { // my wallet beacon
			let startedNotification = UNMutableNotificationContent()
			startedNotification.title = "Wallet Finder"
			startedNotification.body = "Your wallet is nearby! Signal strength: \(sighting.rssi)"
			startedNotification.categoryIdentifier = "message"
			UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "did_receive_sighting", content: startedNotification, trigger: nil), withCompletionHandler: nil)
		}
	}


}

