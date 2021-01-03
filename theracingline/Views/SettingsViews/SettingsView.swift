//
//  SettingsView.swift
//  theracingline
//
//  Created by David Ellis on 14/11/2020.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var storeManager: StoreManager

    var body: some View {
        SettingsListView(storeManager: storeManager)
            .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(storeManager: StoreManager())
    }
}
