//
//  TodayView.swift
//  theracingline
//
//  Created by David Ellis on 12/11/2020.
//

import SwiftUI

struct TodayView: View {
    
    @ObservedObject var data = DataController.shared
    @StateObject var storeManager: StoreManager

    var body: some View {
        VStack{
            SessionListView(storeManager: storeManager, sessions: data.todaysSessions, noSessionText: "No sessions today")
                .navigationTitle("Today")
            if data.userAccessLevel < 1 {
                Spacer()
                AdView(advert: data.selectedAd)
                    .onAppear(){
                        data.randomlySelectAd()
                    }
            }
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView(storeManager: StoreManager())
    }
}
