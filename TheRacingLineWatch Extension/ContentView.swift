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
        
        let today = Date()
        
        TabView {
            WatchListView(sessions: data.todaySession, navTitle: "Today", noSessionText: "No Sessions today. Check the phone for more information.")
            WatchListView(sessions: data.sessions, navTitle: "This Week", noSessionText: "No Sessions this week. Check the phone for more information.")
            WatchListView(sessions: data.allSessions.filter { ($0.date >= today) }, navTitle: "All Sessions", noSessionText: "No Sessions this week. Check the phone for more information.")
            InfoView(navTitle: "Info")
                .tabViewStyle(PageTabViewStyle())
        }.onReceive(NotificationCenter.default.publisher(for: WKExtension.applicationWillEnterForegroundNotification)) { _ in
            data.loadSavedSessions()
        }.onAppear(){
            data.loadSavedSessions()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
