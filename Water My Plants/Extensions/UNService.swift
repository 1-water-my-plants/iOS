//
//  UNService.swift
//  Water My Plants
//
//  Created by Sal B Amer on 3/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import UserNotifications

class UNService: NSObject {
    
    private override init() {}
    static let shared = UNService()
    
    
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound, .carPlay]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "No UN auth error")
            guard granted else {
                print("USER DENIED ACCESs")
                return
            }
            
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
    }
    
//    func setupActionsAndCategories() {
//        let timerAction = UNNotificationAction(identifier: NotificationActionID.timer.rawValue,
//                                               title: "Run timer logic",
//                                               options: [.authenticationRequired])
//        let dateAction = UNNotificationAction(identifier: NotificationActionID.date.rawValue,
//                                               title: "Run date logic",
//                                               options: [.destructive])
//        let locationAction = UNNotificationAction(identifier: NotificationActionID.location.rawValue,
//                                               title: "Run location logic",
//                                               options: [.foreground])
//
//        let timerCategory = UNNotificationCategory(identifier: NotificationCategory.timer.rawValue,
//                                                   actions: [timerAction],
//                                                   intentIdentifiers: [])
//        let dateCategory = UNNotificationCategory(identifier: NotificationCategory.date.rawValue,
//                                                   actions: [dateAction],
//                                                   intentIdentifiers: [])
//        let locationCategory = UNNotificationCategory(identifier: NotificationCategory.location.rawValue,
//                                                   actions: [locationAction],
//                                                   intentIdentifiers: [])
//
//        unCenter.setNotificationCategories([timerCategory, dateCategory, locationCategory])
//    }
    
    
    
    func dateRequest(with components: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Time to feed Moth Orchid"
        content.body = "Hey..give me some water!"
        content.sound = .default
        content.badge = 1

        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "userNotification.date",
                                            content: content,
                                            trigger: trigger)
        unCenter.add(request)
    }
    
}

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        
//        if let action = NotificationActionID(rawValue: response.actionIdentifier) {
//            NotificationCenter.default.post(name: NSNotification.Name("internalNotification.handleAction"),
//                                            object: action)
//        }
//
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN WILL present")
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}

