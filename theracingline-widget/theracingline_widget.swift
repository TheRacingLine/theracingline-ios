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
        
        var entry = SessionEntry(date: Date(), sessions: [testSession1], userAccessLevel: userAccessLevel)
        
        if thisWeekSessions.count > 0 {
            entry = SessionEntry(date: Date(), sessions: thisWeekSessions, userAccessLevel: userAccessLevel)
        }
        
        completion(entry)
    }
    
    // TIMELINE PROVIDED TO THE LIVE WIDGET

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SessionEntry] = []
        
        // get all the details needed from User Defaults
        
        let thisWeekSessions = DataController.shared.getRacesForWidget()
        let userAccessLevel = DataController.shared.getUserAccessLevelForWidget()
        let visibleSeriesList = DataController.shared.getVisibleSeriesPreferencesForWidget()
        
        // filter by user subscription level
        let seriesAllowedBySubscription = thisWeekSessions.filter { $0.accessLevel <= userAccessLevel }
        
        // filter by visible races
        let visibleSeries = seriesAllowedBySubscription.filter { visibleSeriesList.contains($0.series) }
        
        // cut this array down to
        let sessionsArray = Array(visibleSeries.prefix(100))
        
        // for each of the mini arrays in the main array
        for index in 0 ..< sessionsArray.count {
            
            var currentDate = Date()
            
            // DATE OF ENTRY
            if index == 0 {
                // for first race use current date
                currentDate = Date()
            } else {
                // for second race, use the first race start time + 1 hour
                currentDate = sessionsArray[index].date
            }
            
            // SESSIONS OF ENTRY

            var entry: SessionEntry
            if index == 0 {
                // for first race use all
                entry = SessionEntry(date: currentDate, sessions: sessionsArray, userAccessLevel: userAccessLevel)
            } else {
                // for second race take off the first
                let numberOfRacesToDrop = index
                let numberOfRaces = sessionsArray.count
                let slicedArray = Array(sessionsArray.suffix(numberOfRaces - numberOfRacesToDrop))
                
                entry = SessionEntry(date: currentDate, sessions: slicedArray, userAccessLevel: userAccessLevel)
            }
            
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
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
        let maxVisible = getMaxVisible()
        
        VStack() {
            HStack {
                if checkIfAllRacesAreThisToday(sessions: entry.sessions) {
                    Text("TODAY")
                        .bold()
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Image(systemName: "\(currentDate).square")

                } else {
                    Text("THIS WEEK")
                        .bold()
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Image(systemName: "calendar")

                }
            } //HSTACK
            .font(.subheadline)
            .padding(.bottom, -2)

            // if there are races
            if entry.sessions.count > 0 {
                
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
                                    Text(element.series)
                                        .font(.system(size: 10))
                                    Spacer()
//                                    if entry.userAccessLevel >= 3 {
                                        if widgetFamily != .systemSmall {
                                            Text(element.timeAsString())
                                                .font(.system(size: 10))
                                        }
//                                    }
                                }
                                HStack{
                                    Text(element.circuit)
                                        .font(.system(size: 10))
                                    Spacer()
//                                    if entry.userAccessLevel >= 3 {
                                        if widgetFamily != .systemSmall {
                                            Text("\(element.day()) - \(element.dateAsString())")
                                                .font(.system(size: 10))
//                                        }
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
                if entry.sessions.count > maxVisible {
                    
                    // number of additional races to be displayed in the dots
                    let count = entry.sessions.count - maxVisible
                    
                    HStack {
                        Text("+\(count)")
                            .font(.system(size: 10))
                        
                        // for each race that could not be displayed in full
                        
                        
                        
                        ForEach(Array(entry.sessions.enumerated()), id: \.1) { i, element in
                            
                            // set
                            if i >= maxVisible {
                                if ((i < 9 && widgetFamily == .systemSmall) || (i < 15 && widgetFamily != .systemSmall)) {
                                    let gradientStart = Color(red: element.darkR / 255, green: element.darkG / 255, blue: element.darkB / 255)
                                    let gradientEnd = Color(red: element.lightR / 255, green: element.lightG / 255, blue: element.lightB / 255)
                                    Circle()
                                        .fill(LinearGradient(
                                              gradient: .init(colors: [gradientStart, gradientEnd]),
                                              startPoint: .init(x: 0.5, y: 0),
                                              endPoint: .init(x: 0.5, y: 0.6)
                                            ))
                                        .frame(width: 8, height: 8)
                                }
                            }
                        } // FOREACH FOR LIST
                        Spacer()
                    } // HSTACK
                } // DOTS
                Spacer()
            } else {
                // display no coming soon events
                Text("No Races Soon")
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
    
    func getMaxVisible() -> Int {
            
        switch widgetFamily {
            case .systemSmall:
                return 3
            case .systemMedium:
                return 3
            case .systemLarge:
                return 10
        @unknown default:
            return 3
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
        .configurationDisplayName("The Racing Line Widhet")
        .description("See upcoming events!")
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
