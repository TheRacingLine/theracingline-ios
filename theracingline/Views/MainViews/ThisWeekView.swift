//
//  ThisWeekView.swift
//  theracingline
//
//  Created by David Ellis on 12/11/2020.
//

import SwiftUI

struct ThisWeekView: View {
    
    @ObservedObject var data = DataController.shared
    @StateObject var storeManager: StoreManager
    @State var selected = 1

    var body: some View {
        VStack (spacing: 0) {
            Picker(selection: $selected, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/, content: {
                Text("Last Week").tag(0)
                Text("This Week").tag(1)
                Text("Next Week").tag(2)
            }).pickerStyle(SegmentedPickerStyle())
                .padding()
            .onChange(of: selected, perform: { value in
                data.simpleMenuHaptics()
            })
            Divider()
            
            if selected == 0 {
                SessionListNoFilterView(storeManager: storeManager, sessions: data.lastWeekSessions, noSessionText: "No sessions last week")
                    .navigationTitle("Last Week")
            } else if selected == 1 {
                SessionListView(storeManager: storeManager, sessions: data.thisWeekSessions, noSessionText: "No sessions this week")
                    .navigationTitle("This Week")
            } else if selected == 2 {
                SessionListView(storeManager: storeManager, sessions: data.nextWeekSessions, noSessionText: "No sessions next week")
                    .navigationTitle("Next Week")
            }
        }
        
    }
}

struct ThisWeekView_Previews: PreviewProvider {
    static var previews: some View {
        ThisWeekView(storeManager: StoreManager())
    }
}

var testSessions = [testSession1, testSession2, testSession3, testSession4]


// data.thisWeekSessions
