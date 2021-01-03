//
//  SeriesSessionListView.swift
//  theracingline
//
//  Created by David Ellis on 13/11/2020.
//

import SwiftUI

struct SeriesSessionListView: View {
    
    var sessions: [Session]
    var noSessionText: String
    
    var body: some View {
        ScrollView {
            VStack {
                if sessions.count == 0 {
                    Text(noSessionText)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.top, 50)
                        .padding(.horizontal, 20)
                } else {
                    ForEach(sessions) { session in
                        SeriesSessionRowView(session: session)
                    } // FOREACH
                } // IFELSE
            } // VSTACK
            .padding(.horizontal, 20)
        } // SCROLL
        .navigationBarTitle(sessions[0].series)
    }
}

struct SeriesSessionListView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesSessionListView(sessions: [testSession1, testSession2, testSession3, testSession4], noSessionText: "No Sessions")
    }
}
