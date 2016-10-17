//
//  MainScreenViewController.swift
//  WalletFinder
//
//  Created by Xi Han on 10/15/16.
//  Copyright © 2016 Xi's Brain Hole. All rights reserved.
//

import UIKit
import UserNotifications
import MapKit

class MainScreenViewController: UIViewController, GMBLPlaceManagerDelegate, GMBLBeaconManagerDelegate {

    var _appDelegate: AppDelegate! = nil
	var _manager: GMBLBeaconManager! = nil
	var _placeManager: GMBLPlaceManager! = nil
    var _dateFormatter: DateFormatter! = nil
    var _locationManager: CLLocationManager! = nil
    var _pin: MKPointAnnotation! = nil
	
    @IBOutlet weak var signalLabel: UILabel!
    @IBOutlet weak var signalDateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        
        _appDelegate = UIApplication.shared.delegate as! AppDelegate
        
		_manager = GMBLBeaconManager()
		_manager.delegate = self
		_manager.startListening()
		
		_placeManager = GMBLPlaceManager()
		_placeManager.delegate = self
		
        _dateFormatter = DateFormatter()
        _dateFormatter.timeZone = NSTimeZone.local
        _dateFormatter.dateStyle = .medium
        _dateFormatter.timeStyle = .long
        
        _locationManager = CLLocationManager()
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        _pin = MKPointAnnotation()
        _pin.title = "Wallet"
        
        updateCoord()
        
		print("view did load")
	}
    
    private func updateCoord() {
        if let lat = _appDelegate.lastKnownLatitude, let lng = _appDelegate.lastKnownLongitude {
            _pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            mapView.addAnnotation(_pin)
            
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(_pin.coordinate, 500, 500), animated: true)
            mapView.setCenter(_pin.coordinate, animated: true)
        } else {
            mapView.removeAnnotation(_pin)
        }
    }
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func beaconManager(_ manager: GMBLBeaconManager!, didReceive sighting: GMBLBeaconSighting!) {
		if (sighting.beacon.identifier == "9HHA-R7F2Q") { // my wallet beacon
            signalDateLabel.text = _dateFormatter.string(from: sighting.date)
            
            if sighting.rssi < -80 {
                signalLabel.textColor = UIColor.red
                signalLabel.text = String("Lost Wallet 😭")
                sendWalletLostNotification()
            } else {
                signalLabel.textColor = UIColor.green
                signalLabel.text = String(sighting.rssi)
            }
            
            _appDelegate.lastKnownLatitude = _locationManager.location?.coordinate.latitude
            _appDelegate.lastKnownLongitude = _locationManager.location?.coordinate.longitude
            
            updateCoord()
		}
	}
    
    private func sendWalletLostNotification() {
        let notification = UNMutableNotificationContent()
        notification.title = "Wallet Finder"
        notification.body = "You are getting far away from your wallet."
        notification.categoryIdentifier = "message"
        UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "wallet_lost", content: notification, trigger: nil), withCompletionHandler: nil)
    }
	
//	func placeManager(_ manager: GMBLPlaceManager!, didEnd visit: GMBLVisit!) {
//		if (visit.place.identifier == "4C79341D0DC34F7F88B82436DF975DC6")  { // my wallet place
//			let startedNotification = UNMutableNotificationContent()
//			startedNotification.title = "Wallet Finder"
//			startedNotification.body = "You left your wallet behind! Last known location: \(visit.place.attributes)"
//			startedNotification.categoryIdentifier = "message"
//			UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "did_end_visit", content: startedNotification, trigger: nil), withCompletionHandler: nil)
//
//		}
//	}
//	
//	func placeManager(_ manager: GMBLPlaceManager!, didBegin visit: GMBLVisit!) {
//		if (visit.place.identifier == "4C79341D0DC34F7F88B82436DF975DC6")  { // my wallet place
//			let startedNotification = UNMutableNotificationContent()
//			startedNotification.title = "Wallet Finder"
//			startedNotification.body = "Your wallet is nearby! Last known location: \(visit.place.attributes)"
//			startedNotification.categoryIdentifier = "message"
//			UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "did_begin_visit", content: startedNotification, trigger: nil), withCompletionHandler: nil)
//			
//		}
//	}
}

