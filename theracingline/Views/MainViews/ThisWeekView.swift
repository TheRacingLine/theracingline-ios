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

    var body: some View {
        SessionListView(storeManager: storeManager, sessions: data.thisWeekSessions, noSessionText: "No sessions this week")
            .navigationTitle("This Week")
    }
}

struct ThisWeekView_Previews: PreviewProvider {
    static var previews: some View {
        ThisWeekView(storeManager: StoreManager())
    }
}

var testSessions = [testSession1, testSession2, testSession3, testSession4]


// data.thisWeekSessions
