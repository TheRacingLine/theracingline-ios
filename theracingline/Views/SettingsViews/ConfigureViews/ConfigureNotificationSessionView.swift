//
//  ConfigureNotificationSessionView.swift
//  theracingline-iOS
//
//  Created by Dave on 30/03/2022.
//

import SwiftUI

struct ConfigureNotificationSessionView: View {
    
    @ObservedObject var data = DataController.shared
    
    @State private var race = true
    @State private var qualifying = true
    @State private var practice = true
    
    var body: some View {
        List {
            HStack {
                Toggle("Race", isOn: $race)
                    .onChange(of: race, perform: { value in
                        if race {
                            data.setRaceNotificationSetting(setting: true)
                        } else {
                            data.setRaceNotificationSetting(setting: false)
                        } // IF ELSE
                        race = data.getRaceNotificationSetting()
                        data.setNotificationPreferences()
                    }) // ONCHANGE
                    .onAppear {
                        race = data.getRaceNotificationSetting()
                    } // ONAPPEAR
                    .onTapGesture {
                        data.menuHaptics()
                    } // ONTAPGESTURE
            }
            HStack {
                Toggle("Qualifying", isOn: $qualifying)
                    .onChange(of: qualifying, perform: { value in
                        if qualifying {
                            data.setQualNotificationSetting(setting: true)
                        } else {
                            data.setQualNotificationSetting(setting: false)
                        } // IF ELSE
                        qualifying = data.getQualNotificationSetting()
                        data.setNotificationPreferences()
                    }) // ONCHANGE
                    .onAppear {
                        qualifying = data.getQualNotificationSetting()
                    } // ONAPPEAR
                    .onTapGesture {
                        data.menuHaptics()
                    } // ONTAPGESTURE
            }
            HStack {
                Toggle("Practice", isOn: $practice)
                    .onChange(of: practice, perform: { value in
                        if practice {
                            data.setPracNotificationSetting(setting: true)
                        } else {
                            data.setPracNotificationSetting(setting: false)
                        } // IF ELSE
                        practice = data.getPracNotificationSetting()
                        data.setNotificationPreferences()
                    }) // ONCHANGE
                    .onAppear {
                        practice = data.getPracNotificationSetting()
                    } // ONAPPEAR
                    .onTapGesture {
                        data.menuHaptics()
                    } // ONTAPGESTURE
            }
           
        }.navigationBarTitle("Notifications")
        Spacer()
    }
}

struct ConfigureNotificationSessionView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureNotificationSessionView()
    }
}
