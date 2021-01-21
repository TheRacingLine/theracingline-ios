//
//  theracingline_widget.swift
//  theracingline-widget
//
//  Created by David Ellis on 18/01/2021.
//

import WidgetKit
import SwiftUI

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
        
        
        return SessionEntry(date: Date(), session: placeholderSession, userAccessLevel: 3)
    }

    func getSnapshot(in context: Context, completion: @escaping (SessionEntry) -> ()) {
        
        let todaySessions = DataController.shared.getTodayForWidget()
        let userAccessLevel = DataController.shared.getUserAccessLevelForWidget()
        
        var entry = SessionEntry(date: Date(), session: testSession1, userAccessLevel: userAccessLevel)
        
        print(todaySessions)
        if todaySessions.count > 0 {
            entry = SessionEntry(date: Date(), session: todaySessions[0], userAccessLevel: userAccessLevel)
            print("Session Found")
        }
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SessionEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SessionEntry(date: entryDate, session: testSession1, userAccessLevel: 3)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SessionEntry: TimelineEntry {
    let date: Date
    let session: Session?
    let userAccessLevel: Int
}

struct theracingline_widgetEntryView : View {
    
    var entry: Provider.Entry

    var body: some View {
        
        
        
//        VStack() {
////            if data.todaysSessions.count == 0 {
//                HStack {
//                    Text("TODAY")
//                        .bold()
//                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
//                        .font(.subheadline)
//                    Spacer()
//                    Image(systemName: "\(data.currentDate).square")
//                } // HSTACK Header
//
//            ForEach(data.allSessions) { session in
//
//                let gradientStart = Color(red: session.darkR / 255, green: session.darkG / 255, blue: session.darkB / 255)
//                let gradientEnd = Color(red: session.lightR / 255, green: session.lightG / 255, blue: session.lightB / 255)
//
//                HStack{
//                    Text(session.series)
//                    RoundedRectangle(cornerRadius: 4)
//                        .fill(LinearGradient(
//                              gradient: .init(colors: [gradientStart, gradientEnd]),
//                              startPoint: .init(x: 0.5, y: 0),
//                              endPoint: .init(x: 0.5, y: 0.6)
//                            ))
//                        .frame(width: 8)
//                }
//
//
//            } // FOREACH
//                Spacer()
////            } // IF Statement for todays sessions
//
//
//
//        }.padding()
        
        if entry.session != nil {
            let gradientStart = Color(red: entry.session!.darkR / 255, green: entry.session!.darkG / 255, blue: entry.session!.darkB / 255)
            let gradientEnd = Color(red: entry.session!.lightR / 255, green: entry.session!.lightG / 255, blue: entry.session!.lightB / 255)
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(LinearGradient(
                          gradient: .init(colors: [gradientStart, gradientEnd]),
                          startPoint: .init(x: 0.5, y: 0),
                          endPoint: .init(x: 0.5, y: 0.6)
                        ))
                    .frame(width: 8)
                VStack(alignment: .leading, spacing: 5) {
                    Text(entry.session!.series)
                        .font(.title2)
                        .fontWeight(.bold)
                    if entry.session!.durationType == "L" {
                        if entry.userAccessLevel < 3 {
                            Text("\(entry.session!.circuit) - \(entry.session!.sessionName)")
                                .font(.caption)
                                .foregroundColor(Color.secondary)
                        } else {
                            if entry.session!.duration == 0 {
                                Text("\(entry.session!.circuit) - \(entry.session!.sessionName) - TBA Distance")
                                    .font(.caption)
                                    .foregroundColor(Color.secondary)
                            } else {
                                Text("\(entry.session!.circuit) - \(entry.session!.sessionName) - \(entry.session!.duration) Laps")
                                    .font(.caption)
                                    .foregroundColor(Color.secondary)
                            }
                        }
                    } else {
                        if entry.userAccessLevel < 3 {
                            Text("\(entry.session!.circuit) - \(entry.session!.sessionName)")
                                .font(.caption)
                                .foregroundColor(Color.secondary)
                        } else {
                            if entry.session!.duration == 0 {
                                Text("\(entry.session!.circuit) - \(entry.session!.sessionName) - TBA Distance")
                                    .font(.caption)
                                    .foregroundColor(Color.secondary)
                            } else {
                                Text("\(entry.session!.circuit) - \(entry.session!.sessionName) - \(entry.session!.getDurationText())")
                                    .font(.caption)
                                    .foregroundColor(Color.secondary)
                            }
                        }
                    }

                }
            } // HSTACK
        }
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

struct theracingline_widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), session: testSession1, userAccessLevel: 3))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), session: testSession1, userAccessLevel: 3))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), session: testSession1, userAccessLevel: 3))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), session: testSession2, userAccessLevel: 3))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), session: testSession2, userAccessLevel: 3))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), session: testSession2, userAccessLevel: 3))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), session: nil, userAccessLevel: 3))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), session: nil, userAccessLevel: 3))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            theracingline_widgetEntryView(entry: SessionEntry(date: Date(), session: nil, userAccessLevel: 3))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        
    }
}
