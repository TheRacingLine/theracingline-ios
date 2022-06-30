//
//  UpcomingRace.swift
//  TheRacingLineWatch Extension
//
//  Created by Dave on 23/05/2022.
//

import SwiftUI

struct UpcomingRace: View {
    
    var session: Session
    
    var body: some View {
        
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
                        .fontWeight(.bold)
                    Spacer()
                }
                HStack {
                    Text(session.circuit)
                        .font(.caption)
                    Spacer()
                    
                }
                HStack {
                    Text(session.sessionName)
                        .font(.caption)
                    Spacer()
                }
                
                HStack {
                    Text(session.day())
                        .font(.caption)
                    Spacer()
                    
                    // If the sessions are not marked as a user being non-premium
                    if session.accessLevel != -1 {
                        if session.tba {
                            Text("Time TBA")
                        } else if session.durationType != "AD" {
                            Text(session.timeAsString())
                                .font(.caption)
                        } else {
                            Text("All Day")
                                .font(.caption)
                        }
                    }
                    
                }
            } // TEXT VSTACK
        } // ROW HSTACK
        .padding(.vertical, 0)
    }
    
    func istba(session: Session) -> Bool {
        return session.tba
    }
}

struct UpcomingRace_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingRace(session: testSession1)
    }
}
