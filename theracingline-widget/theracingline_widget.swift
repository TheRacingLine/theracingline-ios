//
//  theracingline_widget.swift
//  theracingline-widget
//
//  Created by David Ellis on 18/01/2021.
//

import WidgetKit
import SwiftUI
import Foundation
import SwiftDate

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SessionEntry {
        
        let placeholderSession = Session()
        placeholderSession.series = "Loading..."
        placeholderSession.accessLevel = 0
        placeholderSession.darkR = 42.0
        placeholderSession.darkG = 148.0
        placeholderSession.darkB = 172.0
        placeholderSession.lightR = 0.0
        placeholderSession.lightG = 180.0
        placeholderSession.lightB = 219.0
        placeholderSession.seriesType = "Single Seater"
        placeholderSession.event = 0
        placeholderSession.circuit = "TBA"
        placeholderSession.sessionName = "TBA"
        placeholderSession.sessionType = "R"
        placeholderSession.roundNumber = 0
        placeholderSession.durationType = "L"
        placeholderSession.duration = 0
        
        
        return SessionEntry(date: Date(), sessions: [placeholderSession], userAccessLevel: 3)
    }
    
    // SNAPSHOT FOR THE TEMPORARY IMAGE WHEN SELECTING A WIDGET

    func getSnapshot(in context: Context, completion: @escaping (SessionEntry) -> ()) {
        
        let thisWeekSessions = DataController.shared.getRacesForWidget()
        let userAccessLevel = DataController.shared.getUserAccessLevelForWidget()
        
        let temporaryAccessLevel = 3
        var entry = SessionEntry(date: Date(), sessions: [testSession1, testSession2, testSession3, testSession4, testSession5, testSession6, testSession7], userAccessLevel: temporaryAccessLevel)
        
        if thisWeekSessions.count > 0 {
            entry = SessionEntry(date: Date(), sessions: thisWeekSessions, userAccessLevel: userAccessLevel)
        }
        
        completion(entry)
    }
    
    // TIMELINE PROVIDED TO THE LIVE WIDGET

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SessionEntry] = []
        let today = Date()
        let startOfToday = Calendar.current.date(bySettingHour: 0, minute: 0, second: 1, of: today)!
        var fifteenMinutes = Date() + 15.minutes
        
        // get all the details needed from User Defaults
        let thisWeekSessions = DataController.shared.getRacesForWidget()
        let userAccessLevel = DataController.shared.getUserAccessLevelForWidget()
        let visibleSeriesList = DataController.shared.getVisibleSeriesPreferencesForWidget()
        
        // filter by user subscription level
        let seriesAllowedBySubscription = thisWeekSessions.filter { $0.accessLevel <= userAccessLevel }
        
        // filter by visible races
        let visibleSeries = seriesAllowedBySubscription.filter { visibleSeriesList.contains($0.series) }
        
        // filter by series that have not happened yet, but let all day events through
        let seriesToGo = visibleSeries.filter { $0.date >= today || $0.date >= startOfToday && $0.durationType == "AD"}
        
        // cut this array down to
        let sessionsArray = Array(seriesToGo.prefix(100))
        
        // for each of the mini arrays in the main array
//        for index in 0 ..< sessionsArray.count {
//
//            var sessionDate = Date()
//            var entry: SessionEntry
//
//
//            // DATE OF ENTRY
//            if index == 0 {
//                // for first race use current date
//                sessionDate = Date()
//
//                // for first race use all
//                entry = SessionEntry(date: sessionDate, sessions: sessionsArray, userAccessLevel: userAccessLevel)
//
//            } else {
//                // for second race, use the first race start time + 1 hour
//                sessionDate = sessionsArray[index-1].date
////                sessionDate = sessionDate + 1.hours
//
//                // for second race take off the first
//                let numberOfRacesToDrop = index
//                let numberOfRaces = sessionsArray.count
//                let slicedArray = Array(sessionsArray.suffix(numberOfRaces - numberOfRacesToDrop))
//
//
//                entry = SessionEntry(date: sessionDate, sessions: slicedArray, userAccessLevel: userAccessLevel)
//            }
//
//            entries.append(entry)
//        }
        
        let entry: SessionEntry
        
        if sessionsArray.count != 0 {
            entry = SessionEntry(date: today, sessions: sessionsArray, userAccessLevel: userAccessLevel)
        } else {
            entry = SessionEntry(date: today, sessions: [noSessions], userAccessLevel: userAccessLevel)
            fifteenMinutes = Date() + 1.minutes
        }
        
        entries.append(entry)
        
        
        // get midnight tomorrow for a refresh
//        let calendar = Calendar.current
//
//        let tomorrow = today + 1.days
//        let tomorrowDay = calendar.component(.day, from: tomorrow)
//        let tomorrowMonth = calendar.component(.month, from: tomorrow)
//        let tomorrowYear = calendar.component(.year, from: tomorrow)
//
//        let dateComponents = DateComponents(calendar: calendar, year: tomorrowYear, month: tomorrowMonth, day: tomorrowDay)
//
//        let tomorrowMidnight = calendar.date(from: dateComponents)!
//        let oneMinuteAway = Date() + 1.minutes
//        let updateTime: Date
//
//        if entries.count == 0 {
//            let entry = SessionEntry(date: Date(), sessions: [noSessions], userAccessLevel: userAccessLevel)
//            entries.append(entry)
//            updateTime = oneMinuteAway
//        } else {
//            updateTime = tomorrowMidnight
//        }

        let timeline = Timeline(entries: entries, policy: .after(fifteenMinutes))
        completion(timeline)
    }
}

struct SessionEntry: TimelineEntry {
    let date: Date
    let sessions: [Session]
    let userAccessLevel: Int
}

struct theracingline_widgetEntryView : View {
    
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry

    
    var body: some View {
            
        // get maximum visible for the specific widget size
        let maxValues = getMaxVisible()
        let maxVisible = maxValues[0]
        let maxDots = maxValues[1]
        
        VStack {
            // if user has a sub, display widget data
            if entry.userAccessLevel >= 3 {
                VStack() {
                
                HStack {
                    if entry.sessions[0].sessionName == "NoSessions" || !checkIfAllRacesAreThisToday(sessions: entry.sessions){
                        Text("THIS WEEK")
                            .bold()
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        Spacer()
                        Image(systemName: "calendar")
                    } else {
                        Text("TODAY")
                            .bold()
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        Spacer()
                        Image(systemName: "\(currentDate).square")
                    }
                } //HSTACK
                .font(.subheadline)
                .padding(.bottom, -2)

                // if there are races
                if entry.sessions[0].sessionName != "NoSessions" {
                    
                    // the list of races
                    ForEach(Array(entry.sessions.enumerated()), id: \.1) { i, element in
                        if i < maxVisible {
                            let gradientStart = Color(red: element.darkR / 255, green: element.darkG / 255, blue: element.darkB / 255)
                            let gradientEnd = Color(red: element.lightR / 255, green: element.lightG / 255, blue: element.lightB / 255)

                            HStack{
                                // Colour pill
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(LinearGradient(
                                          gradient: .init(colors: [gradientStart, gradientEnd]),
                                          startPoint: .init(x: 0.5, y: 0),
                                          endPoint: .init(x: 0.5, y: 0.6)
                                        ))
                                    .frame(width: 8)
                                VStack {
                                    HStack{
                                        Text("\(element.series) - \(element.sessionName)")
                                            .font(.system(size: 10))
//                                        if widgetFamily == .systemSmall {
//                                            if element.sessionType == "R" {
//                                                Text("\(element.series) - R")
//                                                    .font(.system(size: 10))
//                                            } else if element.sessionType == "Q"{
//                                                Text("\(element.series) - Q")
//                                                    .font(.system(size: 10))
//                                            } else if element.sessionType == "P"{
//                                                Text("\(element.series) - P")
//                                                    .font(.system(size: 10))
//                                            } else {
//                                                Text("\(element.series)")
//                                                    .font(.system(size: 10))
//                                            }
//                                        } else {
//                                            if element.sessionType == "R" {
//                                                Text("\(element.series) - Race")
//                                                    .font(.system(size: 10))
//                                            } else if element.sessionType == "Q"{
//                                                Text("\(element.series) - Qualifying")
//                                                    .font(.system(size: 10))
//                                            } else if element.sessionType == "P"{
//                                                Text("\(element.series) - Practice")
//                                                    .font(.system(size: 10))
//                                            } else {
//                                                Text("\(element.series)")
//                                                    .font(.system(size: 10))
//                                            }
//                                        }
     
                                        Spacer()
                                        if entry.userAccessLevel >= 3 {
                                            if widgetFamily != .systemSmall {
                                                if(element.tba){
                                                    Text("Time TBA")
                                                        .font(.system(size: 10))
                                                } else if element.durationType == "AD" {
                                                    Text("All Day Event")
                                                        .font(.system(size: 10))
                                                } else {
                                                    Text(element.timeAsString())
                                                        .font(.system(size: 10))
                                                }
                                            }
                                        }
                                    }
                                    HStack{
                                        Text(element.circuit)
                                            .font(.system(size: 10))
                                        Spacer()
                                        if entry.userAccessLevel >= 3 {
                                            if widgetFamily != .systemSmall {
                                                Text("\(element.day()) - \(element.dateAsString())")
                                                    .font(.system(size: 10))
                                            }
                                        }
                                    } // HSTACK
                                } // VSTACK
                                .font(.caption2)
                            } //HSTACK
                            .frame(height: 20)
                        } // IF STATEMENT
                    } // FOREACH FOR LIST
                    
                    // the dots for races
                    // if there are more races than can be displayed on the widget
                    dotsRow(sessions: entry.sessions, maxVisible: maxVisible, maxDots: maxDots)

                    
                    Spacer()
                } else {
                    // display no coming soon events
                    widgetNoRaces()
                }
               
            } //VSTACK
                .padding()
            } else {
                VStack {
                    // if no sub, display error
                    widgetNoSub()
                } // VSTACK
                .padding()
            }
        }
    }
    
    var currentDate: String {
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "dd"
        
        let day = nameFormatter.string(from: currentDate)
        return day
    }
    
    func getMaxVisible() -> [Int] {
        
        
        // get device size

        switch widgetFamily {
            case .systemSmall:
                switch UIScreen.main.bounds.size {
                    // iPhones
                    case CGSize(width: 390, height: 844): // 12, 12 Pro, 13, 13 Pro
                        return [3,9]
                    case CGSize(width: 360, height: 780): // 12 Mini, 13 Mini
                        return [3,9]
                    case CGSize(width: 428, height: 926): // 12 Pro Max, 13 Pro Max
                        return [3,10]
                    case CGSize(width: 414, height: 896): // 11 Pro Max, 11, XR,
                        return [3,9]
                    case CGSize(width: 375, height: 812): // 11 Pro, XS, X, 12 mini
                        return [3,9]
                    case CGSize(width: 414, height: 736): // 8 Plus, 7 Plus, 6S Plus
                        return [3,9]
                    case CGSize(width: 375, height: 667): // SE2, 8, 7, 6S
                        return [3,8]
                    case CGSize(width: 320, height: 568): // SE
                        return [3,8]
                    // iPads
                    case CGSize(width: 810, height: 1080): // iPad
                        return [3,8]
                    case CGSize(width: 768, height: 1024): // iPad Pro 9.7
                        return [3,8]
                    case CGSize(width: 744, height: 1133): // iPad Mini 6
                        return [3,8]
                    case CGSize(width: 1024, height: 1366): // iPad Pro 12.9
                        return [4,11]
                    case CGSize(width: 834, height: 1194): // iPad Pro 11
                        return [3,8]
                    case CGSize(width: 820, height: 1180): // iPad Air 4
                        return [3,8]
                    case CGSize(width: 820, height: 1112): // iPad Air 3
                        return [3,8]
                    default:
                        return [3,8]
                }
            case .systemMedium:
                switch UIScreen.main.bounds.size {
                    // iPhones
                    case CGSize(width: 390, height: 844): // 12, 12 Pro
                        return [3,20]
                    case CGSize(width: 360, height: 780): // 12 Mini
                        return [3,20]
                    case CGSize(width: 428, height: 926): // 12 Pro Max
                        return [3,20]
                    case CGSize(width: 414, height: 896): // 11 Pro Max, 11, XR,
                        return [3,20]
                    case CGSize(width: 375, height: 812): // 11 Pro, XS, X, 12 mini
                        return [3,20]
                    case CGSize(width: 414, height: 736): // 8 Plus, 7 Plus, 6S Plus
                        return [3,20]
                    case CGSize(width: 375, height: 667): // SE2, 8, 7, 6S
                        return [3,19]
                    case CGSize(width: 320, height: 568): // SE
                        return [3,17]
                    // iPads
                    case CGSize(width: 810, height: 1080): // iPad
                        return [3,20]
                    case CGSize(width: 768, height: 1024): // iPad Pro 9.7
                        return [3,20]
                    case CGSize(width: 744, height: 1133): // iPad Mini 6
                        return [3,20]
                    case CGSize(width: 1024, height: 1366): // iPad Pro 5 12.9
                        return [4,20]
                    case CGSize(width: 834, height: 1194): // iPad Pro 5 11
                        return [3,20]
                    case CGSize(width: 820, height: 1180): // iPad Air 4
                        return [3,20]
                    case CGSize(width: 820, height: 1112): // iPad Air 3
                        return [3,20]
                    default:
                        return [3,20]
                }
            case .systemLarge:
                switch UIScreen.main.bounds.size {
                    // iPhones
                    case CGSize(width: 390, height: 844): // 12, 12 Pro
                        return [10,25]
                    case CGSize(width: 360, height: 780): // 12 Mini
                        return [9,20]
                    case CGSize(width: 428, height: 926): // 12 Pro Max
                        return [11,25]
                    case CGSize(width: 414, height: 896): // 11 Pro Max, 11, XR,
                        return [11,25]
                    case CGSize(width: 375, height: 812): // 11 Pro, XS, X, 12 mini
                        return [10,25]
                    case CGSize(width: 414, height: 736): // 8 Plus, 7 Plus, 6S Plus
                        return [10,25]
                    case CGSize(width: 375, height: 667): // SE2, 8, 7, 6S
                        return [9,23]
                    case CGSize(width: 320, height: 568): // SE
                        return [9,23]
                    // iPads
                    case CGSize(width: 810, height: 1080): // iPad
                        return [9,25]
                    case CGSize(width: 768, height: 1024): // iPad Pro 9.7
                        return [9,25]
                    case CGSize(width: 744, height: 1133): // iPad Mini 6
                        return [9,25]
                    case CGSize(width: 1024, height: 1366): // iPad Pro 5 12.9
                        return [10,25]
                    case CGSize(width: 834, height: 1194): // iPad Pro 5 11
                        return [10,25]
                    case CGSize(width: 820, height: 1180): // iPad Air 4
                        return [10,25]
                    case CGSize(width: 820, height: 1112): // iPad Air 3
                        return [10,25]
                    default:
                        return [9,20]
                }

            case .systemExtraLarge:
                switch UIScreen.main.bounds.size {
                    // iPads
                    case CGSize(width: 810, height: 1080): // iPad
                        return [9,25]
                    case CGSize(width: 768, height: 1024): // iPad Pro 9.7
                        return [9,25]
                    case CGSize(width: 744, height: 1133): // iPad Mini 6
                        return [9,25]
                    case CGSize(width: 1024, height: 1366): // iPad Pro 5 12.9
                        return [11,25]
                    case CGSize(width: 834, height: 1194): // iPad Pro 5 11
                        return [10,25]
                    case CGSize(width: 820, height: 1180): // iPad Air 4
                        return [10,25]
                    case CGSize(width: 820, height: 1112): // iPad Air 3
                        return [9,25]
                    default:
                        return [9,25]
                }

        @unknown default:
            return [3,9]
        }
    }
    
    func printTest(text: String){
        print(text)
    }
}

@main
struct theracingline_widget: Widget {
    let kind: String = "theracingline_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            theracingline_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("This Weeks Events")
        .description("List of this weeks events")
    }
}

//struct theracingline_widget_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), sessions: testSession1, userAccessLevel: 3))
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
//            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), sessions: testSession1, userAccessLevel: 3))
//                .previewContext(WidgetPreviewContext(family: .systemMedium))
//            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), sessions: testSession1, userAccessLevel: 3))
//                .previewContext(WidgetPreviewContext(family: .systemLarge))
//
//            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), sessions: testSession2, userAccessLevel: 3))
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
//            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), sessions: testSession2, userAccessLevel: 3))
//                .previewContext(WidgetPreviewContext(family: .systemMedium))
//            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), sessions: testSession2, userAccessLevel: 3))
//                .previewContext(WidgetPreviewContext(family: .systemLarge))
//
//            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), sessions: testSession3, userAccessLevel: 3))
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
//            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), sessions: testSession3, userAccessLevel: 3))
//                .previewContext(WidgetPreviewContext(family: .systemMedium))
//            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), sessions: testSession3, userAccessLevel: 3))
//                .previewContext(WidgetPreviewContext(family: .systemLarge))
//        }
//
//    }
//}

func currentDate() -> String {
    let currentDate = Date()
    let nameFormatter = DateFormatter()
    nameFormatter.dateFormat = "dd"
    
    let day = nameFormatter.string(from: currentDate)
    return day
}

func checkIfAllRacesAreThisToday(sessions: [Session]) -> Bool {
    
    var allSessionsToday = true
    
    for session in sessions {
        if !session.date.isToday {
            allSessionsToday = false
        }
    }
    
    return allSessionsToday
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
//         let deviceType = UIDevice.current.modelName
//         switch deviceType {
//            case "iPhone SE", "iPod Touch 7":
//                // get widget size
//                switch widgetFamily {
//                    case .systemSmall:
//                        return [3,8]
//                    case .systemMedium:
//                        return [3,17]
//                    case .systemLarge:
//                        return [9,23]
//                    default:
//                        return [3,8]
//                }
//            case "iPhone 6s", "iPhone 7", "iPhone 8", "iPhone SE2":
//                // get widget size
//                switch widgetFamily {
//                    case .systemSmall:
//                        return [3,9]
//                    case .systemMedium:
//                        return [3,20]
//                    case .systemLarge:
//                        return [10,25]
//                    default:
//                        return [3,8]
//                }
//            case "iPhone 6s Plus", "iPhone 7 Plus", "iPhone 8 Plus":
//                // get widget size
//                switch widgetFamily {
//                    case .systemSmall:
//                        return [3,9]
//                    case .systemMedium:
//                        return [3,20]
//                    case .systemLarge:
//                        return [10,25]
//                    default:
//                        return [3,8]
//                }
//            case "iPhone X", "iPhone XS", "iPhone 11 Pro", "iPhone 12 Mini", "iPhone 13 Mini":
//                // get widget size
//                switch widgetFamily {
//                    case .systemSmall:
//                        return [3,9]
//                    case .systemMedium:
//                        return [3,20]
//                    case .systemLarge:
//                        return [10,25]
//                    default:
//                        return [3,8]
//                }
//            case "iPhone XS Max", "iPhone 11 Pro Max", "iPhone 11", "iPhone XR":
//                // get widget size
//                switch widgetFamily {
//                    case .systemSmall:
//                        return [3,9]
//                    case .systemMedium:
//                        return [3,20]
//                    case .systemLarge:
//                        return [11,25]
//                    default:
//                        return [3,8]
//                }
//            case "iPhone 12 Pro Max", "iPhone 13 Pro Max":
//                // get widget size
//                switch widgetFamily {
//                    case .systemSmall:
//                        return [3,9]
//                    case .systemMedium:
//                        return [3,20]
//                    case .systemLarge:
//                        return [11,25]
//                    default:
//                        return [3,8]
//                }
//            case "iPhone 12", "iPhone 12 Pro", "iPhone 13", "iPhone 13 Pro":
//                // get widget size
//                switch widgetFamily {
//                    case .systemSmall:
//                        return [3,9]
//                    case .systemMedium:
//                        return [3,20]
//                    case .systemLarge:
//                        return [11,25]
//                    default:
//                        return [3,8]
//                }
//
//            case "iPad 5", "iPad 6", "iPad 7", "iPad 8", "iPad 9", "iPad Air 2", "iPad Air 3", "iPad Air 4", "iPad Mini 4", "iPad Mini 5", "iPad Mini 6", "iPad Pro 9.7", "iPad Pro 12.9", "iPad Pro 10.5", "iPad Pro 12.9 2", "iPad Pro 11", "iPad Pro 12.9 3", "iPad Pro 11 2", "iPad Pro 12.9 4", "iPad Pro 11 3", "iPad Pro 12.9 5":
//
//                // get widget size
//                switch widgetFamily {
//                    case .systemSmall:
//                        return [3,9]
//                    case .systemMedium:
//                        return [3,20]
//                    case .systemLarge:
//                        return [11,25]
//                    case .systemExtraLarge:
//                        return [11,25]
//                    default:
//                        return [3,8]
//                }
//            default:
//                return [3,9]
//        }

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPod9,1":                                 return "iPod Touch 7"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,6":                              return "iPhone XS Max"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE2"
        case "iPhone13,1":                              return "iPhone 12 Mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
        case "iPhone14,4":                              return "iPhone 13 Mini"
        case "iPhone14,5":                              return "iPhone 13"
        case "iPhone14,2":                              return "iPhone 13 Pro"
        case "iPhone14,3":                              return "iPhone 13 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad7,11", "iPad7,12":                    return "iPad 7"
        case "iPad11,6", "iPad11,7":                    return "iPad 8"
        case "iPad12,1", "iPad12,2":                    return "iPad 9"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad11,3", "iPad11,4":                    return "iPad Air 3"
        case "iPad13,1", "iPad13,2":                    return "iPad Air 4"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
        case "iPad14,1", "iPad14,2":                    return "iPad Mini 6"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 2"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro 11"
        case "iPad8,5", "iPad8,6","iPad8,7", "iPad8,8": return "iPad Pro 12.9 3"
        case "iPad8,9", "iPad8,10":                     return "iPad Pro 11 2"
        case "iPad8,11", "iPad8,12":                    return "iPad Pro 12.9 4"
        case "iPad8,13,4", "iPad13,5","iPad8,13,6", "iPad13,7": return "iPad Pro 11 3"
        case "iPad13,8", "iPad13,9","iPad13,10", "iPad13,11":   return "iPad Pro 12.9 5"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
