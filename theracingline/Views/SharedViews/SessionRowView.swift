//
//  SessionRowView.swift
//  theracingline
//
//  Created by David Ellis on 12/11/2020.
//

import SwiftUI
import SwiftDate

struct SessionRowView: View {
    
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
            
            // IF SESSION HAS PASSED COMPRESS ROW
            if session.hasPassed() {
                SessionRowFinished(session: session)
            } else {
                SessionRowUpcoming(session: session)
            }
        }//HSTACK
        .padding(.bottom, 4)
    }
    
    func hasSessionPassedBool(session: Session) -> Bool {
        let currentDateTime = Date()

        if session.date < currentDateTime {
            return true
        } else {
            return false
        }
    }
    
    func isSessionMoreThanDayOld(session: Session) -> Bool {
        let tweleveHoursAgo = Date() - 12.hours
        
        if session.date < tweleveHoursAgo {
            return true
        } else {
            return false
        }
    }
}

struct SessionRowView_Previews: PreviewProvider {
    static var previews: some View {
        SessionRowView(session: testSession8)
            .previewLayout(.sizeThatFits)
            .padding()
            .frame(height: 100)
        SessionRowView(session: testSession2)
            .previewLayout(.sizeThatFits)
            .padding()
            .frame(height: 100)
        SessionRowView(session: testSession1)
            .previewLayout(.sizeThatFits)
            .padding()
            .frame(height: 100)
        SessionRowView(session: testSession9)
            .previewLayout(.sizeThatFits)
            .padding()
            .frame(height: 100)
    }
    
    
}
