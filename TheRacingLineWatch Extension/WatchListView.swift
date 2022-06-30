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
                        if !hasSessionPassed(session: session) {
                            UpcomingRace(session: session)
                        } else {
                            FinishedRace(session: session)
                        }

                    } // FOREACH
                }
            } else {
                Text(noSessionText)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        } // SCROLVIEW
        .navigationBarTitle(Text(navTitle))
    }
    
    func hasSessionPassed(session: Session) -> Bool {
        let currentDateTime = Date()

        if session.date < currentDateTime {
            return true
        } else {
            return false
        }
    }
}

struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WatchListView(sessions: [testSession8, testSession2, testSession3, testSession1, testSession2, testSession3], navTitle: "This Week", noSessionText: "No Sessions today. Check the phone for more information.")
            WatchListView(sessions: [testSession1], navTitle: "This Week", noSessionText: "No Sessions this week. Check the phone for more information.")
        }
    }
}
