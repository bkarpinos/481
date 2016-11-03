//
//  AppDelegate.swift
//  reminder app
//
//  Created by Brett Karpinos on 10/9/16.
//
//

import UIKit
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //get authorization for sending notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {(accepted, error) in
          if !accepted {
            print("Notification access denied.")
          }
        }
        //create the actions for the notification
        let reminderActionView = UNNotificationAction(identifier: "view", title: "View", options: [] )
        let reminderActionRemindLater = UNNotificationAction(identifier: "remindMe", title: "Remind Me Later", options: [])
        //create a reminder catergory for notifications
        let category = UNNotificationCategory(identifier: "reminderCategory", actions:[reminderActionView, reminderActionRemindLater], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
      
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
    //takes in the date, title and description
  func scheduleNotification(at date: Date, title: String/*, description: String*/){
      //use a custome sound for our notification
      let notificationSound = UNNotificationSound(named: "piano.wav")
      //get the date components of the date passed in
      let calendar = Calendar(identifier: .gregorian)
      let components = calendar.dateComponents(in: .current, from: date)
      let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month,   day: components.day, hour: components.hour, minute: components.minute)
      //create the trigger for the notification
      let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
      //create a content object
      let content = UNMutableNotificationContent()
      content.categoryIdentifier = "reminderCategory"
      content.title = title
      //content.body = "WIP"
      content.sound = notificationSound
    
      //use the title as the identifier
      let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
    
      UNUserNotificationCenter.current().delegate = self
      //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
      UNUserNotificationCenter.current().add(request) {(error) in
      if let error = error {
        print("Oh no an error! : \(error)")
      }
    }
  }
  //removes the original notification and creates a new one
  func editNotification(at date: Date, title: String){
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [title])
    scheduleNotification(at: date, title: title)
  }
  //removes the notification from the notification center
  func deleteNotification(title: String){
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [title])
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let notify = response.notification
    let request = notify.request
    let iden = request.identifier
    //let content = request.content
    //let body = content.body
    if response.actionIdentifier == "remindMe" {
      //15 minutes after the current date
      let newDate = Date(timeInterval: 900, since: Date())
      scheduleNotification(at: newDate, title: iden/*, description: body*/)
    }
    else if response.actionIdentifier == "view" {
      
    }
  }
}

