//
//  theracinglineSideBarView.swift
//  theracingline
//
//  Created by David Ellis on 09/01/2021.
//

import SwiftUI

struct theracinglineSideBarView: View {
    
    @StateObject var storeManager: StoreManager
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        
        TabView {
            NavigationView {
                TodayView(storeManager: storeManager)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                // replace with todays date - 20.square
                Image(systemName: "\(data.currentDate).square")
                Text("Today")
            }
            
            NavigationView {
                ThisWeekView(storeManager: storeManager)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "calendar")
                Text("This Week")
            }
            
            NavigationView {
                AllRacesView(storeManager: storeManager)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "flag.fill")
                Text("All Races")
            }
            
            NavigationView {
                AllSeriesView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Calendars")
            }
            
            NavigationView {
                SettingsView(storeManager: storeManager)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "slider.horizontal.3")
                Text("Settings")
            }
        }
        
//        NavigationView {
//            List {
//                NavigationLink(destination: TodayView(storeManager: storeManager)) {
//                    Label("Today", systemImage: "\(data.currentDate).square")
//                }
//                NavigationLink(destination: ThisWeekView(storeManager: storeManager)) {
//                    Label("This Week", systemImage: "calendar")
//                }
//                NavigationLink(destination: AllRacesView(storeManager: storeManager)) {
//                    Label("All Races", systemImage: "flag.fill")
//                }
//                NavigationLink(destination: AllSeriesView()) {
//                    Label("Calendars", systemImage: "list.bullet")
//                }
//                NavigationLink(destination: SettingsView(storeManager: storeManager)) {
//                    Label("Settings", systemImage: "slider.horizontal.3")
//                }
//            }
//            .listStyle(DefaultListStyle())
//            .navigationTitle("The Racing Line")
//            .padding(.leading, 1)
//            TodayView(storeManager: storeManager)
//
//        }
    }
}

struct theracinglineSideBarView_Previews: PreviewProvider {
    static var previews: some View {
        theracinglineSideBarView(storeManager: StoreManager())
    }
}
