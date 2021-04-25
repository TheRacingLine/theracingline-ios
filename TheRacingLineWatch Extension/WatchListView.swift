//
//  WatchListView.swift
//  TheRacingLineWatch Extension
//
//  Created by David Ellis on 03/04/2021.
//

import SwiftUI

struct WatchListView: View {
    
    var sessions: [Session]
    var navTitle: String
    var noSessionText: String

    var body: some View {
        
        
        ScrollView {
            if sessions.count > 0 {
                VStack {
                    ForEach(sessions) { session in
                        let gradientStart = Color(red: session.darkR / 255, green: session.darkG / 255, blue: session.darkB / 255)
                        let gradientEnd = Color(red: session.lightR / 255, green: session.lightG / 255, blue: session.lightB / 255)
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient(
                                      gradient: .init(colors: [gradientStart, gradientEnd]),
                                      startPoint: .init(x: 0.5, y: 0),
                                      endPoint: .init(x: 0.5, y: 0.6)
                                    ))
                                .frame(width: 8)
                            VStack {
                                HStack {
                                    Text(session.series)
//                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(hasSessionPassed(session: session))
                                    Spacer()
                                }
                                HStack {
                                    Text(session.circuit)
                                        .font(.caption)
                                        .foregroundColor(Color.secondary)
                                    Spacer()
                                    Text(session.sessionName)
                                        .font(.caption)
                                        .foregroundColor(Color.secondary)
                                }
                                HStack {
                                    Text(session.day())
                                        .font(.caption)
                                        .foregroundColor(Color.secondary)
                                    Spacer()
                                    Text(session.timeAsString())
                                        .font(.caption)
                                        .foregroundColor(Color.secondary)
                                }
                            }

                        }.padding(.vertical, 0)
                    }
                }
            } else {
                Text(noSessionText)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        } // SCROLVIEW
        .navigationBarTitle(Text(navTitle))
    }
    
    func hasSessionPassed(session: Session) -> Color {
        let currentDateTime = Date()

        if session.date < currentDateTime {
            return Color(red: 1, green: 1, blue: 1, opacity: 0.25)
        } else {
            return Color.white
        }
    }
}

struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WatchListView(sessions: [testSession1, testSession2, testSession3, testSession1, testSession2, testSession3], navTitle: "This Week", noSessionText: "No Sessions today. Check the phone for more information.")
            WatchListView(sessions: [testSession1], navTitle: "This Week", noSessionText: "No Sessions this week. Check the phone for more information.")
        }
    }
}
