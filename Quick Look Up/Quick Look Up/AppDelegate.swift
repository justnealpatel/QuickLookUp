//
//  AppDelegate.swift
//  Quick Look Up
//
//  Created by Neal Patel on 10/17/18.
//  Copyright © 2018 Neal Patel. All rights reserved.
//

import UIKit
import AWSCognito
import AWSCore
import UserNotifications
import CoreData

protocol IncomingMessageDelegate {
    func didReceiveIncomingMessage()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
    let identityID = "us-east-1:6a5a2699-6588-47c3-9031-ed01997f23b9"
    var deviceToken: String = ""
    var incomingMessageDelegate: IncomingMessageDelegate?
    var gotMessage = false
    
    // Allows for public classes to register for push notifications
    func registerForPushNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(false, forKey: "newUser")
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        // Setup custom window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let accountID = UserDefaults.standard.value(forKey: "accountID") as? Int
        if accountID == nil {
            window?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
        } else {
            let layout = UICollectionViewFlowLayout()
            let homePageVC = UINavigationController(rootViewController: HomePageCollectionViewController(collectionViewLayout: layout))
            window?.rootViewController = homePageVC
        }
        // AWS Access Configuration
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"us-east-1:6a5a2699-6588-47c3-9031-ed01997f23b9")
        let awsConfiguration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = awsConfiguration
        window?.makeKeyAndVisible()
        
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            let userInfo = launchOptions![UIApplication.LaunchOptionsKey.remoteNotification] as! [AnyHashable: Any]
            let body = userInfo["aps"] as? [String: Any]
            if let alert = body!["alert"] as? String {
                print("Got non-silent push notification:")
                let itemID = Int(alert.components(separatedBy: ": ")[0])
                let messageBody = Array(alert.components(separatedBy: ": ")[1...]).joined(separator: ". ")
                let accountID = UserDefaults.standard.value(forKey: "accountID") as! Int16
                let accounts = fetchAccount(accountID: accountID)
                let items: [Item]?
                if accounts?.count ?? 0 > 0 {
                    if let acct = accounts?[0] {
                        items = fetchItems(account: acct)
                        if let allItems = items {
                            for curr in allItems {
                                if curr.id == Int16(itemID!) {
                                    let msg = NSEntityDescription.insertNewObject(forEntityName: "Message", into: PersistenceService.context) as! Message
                                    msg.body = messageBody
                                    msg.isSender = false
                                    curr.addToMessages(msg)
                                    PersistenceService.saveContext()
                                    print("sent message")
                                    incomingMessageDelegate?.didReceiveIncomingMessage()
                                }
                            }
                        }
                    }
                }
            }
        }
        
		return true
	}

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Saved")
        self.deviceToken = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications with with error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Silent Push Notification
        if let alert = userInfo["aps"] as? [String: Any] {
//            let itemID = userInfo["itemID"] as! Int
            if let silent = alert["content-available"] as? Int {
                if silent == 1 {
                    // Do stuff for silent push notification
                    print("Got silent push notification")
                    print(userInfo)
                }
            }
        }
        completionHandler(UIBackgroundFetchResult(rawValue: 0)!)
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
        PersistenceService.saveContext()
	}
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        let body = userInfo["aps"] as? [String: Any]
        if let alert = body!["alert"] as? String {
            print("Got non-silent push notification:")
            let itemID = Int(alert.components(separatedBy: ": ")[0])
            let messageBody = Array(alert.components(separatedBy: ": ")[1...]).joined(separator: ". ")
            let accountID = UserDefaults.standard.value(forKey: "accountID") as! Int16
            let accounts = fetchAccount(accountID: accountID)
            let items: [Item]?
            if accounts?.count ?? 0 > 0 {
                if let acct = accounts?[0] {
                    items = fetchItems(account: acct)
                    if let allItems = items {
                        for curr in allItems {
                            if curr.id == Int16(itemID!) {
                                let msg = NSEntityDescription.insertNewObject(forEntityName: "Message", into: PersistenceService.context) as! Message
                                msg.body = messageBody
                                msg.isSender = false
                                curr.addToMessages(msg)
                                PersistenceService.saveContext()
                                print("sent message")
                                incomingMessageDelegate?.didReceiveIncomingMessage()
                            }
                        }
                    }
                }
            }
        }
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
