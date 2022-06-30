//
//  FinishedRace.swift
//  TheRacingLineWatch Extension
//
//  Created by Dave on 23/05/2022.
//

import SwiftUI

struct FinishedRace: View {
    
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
                    Spacer()
                }
                HStack {
                    Text(session.sessionName)
                    Spacer()
                }
                HStack {
                    Text(session.day())
                    Spacer()
                    
                    // If the sessions are not marked as a user being non-premium
                    if session.accessLevel != -1 {
                        if session.tba {
                            Text("Time TBA")
                        } else if session.durationType != "AD" {
                            Text(session.timeAsString())
                        } else {
                            Text("All Day")
                        }
                    }
                }
            } // TEXT VSTACK
            .font(.system(size: 12))
            .foregroundColor(Color(red: 1, green: 1, blue: 1, opacity: 0.25))
        } // ROW HSTACK
        .padding(.vertical, 0)
    }
}

struct FinishedRace_Previews: PreviewProvider {
    static var previews: some View {
        FinishedRace(session: testSession1)
    }
}
