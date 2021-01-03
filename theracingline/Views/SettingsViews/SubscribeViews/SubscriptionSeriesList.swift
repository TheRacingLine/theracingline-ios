//
//  SubscriptionSeriesList.swift
//  theracingline
//
//  Created by David Ellis on 24/11/2020.
//

import SwiftUI

struct SubscriptionSeriesList: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        ScrollView {
            GroupBox(label: SettingsLabelView(labelText: "Currently Supported Series", labelImage: "flag.circle")) {
                Divider().padding(.vertical, 4)
                SubscriptionLevelList(text: "Race Dates for:", list: data.seriesList)
                Divider().padding(.vertical, 4)
                Text("More series coming soon. Tweet me your favourites and I'll prioritise.")
            } //GROUPBOX
        } // SCROLLVIEW
         
        .padding(.horizontal, 20)
        .navigationBarTitle("Current Series")
        
    }
}

struct SubscriptionSeriesList_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionSeriesList()
    }
}
