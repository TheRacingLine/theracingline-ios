//
//  NotificationController.swift
//  theracingline
//
//  Created by David Ellis on 25/11/2020.
//

import Foundation
import UserNotifications
import SwiftDate
import SwiftUI

class NotificationController: ObservableObject {
    
    static var shared = NotificationController()
    
    @ObservedObject var data = DataController.shared
    
    @Published var notificationOffset1: Int = 0
    @Published var notificationOffset2: Int = 0
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
//                print("Notifications Allowed")
                self.rebuildNotifications()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func rebuildNotifications(){
        
//        print("Rebuilding notifications")
//        print("Notification offset set to \(self.notificationOffset1)")
//        
        let fullSessionList = data.allSessions

        // clear notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Weekly Notification
        setReminderNotificaton()
        
        // Session Notifications
        if data.userAccessLevel >= 3 {
            //filter sessions based on preferences
            let sessionsFilteredByNotifications = filterSeriesByPreferences(sessions: fullSessionList)
            
            //loop through remaining sessions and set notifications
            for (index, session) in sessionsFilteredByNotifications.enumerated() {
                if index < 40 && session.tba == false {
                    setNotifictions(session: session)
                }
            }
        }
    }
    
    func filterSeriesByPreferences(sessions: [Session]) -> [Session] {
        let seriesWithNotifications = data.seriesWithNotifications
        
        let raceNotifications = data.getRaceNotificationSetting()
        let qualNotifications = data.getQualNotificationSetting()
        let pracNotifications = data.getPracNotificationSetting()
        
        return sessions.filter { seriesWithNotifications.contains($0.series) && $0.tba == false && (($0.sessionType == "P" && pracNotifications) || ($0.sessionType == "Q" && qualNotifications) || ($0.sessionType == "R" && raceNotifications)) }
    }
    
    func setReminderNotificaton() {
//        print("Weekly notification being set.")
        let content = UNMutableNotificationContent()
        content.title = "See What's On This Week"
        content.body = "Open the app once a week to update race data and start time notifications"
        
        
        // extra from current date
        // add 5 days to current date
        let today = Date()
        let fiveDays = today + 5.days
        let todayCalendar = Calendar.current
        
        let fiveDayComponent = todayCalendar.component(.weekday, from: fiveDays)
        let hourComponent = todayCalendar.component(.hour, from: fiveDays)
        let minuteComponent = todayCalendar.component(.minute, from: fiveDays)

        // create date for notification
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        dateComponents.weekday = fiveDayComponent
        dateComponents.hour = hourComponent
        dateComponents.minute = minuteComponent

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }
    
    func setNotifictions(session: Session) {
        
        
        let timeOffset = notificationOffset1
        let currentDate = Date()

        let secondsBetweenNowAndRace = Int(currentDate.getInterval(toDate: session.date, component: .second))
        let secondsUntilNotification = secondsBetweenNowAndRace - timeOffset
        
        if secondsUntilNotification > 0 {
            let messageString = buildNotificationTimeString(session: session)
            
            let content = UNMutableNotificationContent()
            content.title = session.series
            content.subtitle = "\(session.circuit) - \(session.sessionName)"
            content.body = messageString
            content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: data.notificationSound))
            if #available(iOS 15.0, *) {
                content.interruptionLevel = .timeSensitive
            }
            
//            print(content.title)
//            print(content.subtitle)
//            print(content.body)

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(secondsUntilNotification), repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                   print("Unable to add notification request, \(error.localizedDescription)")
                 }
            }
        }
    }
    
    func clearNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func setNotificationTime(notificationNumber: Int, days: Int, hours: Int, minutes: Int) {
        let minutesInSeconds = minutes * 60
        let hoursInSeconds = hours * 3600
        let daysInSeconds = days * 86400
        let seconds = minutesInSeconds + hoursInSeconds + daysInSeconds
        
        if notificationNumber == 1 {
            self.notificationOffset1 = seconds
        } else if notificationNumber == 2 {
            self.notificationOffset2 = seconds
        }
    }
    
    func saveNotificationTime(notificationNumber: Int) {
        
        if notificationNumber == 1 {
            DispatchQueue.global().async {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.notificationOffset1) {
                    UserDefaults.standard.set(encoded, forKey: "notificationOffset1")
                    UserDefaults.standard.synchronize() // MAYBE DO NOT NEED
                }
            }
        } else if notificationNumber == 2 {
            DispatchQueue.global().async {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.notificationOffset2) {
                    UserDefaults.standard.set(encoded, forKey: "notificationOffset2")
                    UserDefaults.standard.synchronize() // MAYBE DO NOT NEED
                }
            }
        }
        
    }
    
    func loadNotificationTime(notificationNumber: Int) {
        if notificationNumber == 1 {
            DispatchQueue.global().async {
                if let data = UserDefaults.standard.data(forKey: "notificationOffset1"){
                    let decoder = JSONDecoder()
                    if let jsonNotification = try? decoder.decode(Int.self, from: data) {
                        DispatchQueue.main.async{
//                            print("Notification offset set to \(self.notificationOffset1)")
                            self.notificationOffset1 = jsonNotification
                        }
                    }
                }
            }
        } else if notificationNumber == 2 {
            DispatchQueue.global().async {
                if let data = UserDefaults.standard.data(forKey: "notificationOffset2"){
                    let decoder = JSONDecoder()
                    if let jsonNotification = try? decoder.decode(Int.self, from: data) {
                        DispatchQueue.main.async{
                            self.notificationOffset2 = jsonNotification
                        }
                    }
                }
            }
        }
    }
    
    func getNotificationTime() -> Int {
        if let data = UserDefaults.standard.data(forKey: "notificationOffset1"){
            let decoder = JSONDecoder()
            if let jsonNotification = try? decoder.decode(Int.self, from: data) {
               self.notificationOffset1 = jsonNotification
               return jsonNotification
            }
        }
        return 0
    }
    
    func getNotificatimeTimeDays(notificationNumber: Int) -> Int {
        if notificationNumber == 1 {
            let days = (notificationOffset1 / 86400)
            return days
        } else if notificationNumber == 2 {
            let days = (notificationOffset2 / 86400)
            return days
        }
        
        return 0
    }
    
    func getNotificatimeTimeHours(notificationNumber: Int) -> Int {
        if notificationNumber == 1 {
            let hours = ((notificationOffset1 % 86400) / 3600)
            
            return hours
        } else if notificationNumber == 2 {
            let hours = ((notificationOffset2 % 86400) / 3600)
            
            return hours
        }
        
        return 0
    }
    
    func getNotificatimeTimeMinutes(notificationNumber: Int) -> Int {
        if notificationNumber == 1 {
            let minutes = (((notificationOffset1 % 86400) % 3600) / 60)
            
            return minutes
        } else if notificationNumber == 2 {
            let minutes = (((notificationOffset1 % 86400) % 3600) / 60)
            
            return minutes
        }
        
        return 0
    }
    
    func buildNotificationTimeString(session: Session) -> String {
        
        var daysString = ""
        var hoursString = ""
        var minutesString = ""
        
        let days = getNotificatimeTimeDays(notificationNumber: 1)
        let hours = getNotificatimeTimeHours(notificationNumber: 1)
        let minutes = getNotificatimeTimeMinutes(notificationNumber: 1)
        
        if session.durationType == "AD" {
            if days < 1 {
                return "Event begins today"
            } else if days < 2 {
                return "Event begins tomorrow"
            } else {
                return "Event begins in \(days) days."
            }
        }
        
        if days != 0 {
            if days == 1 {
                daysString = "\(days) day "
            } else {
                daysString = "\(days) days "
            }
        }
        
        if hours != 0 {
            if hours == 1 {
                hoursString = "\(hours) hour "
            } else {
                hoursString = "\(hours) hours "
            }
        }
        
        if minutes != 0 {
            if minutes == 1 {
                minutesString = "\(minutes) minute "
            } else {
                minutesString = "\(minutes) minutes "
            }
        }
        
        var messageString = "Unkown"
        
        if days == 0 && hours == 0 && minutes == 0 {
            messageString = "Event beginning now"
        } else {
            messageString = "Event begins in \(daysString)\(hoursString)\(minutesString)"
        }
            
        return messageString
    }
}
