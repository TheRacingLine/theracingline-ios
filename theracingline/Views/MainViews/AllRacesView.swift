//
//  AllRacesView.swift
//  theracingline
//
//  Created by David Ellis on 12/11/2020.
//

import SwiftUI

struct AllRacesView: View {
    
    @ObservedObject var data = DataController.shared
    @StateObject var storeManager: StoreManager

    var body: some View {
        SessionListView(storeManager: storeManager, sessions: data.allSessions, noSessionText: "No Sessions")
            .navigationTitle("All Races")
    }
}

struct AllRacesView_Previews: PreviewProvider {
    static var previews: some View {
        AllRacesView(storeManager: StoreManager())
    }
}

