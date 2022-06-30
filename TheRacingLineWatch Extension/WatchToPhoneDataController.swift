//
//  WatchToPhoneDataController.swift
//  TheRacingLineWatch Extension
//
//  Created by David Ellis on 04/04/2021.
//

import Foundation
import WatchConnectivity
import SwiftDate


class WatchToPhoneDataController: NSObject, WCSessionDelegate, ObservableObject {
    
    static var shared = WatchToPhoneDataController()
    
    @Published var sessions: [Session] = []
    @Published var todaySession: [Session] = []
    @Published var allSessions: [Session] = []
    
    func loadSavedSessions() {
        
        let seconds = TimeZone.current.secondsFromGMT()
        let minutesToGMT = (seconds / 60) + (seconds % 60)
        
        // GET THIS WEEKS DATE STUFF
        let weekday = Calendar.current.component(.weekday, from: Date())
        let nextSundayDay: Date
        
        if weekday == 1 {
            nextSundayDay = Date()
        } else {
            nextSundayDay = Date().dateAt(.nextWeekday(.sunday))
        }
                
        let lastSundayDay = nextSundayDay - 6.days
        let nextSunday = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: nextSundayDay)! + minutesToGMT.minutes  + 4.hours + 30.minutes
        let lastSunday = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: lastSundayDay)! + minutesToGMT.minutes
        
        // GET TODAYS DATE STUFF
        let today = Date()
        let todayMidnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: today)! + minutesToGMT.minutes
        let todayAlmostMidnight = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: today)!  + minutesToGMT.minutes
        let tomorrowFourAM = todayAlmostMidnight + 4.hours + 30.minutes
        
        DispatchQueue.global().async {
            
            if let data = UserDefaults.standard.data(forKey: "sessions"){

                let decoder = JSONDecoder()
                if let jsonSessions = try? decoder.decode([Session].self, from: data) {
                    
                    DispatchQueue.main.async{
                        self.sessions = jsonSessions.filter { ($0.dateInTimeZone() >= lastSunday && $0.dateInTimeZone() < nextSunday) }.sorted { $0.date < $1.date }
                        self.todaySession = jsonSessions.filter { ($0.dateInTimeZone() >= todayMidnight && $0.dateInTimeZone() < tomorrowFourAM) }.sorted { $0.date < $1.date }
                        self.allSessions = jsonSessions.filter { ($0.dateInTimeZone() >= today) }.sorted { $0.date < $1.date }
                    }
                }
            }
        }
    }
    
    var wcSession = WCSession.default
    
    override init() {
        super.init()
        
        wcSession.delegate = self
        wcSession.activate()
        
        DispatchQueue.global().async {
            
            if let data = UserDefaults.standard.data(forKey: "sessions"){
                let decoder = JSONDecoder()
                if let jsonSessions = try? decoder.decode([Session].self, from: data) {
                    DispatchQueue.main.async{
                        self.sessions = jsonSessions
                    }
                }
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            print("Activated")
            sendMessage()
        default:
            print("Not able to talk to watch :(")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        decodeContext(context: applicationContext)
    }
    
    func decodeContext(context: [String:Any]) {
        
        let seconds = TimeZone.current.secondsFromGMT()
        let minutesToGMT = (seconds / 60) + (seconds % 60)
        
        // GET THIS WEEKS DATE STUFF
        let weekday = Calendar.current.component(.weekday, from: Date())
        let nextSundayDay: Date
        
        if weekday == 1 {
            nextSundayDay = Date()
        } else {
            nextSundayDay = Date().dateAt(.nextWeekday(.sunday))
        }
                
        let lastSundayDay = nextSundayDay - 6.days
        let nextSunday = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: nextSundayDay)! + minutesToGMT.minutes  + 4.hours + 30.minutes
        let lastSunday = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: lastSundayDay)! + minutesToGMT.minutes
        
        // GET TODAYS DATE STUFF
        let today = Date()
        let todayMidnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: today)! + minutesToGMT.minutes
        let todayAlmostMidnight = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: today)!  + minutesToGMT.minutes
        let tomorrowFourAM = todayAlmostMidnight + 4.hours + 30.minutes
        
        if let sessionData = context["sessions"] as? Data {
            let decoder = JSONDecoder()
            if let sessionJSON = try? decoder.decode([Session].self, from: sessionData) {
                DispatchQueue.main.async {
                    self.sessions = sessionJSON.filter { ($0.dateInTimeZone() >= lastSunday && $0.dateInTimeZone() < nextSunday) }.sorted { $0.date < $1.date }
                    self.todaySession = sessionJSON.filter { ($0.dateInTimeZone() >= todayMidnight && $0.dateInTimeZone() < tomorrowFourAM) }.sorted { $0.date < $1.date }
                    self.allSessions = sessionJSON.filter { ($0.dateInTimeZone() >= lastSunday) }.sorted { $0.date < $1.date }

                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(self.allSessions) {
                        UserDefaults.standard.set(encoded, forKey: "sessions")
                        UserDefaults.standard.synchronize() // MAYBE DO NOT NEED
                        
                    }
                }
            }
        }
    }
    
    func sendMessage() {
        wcSession.sendMessage(["Please Send":"Race Data"]) { (context) in
            self.decodeContext(context: context)
        } errorHandler: { (error) in
            print(error)
        }
    }
    
}
