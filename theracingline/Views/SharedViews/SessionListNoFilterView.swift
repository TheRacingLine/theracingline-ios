//
//  SessionListNoFilterView.swift
//  theracingline-iOS
//
//  Created by Dave on 01/04/2022.
//

import SwiftUI
import SwiftDate

struct SessionListNoFilterView: View {
    @ObservedObject var data = DataController.shared
    @StateObject var storeManager: StoreManager
    
    var sessions: [Session]
    var noSessionText: String
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if sessions.count == 0{
                    HStack {
                        Spacer()
                        Text("😔")
                            .font(.title)
                            .padding(.top)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text(noSessionText)
                            .bold()
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    ForEach(sessions) { session in
                        if data.userAccessLevel >= session.accessLevel {
                            HStack {
                                SessionRowView(session: session)
                            }.padding(.horizontal, 15)
                        }
                    } // FOREACH
                } // IFELSE
                
                if data.userAccessLevel < 3 {
                    MoreSeriesButton(storeManager: storeManager, buttonText: "More Details")
                }
            } // VSTACK
//            .navigationBarTitle(Text("Search"))
            .resignKeyboardOnDragGesture()
            .padding(.top, 8)
        } // SCROLL
    }
}

struct SessionListNoFilterView_Previews: PreviewProvider {
    static var previews: some View {
        SessionListView(storeManager: StoreManager(), sessions: [], noSessionText: "No Sessions today.")
    }
}
