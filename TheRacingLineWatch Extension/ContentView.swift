//
//  ContentView.swift
//  TheRacingLineWatch Extension
//
//  Created by David Ellis on 03/04/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var data = WatchToPhoneDataController.shared
    
    var body: some View {
        
        TabView {
            WatchListView(sessions: data.todaySession, navTitle: "Today", noSessionText: "No Sessions today. Check the phone for more information.")
            WatchListView(sessions: data.sessions, navTitle: "This Week", noSessionText: "No Sessions this week. Check the phone for more information.")
            InfoView(navTitle: "Info")
                .tabViewStyle(PageTabViewStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
