//
//  SessionRowFinished.swift
//  theracingline-iOS
//
//  Created by Dave on 30/05/2022.
//

import SwiftUI

struct SessionRowFinished: View {
    
    @ObservedObject var data = DataController.shared
    @Environment(\.colorScheme) var colorScheme

    var session: Session
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            // Series Name
            Text(session.series)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(getTextColor())
            
            // CIRCUIT - SESSION TYPE - RACE LENGTH -//- TIME SINCE START
            // Silverstone - Race - 63 Laps -//- 3 days ago
            HStack {
                // Cut down row for non-race sessions and non-premium users
                if data.userAccessLevel < 3 || session.sessionType != "R" {
                    Text("\(session.circuit) - \(session.sessionName)")
                        .font(.caption2)
                        .foregroundColor(Color.secondary)
                } else if session.durationType == "AD" {
                    Text("\(session.circuit) - \(session.getDurationText())")
                        .font(.caption2)
                        .foregroundColor(Color.secondary)
                } else {
                    Text("\(session.circuit) - \(session.sessionName) \(session.getDurationText())")
                        .font(.caption2)
                        .foregroundColor(Color.secondary)
                }
                
                Spacer()
                
                // if session is All day, then don't display time since started
                if session.durationType == "AD" {
                    Text("All Day Event")
                        .font(.caption2)
                        .foregroundColor(Color.secondary)
                } else {
                    Text(session.timeFromNow())
                        .font(.caption2)
                        .foregroundColor(Color.secondary)
                }
                Image(systemName: "clock.fill")
                    .font(.caption2)
                    .foregroundColor(Color.secondary)
            }
        }
    }
    
    func getTextColor() -> Color {
        return colorScheme == .dark ? Color(red: 1, green: 1, blue: 1, opacity: 0.25) : Color(red: 0, green: 0, blue: 0, opacity: 0.25)
    }
}

struct SessionRowFinished_Previews: PreviewProvider {
    static var previews: some View {
        SessionRowFinished(session: testSession1)
    }
}
