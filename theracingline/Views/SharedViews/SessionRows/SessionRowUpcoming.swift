//
//  SessionRowUpcoming.swift
//  theracingline-iOS
//
//  Created by Dave on 30/05/2022.
//

import SwiftUI
import SwiftDate


struct SessionRowUpcoming: View {
    
    @ObservedObject var data = DataController.shared
    @Environment(\.colorScheme) var colorScheme
    var currentDate = Date()
    
    var session: Session
    
    var body: some View {
    
        VStack(alignment: .leading, spacing: 5) {
            
            // Series Name
            Text(session.series)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(getTextColor())
                
            // CIRCUIT - SESSION TYPE - LENGTH
            // Silverstone - Race - 63 Laps
            // Cut down row for non-race sessions and non-premium users
            if data.userAccessLevel < 3 || session.sessionType != "R" {
                Text("\(session.circuit) - \(session.sessionName)")
                    .font(.caption)
                    .foregroundColor(Color.secondary)
                
            // If session is day event then don't display session name
            } else if session.durationType == "AD" {
                Text("\(session.circuit) - \(session.getDurationText())")
                    .font(.caption)
                    .foregroundColor(Color.secondary)
                
            } else {
                Text("\(session.circuit) - \(session.sessionName) \(session.getDurationText())")
                    .font(.caption)
                    .foregroundColor(Color.secondary)
            }
            // DAY - DATE - TIME - TIME UNTIL
            HStack{
                // Cut down row for all day events and non-premium users
                if data.userAccessLevel < 3 || session.durationType == "AD" {
                    Text("\(session.day()) \(session.dateAsString())")
                // If session is tba, display TBA
                } else if session.tba {
                        Text("\(session.day()) \(session.dateAsString()) - Time TBA")
                } else {
                    Text("\(session.day()) \(session.dateAsString()) - \(session.timeAsString())")
                }
                Spacer()
                if data.userAccessLevel >= 3 && (session.durationType != "AD" || session.date > currentDate + 6.hours) {
                    Text(session.timeFromNow())
                    Image(systemName: "clock.fill")
                } else if data.userAccessLevel >= 3 && (session.durationType == "AD" || session.date <= currentDate) {
                    Text("All Day Event")
                    Image(systemName: "clock.fill")
                }
                
            } // HStack
            .font(.caption)
            .foregroundColor(Color.secondary)
        } // VSTACK
    }
    
    func getTextColor() -> Color {
        return colorScheme == .dark ? Color.white : Color.black
    }
}

struct SessionRowUpcoming_Previews: PreviewProvider {
    static var previews: some View {
        SessionRowUpcoming(session: testSession1)
    }
}
