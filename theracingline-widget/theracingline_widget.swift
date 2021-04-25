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
        var fifteenMinutes = Date() + 15.minutes
        
        // get all the details needed from User Defaults
        let thisWeekSessions = DataController.shared.getRacesForWidget()
        let userAccessLevel = DataController.shared.getUserAccessLevelForWidget()
        let visibleSeriesList = DataController.shared.getVisibleSeriesPreferencesForWidget()
        
        // filter by user subscription level
        let seriesAllowedBySubscription = thisWeekSessions.filter { $0.accessLevel <= userAccessLevel }
        
        // filter by visible races
        let visibleSeries = seriesAllowedBySubscription.filter { visibleSeriesList.contains($0.series) }
        
        // filter by series that have not happened yet.
        let seriesToGo = visibleSeries.filter { $0.date >= today }
        
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
                                    if widgetFamily == .systemSmall {
                                        if element.sessionType == "R" {
                                            Text("\(element.series) - R")
                                                .font(.system(size: 10))
                                        } else if element.sessionType == "Q"{
                                            Text("\(element.series) - Q")
                                                .font(.system(size: 10))
                                        } else {
                                            Text("\(element.series)")
                                                .font(.system(size: 10))
                                        }
                                    } else {
                                        if element.sessionType == "R" {
                                            Text("\(element.series) - Race")
                                                .font(.system(size: 10))
                                        } else if element.sessionType == "Q"{
                                            Text("\(element.series) - Qualifying")
                                                .font(.system(size: 10))
                                        } else {
                                            Text("\(element.series)")
                                                .font(.system(size: 10))
                                        }
                                    }
 
                                    Spacer()
                                    if entry.userAccessLevel >= 3 {
                                        if widgetFamily != .systemSmall {
                                            if(element.tba){
                                                Text("Time TBA")
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
    }
    
    var currentDate: String {
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "dd"
        
        let day = nameFormatter.string(from: currentDate)
        return day
    }
    
    func getMaxVisible() -> [Int] {
            
        switch widgetFamily {
            case .systemSmall:
                switch UIScreen.main.bounds.size {
                    case CGSize(width: 390, height: 844): // 12, 12 Pro
                        return [3,9]
//                    case CGSize(width: 360, height: 780): // 12 Mini
//                        return [3,9]
                    case CGSize(width: 428, height: 926): // 12 Pro Max
                        return [3,9]
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
                    default:
                        return [3,8]
                }
            case .systemMedium:
                switch UIScreen.main.bounds.size {
                    case CGSize(width: 390, height: 844): // 12, 12 Pro
                        return [3,20]
//                    case CGSize(width: 360, height: 780): // 12 Mini
//                        return [3,20]
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
                    default:
                        return [3,17]
                }
            case .systemLarge:
                switch UIScreen.main.bounds.size {
                    case CGSize(width: 390, height: 844): // 12, 12 Pro
                        return [10,25]
//                    case CGSize(width: 360, height: 780): // 12 Mini
//                        return [9,20]
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
                    default:
                        return [10,20]
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


