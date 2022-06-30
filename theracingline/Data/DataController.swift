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
    
    @Published var raceNotifications: Bool = true
    @Published var qualNotifications: Bool = true
    @Published var pracNotifications: Bool = true
    
    //@Published var filterSeriesType = "All"
    @Published var filterSeriesSingleSeater = true
    @Published var filterSeriesSportsCar = true
    @Published var filterSeriesTouringCars = true
    @Published var filterSeriesStockCars = true
    @Published var filterSeriesRally = true
    @Published var filterSeriesBikes = true
    @Published var filterSeriesOther = true
    
    //@Published var filterSessionType = "All"
    @Published var filterSessionRace = true
    @Published var filterSessionQualifying = true
    @Published var filterSessionPractice = true
    @Published var filterStartDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())! - 1.weeks
    @Published var filterEndDate = Date() + 2.years
    
    // Removed until multiple notification offsets are supported
    
//    @Published var notificationOffset1: Int = 0
//    @Published var notificationOffset2: Int = 0

    var todaysSessions: [Session] {
        
        let seconds = TimeZone.current.secondsFromGMT()
        let minutesToGMT = (seconds / 60) + (seconds % 60)
    
        let today = Date()
        let todayMidnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: today)! + minutesToGMT.minutes
        let todayAlmostMidnight = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: today)!  + minutesToGMT.minutes
        let tomorrowFourAM = todayAlmostMidnight + 4.hours + 30.minutes
        
        return sessions.filter { ($0.dateInTimeZone() >= todayMidnight && $0.dateInTimeZone() < tomorrowFourAM) && visibleSeries.contains($0.series) && $0.accessLevel <= userAccessLevel && (isSeriesFiltered(seriesType: $0.seriesType)) && (isSessionFiltered(sessionType: $0.sessionType)) && ($0.date >= filterStartDate && $0.date <= filterEndDate)}.sorted { $0.date < $1.date }
    }
    
    // get this weeks events
    var thisWeekSessions: [Session] {
        
        let seconds = TimeZone.current.secondsFromGMT()
        let minutesToGMT = (seconds / 60) + (seconds % 60)
        
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
        
        return sessions.filter { $0.dateInTimeZone() <= nextSunday && $0.dateInTimeZone() >= lastSunday && visibleSeries.contains($0.series) && $0.accessLevel <= userAccessLevel && (isSeriesFiltered(seriesType: $0.seriesType)) && (isSessionFiltered(sessionType: $0.sessionType)) && ($0.date >= filterStartDate && $0.date <= filterEndDate)}.sorted { $0.date < $1.date }
    }
    
    // get last weeks events
    var lastWeekSessions: [Session] {
        
        let seconds = TimeZone.current.secondsFromGMT()
        let minutesToGMT = (seconds / 60) + (seconds % 60)
        
        let weekday = Calendar.current.component(.weekday, from: Date())
        let nextSundayDay: Date
        
        if weekday == 1 {
            nextSundayDay = Date()
        } else {
            nextSundayDay = Date().dateAt(.nextWeekday(.sunday))
        }
                
        let lastSundayDay = nextSundayDay - 6.days
        let lastlastSundayDay = lastSundayDay - 6.days
        
        let nextSunday = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: nextSundayDay)! + minutesToGMT.minutes  + 4.hours + 30.minutes
        let lastSunday = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: lastSundayDay)! + minutesToGMT.minutes
        let lastlastSunday = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: lastlastSundayDay)! + minutesToGMT.minutes
        
        return sessions.filter { $0.dateInTimeZone() <= lastSunday && $0.dateInTimeZone() >= lastlastSunday && visibleSeries.contains($0.series) && $0.accessLevel <= userAccessLevel }.sorted { $0.date < $1.date }
    }
    
    // get next weeks events
    var nextWeekSessions: [Session] {
        
        let seconds = TimeZone.current.secondsFromGMT()
        let minutesToGMT = (seconds / 60) + (seconds % 60)
        
        let weekday = Calendar.current.component(.weekday, from: Date())
        let nextSundayDay: Date
        
        if weekday == 1 {
            nextSundayDay = Date()
        } else {
            nextSundayDay = Date().dateAt(.nextWeekday(.sunday))
        }
                
        let lastSundayDay = nextSundayDay - 6.days
        let nextnextSundayDay = nextSundayDay + 8.days
        
        let nextSunday = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: nextSundayDay)! + minutesToGMT.minutes  + 4.hours + 30.minutes
        let lastSunday = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: lastSundayDay)! + minutesToGMT.minutes
        let nextnextSunday = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: nextnextSundayDay)! + minutesToGMT.minutes
        
        return sessions.filter { $0.dateInTimeZone() <= nextnextSunday && $0.dateInTimeZone() >= nextSunday && visibleSeries.contains($0.series) && $0.accessLevel <= userAccessLevel && (isSeriesFiltered(seriesType: $0.seriesType)) && (isSessionFiltered(sessionType: $0.sessionType)) && ($0.date >= filterStartDate && $0.date <= filterEndDate)}.sorted { $0.date < $1.date }
    }

    var allSessions: [Session] {
        
        let today = Date()
        return sessions.filter { $0.date >= today && visibleSeries.contains($0.series) && (isSeriesFiltered(seriesType: $0.seriesType)) && (isSessionFiltered(sessionType: $0.sessionType)) && ($0.date >= filterStartDate && $0.date <= filterEndDate)}.sorted { $0.date < $1.date }
    }
    
    var allSessionsNoFilter: [Session] {
        
        let today = Date()
        return sessions.filter { $0.date >= today && visibleSeries.contains($0.series)}.sorted { $0.date < $1.date }
    }
    
    var currentDate: String {
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "dd"
        
        let day = nameFormatter.string(from: currentDate)
        return day
    }
    
    // MARK: - Session Data Controllers
    
    func saveData() {
        
        DispatchQueue.global().async {
            
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.sessions) {
                    defaults.set(encoded, forKey: "sessions")
                    defaults.synchronize() // MAYBE DO NOT NEED
                    
                }
            }
            
            PhoneToWatchDataController.shared.sendContext(context: PhoneToWatchDataController.shared.convertSessionsToContext(sessions: self.thisWeekSessions))
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
                            PhoneToWatchDataController.shared.sendContext(context: PhoneToWatchDataController.shared.convertSessionsToContext(sessions: self.thisWeekSessions))
                        }
                    }
                }
            }
        }
    }
    
    func getNewSessions() {
        let key = jsonbinsKey
        
        
        if let url = URL(string: sessionURL){ // SESSION LIST
 
            var request = URLRequest(url: url)
            request.addValue(key, forHTTPHeaderField: "secret-key")
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let webData = data {

                    if let json = try? JSONSerialization.jsonObject(with: webData, options: []) as? [[String:String]]{
//                        print(json)
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
//                            print("Sessions Downloaded")
                            self.sessions = downloadedSessions
                            self.saveData()
                        }
                    } //IF LET TRY
                } //IF LET WEBDATA
            } // URLSESSION
            .resume()
        }
    }
    
    // MARK: - Series Data Controllers
    
    func getSeriesList() {
        let key = jsonbinsKey
        
        
        if let url = URL(string: seriesURL){ // SERIES LIST
            
            
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
    
    // MARK: - AccessLevel Data Controllers
    
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
                if let data = defaults.data(forKey: "notificationPreferences"){
                    let decoder = JSONDecoder()
                    if let jsonSeriesList = try? decoder.decode([String].self, from: data) {
                        DispatchQueue.main.async{
                            self.seriesWithNotifications = jsonSeriesList
                        }
                    }
                }
                
                if let data = defaults.data(forKey: "sessionNotificationPreferences"){
                    let decoder = JSONDecoder()
                    if let jsonSeriesSessionList = try? decoder.decode([Bool].self, from: data) {
                        DispatchQueue.main.async{
                            self.raceNotifications = jsonSeriesSessionList[0]
                            self.qualNotifications = jsonSeriesSessionList[1]
                            self.pracNotifications = jsonSeriesSessionList[2]
                        }
                    }
                }
            }
        }
        
//        DispatchQueue.global().async {
//            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
//                let encoder = JSONEncoder()
//                if let encoded = try? encoder.encode(self.seriesWithNotifications) {
//                    defaults.set(encoded, forKey: "notificationPreferences")
//                    defaults.synchronize() // MAYBE DO NOT NEED
//                }
//            }
//        }
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
                
                let sessionSettings = [self.raceNotifications, self.qualNotifications, self.pracNotifications]
                
                if let encoded = try? encoder.encode(sessionSettings) {
                    defaults.set(encoded, forKey: "sessionNotificationPreferences")
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
    
    // SESSIONS
    
    func getRaceNotificationSetting() -> Bool {
        return raceNotifications
    }
    
    func getQualNotificationSetting() -> Bool{
        return qualNotifications
    }
    
    func getPracNotificationSetting() -> Bool{
        return pracNotifications
    }
    
    func setRaceNotificationSetting(setting: Bool) {
        self.raceNotifications = setting
    }
    
    func setQualNotificationSetting(setting: Bool) {
        self.qualNotifications = setting
    }
    
    func setPracNotificationSetting(setting: Bool) {
        self.pracNotifications = setting
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
    
    // MARK: - Sound Data Controllers
    
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
    
    func simpleMenuHaptics() {
        let impactLight = UIImpactFeedbackGenerator(style: .light)
        impactLight.impactOccurred()
    }
    
    // MARK: - Widget Data Controllers
    
    func getRacesForWidget() -> [Session]{
        if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
            if let data = defaults.data(forKey: "sessions"){
                let decoder = JSONDecoder()
                if let jsonSessions = try? decoder.decode([Session].self, from: data) {
                    
                    let seconds = TimeZone.current.secondsFromGMT()
                    let minutesToGMT = (seconds / 60) + (seconds % 60)
                    
                    let weekday = Calendar.current.component(.weekday, from: Date())
                    let nextSundayDay: Date
                    let startOfTodayDay = Date()
                    
                    if weekday == 1 {
                        nextSundayDay = Date()
                    } else {
                        nextSundayDay = Date().dateAt(.nextWeekday(.sunday))
                    }

                    let nextSunday = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: nextSundayDay)! + minutesToGMT.minutes  + 4.hours + 30.minutes
                    
                    let startOfToday = Calendar.current.date(bySettingHour: 0, minute: 0, second: 1, of: startOfTodayDay)!
                    
                    let now = Date()
                    
                    return jsonSessions.filter { ($0.date < nextSunday && $0.date >= now) || ($0.durationType == "AD" && $0.date < nextSunday && $0.date >= startOfToday) }.sorted { $0.date < $1.date }
//                    return jsonSessions.filter { ($0.durationType == "AD" && $0.date < nextSunday && $0.date >= startOfToday) }.sorted { $0.date < $1.date }
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
    
    // MARK: - Filter Controllers
    
    func saveFilterStringSettings(){
        // run each time the array is updated
        print("Save filters called")

        
        // let filterStringSettings = [self.filterSeriesType, self.filterSessionType]
        let filterSeriesSettings = [self.filterSeriesSingleSeater, self.filterSeriesSportsCar, self.filterSeriesTouringCars, self.filterSeriesStockCars, self.filterSeriesRally, self.filterSeriesBikes, self.filterSeriesOther]
        let filterSessionSettings = [self.filterSessionPractice, self.filterSessionQualifying, self.filterSessionRace]
        DispatchQueue.global().async {
            
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(filterSeriesSettings) {
                    defaults.set(encoded, forKey: "filterSeriesSettings")
                    defaults.synchronize() // MAYBE DO NOT NEED
                }
                
                if let encoded = try? encoder.encode(filterSessionSettings) {
                    defaults.set(encoded, forKey: "filterSessionSettings")
                    defaults.synchronize() // MAYBE DO NOT NEED
                }
                UserDefaults.standard.set(self.filterStartDate.timeIntervalSince1970, forKey: "filterStartDate")
                UserDefaults.standard.set(self.filterEndDate.timeIntervalSince1970, forKey: "filterEndDate")
            }
        }
    }
    
    func loadFilterStringSettings(){
        // load each time the array is updated
                
        DispatchQueue.global().async {
            
            if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
                
                // SERIES SETTINGS
                if let data = defaults.data(forKey: "filterSeriesSettings"){
                    let decoder = JSONDecoder()
                    if let jsonfilterStringList = try? decoder.decode([Bool].self, from: data) {
                        DispatchQueue.main.async{
                            self.filterSeriesSingleSeater = jsonfilterStringList[0]
                            self.filterSeriesSportsCar = jsonfilterStringList[1]
                            self.filterSeriesTouringCars = jsonfilterStringList[2]
                            self.filterSeriesStockCars = jsonfilterStringList[3]
                            self.filterSeriesRally = jsonfilterStringList[4]
                            self.filterSeriesBikes = jsonfilterStringList[5]
                            self.filterSeriesOther = jsonfilterStringList[6]
                        }
                    }
                }
                
                // SESSION SETTINGS
                if let data = defaults.data(forKey: "filterSessionSettings"){
                    let decoder = JSONDecoder()
                    if let jsonfilterStringList = try? decoder.decode([Bool].self, from: data) {
                        DispatchQueue.main.async{
                            self.filterSessionPractice = jsonfilterStringList[0]
                            self.filterSessionQualifying = jsonfilterStringList[1]
                            self.filterSessionRace = jsonfilterStringList[2]
                        }
                    }
                }
                
                // DATES
                DispatchQueue.main.async{
                    print("Load filter datez --------------")

                    self.filterStartDate = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "filterStartDate"))
                    self.filterEndDate = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "filterEndDate"))
                }
            }
        }
    }
    
    // CHECKERS
    
    func isSeriesFiltered(seriesType: String) -> Bool {
        switch seriesType {
        case "Single Seater":
            if self.filterSeriesSingleSeater == true {
                return true
            } else {
                return false
            }
            
        case "Sportscars":
            if self.filterSeriesSportsCar == true {
                return true
            } else {
                return false
            }
            
        case "Touring Cars":
            if self.filterSeriesTouringCars == true {
                return true
            } else {
                return false
            }
            
        case "Stock Cars":
            if self.filterSeriesStockCars == true {
                return true
            } else {
                return false
            }

        case "Other":
            if self.filterSeriesOther == true {
                return true
            } else {
                return false
            }

        case "Rally":
            if self.filterSeriesRally == true {
                return true
            } else {
                return false
            }

        case "Bikes":
            if self.filterSeriesBikes == true {
                return true
            } else {
                return false
            }
        
        default:
            return false
        }
    }
    
    func isSessionFiltered(sessionType: String) -> Bool {
        switch sessionType {
        case "P":
            if self.filterSessionPractice == true {
                return true
            } else {
                return false
            }

        case "Q":
            if self.filterSessionQualifying == true {
                return true
            } else {
                return false
            }

        case "R":
            if self.filterSessionRace == true {
                return true
            } else {
                return false
            }
            
        default:
            return false
        }
    }
    
    // GETTERS
    
    func getSingleSeaterFilter() -> Bool {
        return self.filterSeriesSingleSeater
    }
    
    func getSportsCarFilter() -> Bool {
        return self.filterSeriesSportsCar
    }
    
    func getTouringCarsFilter() -> Bool {
        return self.filterSeriesTouringCars
    }
    
    func getStockCarsFilter() -> Bool {
        return self.filterSeriesStockCars
    }
    
    func getRallyFilter() -> Bool {
        return self.filterSeriesRally
    }
    
    func getBikesFilter() -> Bool {
        return self.filterSeriesBikes
    }
    
    func getOtherFilter() -> Bool {
        return self.filterSeriesOther
    }
    
    func getFilterStartDate() -> Date {
        return self.filterStartDate
    }
    
    func getFilterEndDate() -> Date {
        return self.filterEndDate
    }
    
    func getPracticeFilter() -> Bool {
        return self.filterSessionPractice
    }
    
    func getQualifyingFilter() -> Bool {
        return self.filterSessionQualifying
    }
    
    func getRaceFilter() -> Bool {
        return self.filterSessionRace
    }
    
    // SETTERS
    
    func setSingleSeaterFilter(setting: Bool) {
        self.filterSeriesSingleSeater = setting
    }
    
    func setSportsCarFilter(setting: Bool) {
        self.filterSeriesSportsCar = setting
    }
    
    func setTouringCarsFilter(setting: Bool) {
        self.filterSeriesTouringCars = setting
    }
    
    func setStockCarsFilter(setting: Bool) {
        self.filterSeriesStockCars = setting
    }
    
    func setRallyFilter(setting: Bool) {
        self.filterSeriesRally = setting
    }
    
    func setBikesFilter(setting: Bool) {
        self.filterSeriesBikes = setting
    }
    
    func setOtherFilter(setting: Bool) {
        self.filterSeriesOther = setting
    }
    
    func setPracticeFilter(setting: Bool) {
        self.filterSessionPractice = setting
    }
    
    func setQualifyingFilter(setting: Bool) {
        self.filterSessionQualifying = setting
    }
    
    func setRaceFilter(setting: Bool) {
        self.filterSessionRace = setting
    }
    
    func setFilterStartDate(date: Date) {
        self.filterStartDate = date
    }
    
    func setFilterEndDate(date: Date) {
        self.filterEndDate = date
    }
    
    
    
    
//    func getFilterStringSettings() -> [String]{
//        
//        return [self.filterText, self.filterSeriesTypes, self.filterSessionType]
//    }
}

