//
//  SessionListView.swift
//  theracingline
//
//  Created by David Ellis on 12/11/2020.
//

import SwiftUI

struct SessionListView: View {
    
    @ObservedObject var data = DataController.shared
    @StateObject var storeManager: StoreManager
    
    var sessions: [Session]
    var noSessionText: String
    
    var body: some View {
        ScrollView {
            VStack {
                if sessions.count == 0{
                    Image(systemName: "xmark.circle.fill").resizable()
                        .frame(width: 50.0, height: 50)
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                        .padding(.bottom, 2)
                    Text(noSessionText)
                        .bold()
                        .multilineTextAlignment(.center)
                } else {
                    ForEach(sessions) { session in
                        if data.userAccessLevel >= session.accessLevel {
                            HStack {
                                SessionRowView(session: session)
                            }.padding(.horizontal, 15)
                        }
                    } // FOREACH
                } // IFELSE
                
                if data.userAccessLevel < 2 {
                    MoreSeriesButton(storeManager: storeManager, buttonText: "More Series")
                } else if data.userAccessLevel < 3 {
                    MoreSeriesButton(storeManager: storeManager, buttonText: "More Details")
                }
            } // VSTACK
        } // SCROLL
    }
}

struct SessionListView_Previews: PreviewProvider {
    static var previews: some View {
        SessionListView(storeManager: StoreManager(), sessions: [], noSessionText: "No Sessions today.")
    }
}
