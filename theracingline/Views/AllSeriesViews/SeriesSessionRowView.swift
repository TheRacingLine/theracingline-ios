//
//  SeriesSessionRowView.swift
//  theracingline
//
//  Created by David Ellis on 13/11/2020.
//

import SwiftUI

struct SeriesSessionRowView: View {
    
    @ObservedObject var data = DataController.shared

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
            VStack(alignment: .leading, spacing: 5) {
                Text(session.circuit)
                    .font(.title2)
                    .fontWeight(.bold)
                if(session.durationType == "L") {
                    if data.userAccessLevel < 3 {
                        Text("\(session.sessionName)")
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                    } else {
                        Text("\(session.sessionName) - \(session.duration) Laps")
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                    }
                } else {
                    if data.userAccessLevel < 3 {
                        Text("\(session.circuit) - \(session.sessionName)")
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                    } else {
                        Text("\(session.sessionName) - \(session.getDurationText())")
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                    }
                }
                HStack{
                    if data.userAccessLevel < 3 {
                        Text("\(session.dateAsString())")
                    } else {
                        if session.tba {
                            Text("\(session.dateAsString()) - Start Time TBA")
                        } else {
                            Text("\(session.dateAsString()) - \(session.timeAsString())")
                        }
                    }
                    Spacer()
                    if data.userAccessLevel > 2 {
                        Text(session.timeFromNow())
                        Image(systemName: "clock.fill")
                    }
                } // HStack
                .font(.caption)
                .foregroundColor(Color.secondary)
            } // VSTACK
            .padding(.bottom, 4)
        } // HSTACK
    }
}

struct SeriesSessionRowView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesSessionRowView(session: testSession1)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
