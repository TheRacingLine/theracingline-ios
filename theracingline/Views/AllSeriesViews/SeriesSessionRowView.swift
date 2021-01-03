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
                    Text("\(session.dateAsString()) - \(session.timeAsString())")
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
    }
}

struct SeriesSessionRowView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesSessionRowView(session: testSession1)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
