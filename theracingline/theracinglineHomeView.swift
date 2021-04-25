//
//  theracinglineHomeView.swift
//  theracingline
//
//  Created by David Ellis on 12/11/2020.
//

import SwiftUI

struct theracinglineHomeView: View {
    
    @StateObject var storeManager: StoreManager
    @ObservedObject var data = DataController.shared

    
    var body: some View {
        TabView {
            NavigationView {
                TodayView(storeManager: storeManager)
            }
                .tabItem {
                    // replace with todays date - 20.square
                    Image(systemName: "\(data.currentDate).square")
                    Text("Today")
                }
            
            NavigationView {
                ThisWeekView(storeManager: storeManager)
            }
                .tabItem {
                    Image(systemName: "calendar")
                    Text("This Week")
                }
            
            NavigationView {
                AllRacesView(storeManager: storeManager)
            }
                .tabItem {
                    Image(systemName: "flag.fill")
                    Text("All Races")
                }
            
            NavigationView {
                AllSeriesView()
            }
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Calendars")
                }
            
            NavigationView {
                SettingsView(storeManager: storeManager)
            }
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Settings")
                }
        }
    }
}

struct theracinglineHomeView_Previews: PreviewProvider {
    static var previews: some View {
        theracinglineHomeView(storeManager: StoreManager())
    }
}
