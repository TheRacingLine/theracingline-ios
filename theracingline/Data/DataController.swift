//
//  DataController.swift
//  theracingline
//
//  Created by David Ellis on 12/11/2020.
//

import Foundation
import SwiftDate
import SwiftUI

class DataController: ObservableObject {

    static var shared = DataController()
        
    @Published var sessions: [Session] = []
    @Published var seriesList: [String] = []
    @Published var userAccessLevel: Int = 0
    @Published var onboarded: Bool = false
    @Published var visibleSeries: [String] = []
    @Published var seriesWithNotifications: [String] = []
    @Published var selectAllSeries: Bool = false
    @Published var delesctAllSeries: Bool = false
    @Published var notificationSound: String = "flyby_notification_no_bell.aiff"
//    @Published var notificationOffset1: Int = 0
//    @Published var notificationOffset2: Int = 0

    var todaysSessions: [Session] {
        return sessions.filter { $0.date.isToday && visibleSeries.contains($0.series) && $0.accessLevel <= userAccessLevel }.sorted { $0.date < $1.date }
    }
    
    // get this weeks events
    var thisWeekSessions: [Session] {
        
        let today = Date()
        let weekAway = Date() + 5.days
        
        return sessions.filter { $0.date < weekAway && $0.date >= today && visibleSeries.contains($0.series) && $0.accessLevel <= userAccessLevel }.sorted { $0.date < $1.date }
        
    }

    var allSessions: [Session] {
        
        let today = Date()
        return sessions.filter { $0.date >= today && visibleSeries.contains($0.series) }.sorted { $0.date < $1.date }
    }
    
    var currentDate: String {
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "dd"
        
        let day = nameFormatter.string(from: currentDate)
        return day
    }
    
    // MARK:- Session Data Controllers
    
    func saveData() {
        
        DispatchQueue.global().async {
            
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.sessions) {
                    defaults.set(encoded, forKey: "sessions")
                    defaults.synchronize() // MAYBE DO NOT NEED
                }
                
            }
        }
    }
    
    func loadData() {
        DispatchQueue.global().async {
            
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                if let data = defaults.data(forKey: "sessions"){
                    let decoder = JSONDecoder()
                    if let jsonSessions = try? decoder.decode([Session].self, from: data) {
                        DispatchQueue.main.async{
                            self.sessions = jsonSessions
                        }
                    }
                }
            }
        }
    }
    
    
    
    func getNewSessions() {
        let key = jsonbinsKey
        
        
        if let url = URL(string: sessionsStagingURL){ // STAGING SESSION LIST
//        if let url = URL(string: sessionsProductionURL){ // PROD SESSION LIST
 
            var request = URLRequest(url: url)
            request.addValue(key, forHTTPHeaderField: "secret-key")
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let webData = data {

                    if let json = try? JSONSerialization.jsonObject(with: webData, options: []) as? [[String:String]]{

                        var downloadedSessions: [Session] = []
                        
                        for jsonSession in json {
                            let session = Session()
                            
                            if let id = jsonSession["id"]{
                                session.id = id
                            }
                            
                            if let series = jsonSession["series"]{
                                session.series = series
                            }
                            
                            if let accessLevel = jsonSession["accessLevel"]{
                                session.accessLevel = Int(accessLevel)!
                            }
                            
                            if let darkR = jsonSession["darkR"]{
                                session.darkR = Double(darkR)!
                            }
                            
                            if let darkG = jsonSession["darkG"]{
                                session.darkG = Double(darkG)!
                            }
                            
                            if let darkB = jsonSession["darkB"]{
                                session.darkB = Double(darkB)!
                            }
                            
                            if let lightR = jsonSession["lightR"]{
                                session.lightR = Double(lightR)!
                            }
                            
                            if let lightG = jsonSession["lightG"]{
                                session.lightG = Double(lightG)!
                            }
                            
                            if let lightB = jsonSession["lightB"]{
                                session.lightB = Double(lightB)!
                            }
                            
                            if let seriesType = jsonSession["seriesType"]{
                                session.seriesType = seriesType
                            }
                            
                            if let event = jsonSession["event"]{
                                session.event = Int(event)!
                            }
                            
                            if let circuit = jsonSession["circuit"]{
                                session.circuit = circuit
                            }
                            
                            if let sessionName = jsonSession["sessionName"]{
                                session.sessionName = sessionName
                            }
                            
                            if let sessionType = jsonSession["sessionType"]{
                                session.sessionType = sessionType
                            }
                            
                            if let roundNumber = jsonSession["roundNumber"]{
                                session.roundNumber = Int(roundNumber)!
                            }
                            
                            if let durationType = jsonSession["durationType"]{
                                session.durationType = durationType
                            }
                            
                            if let duration = jsonSession["duration"]{
                                session.duration = Int(duration)!
                            }
                            
                            if let dateString = jsonSession["date"]{
                                
                                if let dateInRegion = dateString.toDate() {
                                    session.date = dateInRegion.date
                                }
                            }
                            
                            if let tbaString = jsonSession["tba"]{
                                if tbaString == "true" {
                                    session.tba = true
                                } else {
                                    session.tba = false
                                }
                            }
                            
                            
                            downloadedSessions.append(session)
                        } // FOR JSONSession
                        DispatchQueue.main.async {
                            print("Sessions Downloaded")
                            self.sessions = downloadedSessions
                            self.saveData()
                        }
                    } //IF LET TRY
                } //IF LET WEBDATA
            } // URLSESSION
            .resume()
        }
    }
    
    // MARK:- Series Data Controllers
    
    func getSeriesList() {
        let key = jsonbinsKey
        
        
         if let url = URL(string: seriesStagingURL){ // STAGING SERIES LIST
//        if let url = URL(string: seriesProductionURL){ // PROD SERIES LIST
            
            
            var request = URLRequest(url: url)
            request.addValue(key, forHTTPHeaderField: "secret-key")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let webData = data {
                    if let json = try? JSONSerialization.jsonObject(with: webData, options: []) as? [[String:[String]]]{
                        var downloadedSeriesList: [String] = []
                        
                        for jsonList in json {
                            if let seriesList = jsonList["seriesList"] {
                                downloadedSeriesList = seriesList
                            }
                            
                        }
                        var newSeries: [String]?
                        for seriesName in downloadedSeriesList {
                            if !self.seriesList.contains(seriesName){
                                if newSeries == nil {
                                    newSeries = [seriesName]
                                } else {
                                    newSeries?.append(seriesName)
                                }
                            }
                        }
   
                        DispatchQueue.main.async {
                            
                            if newSeries != nil {
                                self.visibleSeries.append(contentsOf: newSeries!)
                                self.seriesWithNotifications.append(contentsOf: newSeries!)
                            }

                            self.seriesList = downloadedSeriesList
                            self.saveSeriesData()
                        }
                    }
                }
            }.resume()
        }
    }


    func saveSeriesData() {
        DispatchQueue.global().async {
            
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.seriesList) {
                    defaults.set(encoded, forKey: "seriesList")
                    defaults.synchronize() // MAYBE DO NOT NEED
                }
            }
            
        }
    }

    func loadSeriesData() {
        DispatchQueue.global().async {
            
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                
                if let data = defaults.data(forKey: "seriesList"){
                    let decoder = JSONDecoder()
                    if let jsonSeriesList = try? decoder.decode([String].self, from: data) {
                        DispatchQueue.main.async{
                            self.seriesList = jsonSeriesList
                        }
                    }
                }
            }
        }
    }
    
    // MARK:- AccessLevel Data Controllers
    
    func setUserAccessLevel(newAccessLevel: Int) {
        DispatchQueue.global().async {
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(newAccessLevel) {
                    defaults.set(encoded, forKey: "userAccessLevel")
                    defaults.synchronize() // MAYBE DO NOT NEED
                    self.getUserAccessLevel()
                }
            }
            
        }
    }
    
    func getUserAccessLevel() {
        DispatchQueue.global().async {
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                if let data = defaults.data(forKey: "userAccessLevel"){
                    let decoder = JSONDecoder()
                    if let jsonUserAccessLevel = try? decoder.decode(Int.self, from: data) {
                        DispatchQueue.main.async{
                            self.userAccessLevel = jsonUserAccessLevel
                        }
                    }
                }
            }
        }
    }
    
    // MARK:- Time Controllers
    
    func timeToUTC(dateStr: String, timeZoneString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.init(abbreviation: timeZoneString)
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "H:mm:ss"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func localToUTC(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "H:mm:ss"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }

    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    // MARK: - Notification Preferences
    
    func initiliseNotificationSettings(){
        self.seriesWithNotifications = self.seriesList
    }
    
    func getNotificationPreferences(){
        // load each time the array is updated
        // load before building the notification
        DispatchQueue.global().async {
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.seriesWithNotifications) {
                    defaults.set(encoded, forKey: "notificationPreferences")
                    defaults.synchronize() // MAYBE DO NOT NEED
                }
            }
        }
    }
    
    func setNotificationPreferences(){
        // run each time the array is updated
        DispatchQueue.global().async {
            
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.seriesWithNotifications) {
                    defaults.set(encoded, forKey: "notificationPreferences")
                    defaults.synchronize() // MAYBE DO NOT NEED
                }
            }
            
        }
    }
    
    func selectAllNotificationsSeries(){
        self.seriesWithNotifications = self.visibleSeries
    }
    
    func selectNoneNotificationsSeries(){
        self.seriesWithNotifications = []
    }
    
    // MARK: - Series List Preferences
    
    func initiliseVisibleSeries(){
        self.visibleSeries = self.seriesList
    }
    
    func getVisibleSeriesPreferences(){
        // load each time the array is updated
        DispatchQueue.global().async {
            
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                if let data = defaults.data(forKey: "visibleSeriesPreferences"){
                    let decoder = JSONDecoder()
                    if let jsonSeriesList = try? decoder.decode([String].self, from: data) {
                        DispatchQueue.main.async{
                            self.visibleSeries = jsonSeriesList
                        }
                    }
                }
            }
        }
    }
    
    func setVisibleSeriesPreferences(){
        // run each time the array is updated
        DispatchQueue.global().async {
            
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.visibleSeries) {
                    defaults.set(encoded, forKey: "visibleSeriesPreferences")
                    defaults.synchronize() // MAYBE DO NOT NEED
                }
            }
        }
    }
    
    // this is for the Notifications toggles list
    func getVisibleSeriesListInOrder() -> [String]{
        let visibleSeriesListInOrder = seriesList.filter { visibleSeries.contains($0) }
        return visibleSeriesListInOrder
    }
    
    func selectAllVisibleSeries(){
        self.visibleSeries = self.seriesList
    }
    
    func selectNoneVisibileSeries(){
        self.visibleSeries = []
    }
    
    // MARK:- Sound Data Controllers
    
    func setNotificationSound(sound: String) {
        DispatchQueue.global().async {
            
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(sound) {
                    defaults.set(encoded, forKey: "notificationSound")
                    defaults.synchronize() // MAYBE DO NOT NEED
                    self.getNotificationSound()
                }
            }
        }
    }
    
    func getNotificationSound() {
        DispatchQueue.global().async {
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                if let data = defaults.data(forKey: "notificationSound"){
                    let decoder = JSONDecoder()
                    if let jsonNotificationSound = try? decoder.decode(String.self, from: data) {
                        DispatchQueue.main.async{
                            self.notificationSound = jsonNotificationSound
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Haptic Controller
    
    func menuHaptics() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // MARK:- Widget Data Controllers
    
    func getRacesForWidget() -> [Session]{
        if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
            if let data = defaults.data(forKey: "sessions"){
                let decoder = JSONDecoder()
                if let jsonSessions = try? decoder.decode([Session].self, from: data) {
                    
                    let today = Date()
                    let weekAway = Date() + 5.days
                    
                    let thisWeeksEvents = jsonSessions.filter { $0.date < weekAway && $0.date >= today }.sorted { $0.date < $1.date }

//                    let slice = thisWeeksEvents.prefix(100)
                    return thisWeeksEvents
                    
                }
            }
        }
        return []
    }
    
    func getUserAccessLevelForWidget() -> Int {
        if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
            if let data = defaults.data(forKey: "userAccessLevel"){
                let decoder = JSONDecoder()
                if let jsonUserAccessLevel = try? decoder.decode(Int.self, from: data) {
                    return jsonUserAccessLevel
                }
            }
        }
        return 0
    }
    
    func getVisibleSeriesPreferencesForWidget() -> [String]{
            
        if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
            if let data = defaults.data(forKey: "visibleSeriesPreferences"){
                let decoder = JSONDecoder()
                if let jsonSeriesList = try? decoder.decode([String].self, from: data) {
                    return jsonSeriesList
                }
            }
        }
        return []
    }
}

