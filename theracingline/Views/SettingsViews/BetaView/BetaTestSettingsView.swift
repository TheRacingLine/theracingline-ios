//
//  BetaTestSettingsView.swift
//  theracingline
//
//  Created by David Ellis on 14/11/2020.
//

import SwiftUI

struct BetaTestSettingsView: View {
    
    @ObservedObject var data = DataController.shared
    @ObservedObject var notifications = NotificationController.shared
    @AppStorage("isOnboarding") var isOnboarding: Bool?

    var tick = "checkmark"
    

    var body: some View {
        ScrollView {
            VStack {
                GroupBox(label: SettingsLabelView(labelText: "Testing", labelImage: "doc.badge.gearshape")){
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "Options in this section are for the purposes of beta testing and will be disabled in the final build.")
                }

                GroupBox(label: SettingsLabelView(labelText: "Subscription Level", labelImage: "list.bullet.rectangle")){
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "Test different subscription levels.")
                    Divider().padding(.bottom, 4)
                    
                    Button(action: {
                        data.menuHaptics()
                        data.setUserAccessLevel(newAccessLevel: 0)
                    }) {
                        if data.userAccessLevel == 0 {
                            SettingsRowView(content: "Free", symbol: tick)
                        } else {
                            SettingsRowView(content: "Free")
                        }
                    }
                    
                    Divider().padding(.vertical, 4)
                    
                    Button(action: {
                        data.menuHaptics()
                        data.setUserAccessLevel(newAccessLevel: 1)
                    }) {
                        if data.userAccessLevel == 1 {
                            SettingsRowView(content: "Bronze", symbol: tick)
                        } else {
                            SettingsRowView(content: "Bronze")
                        }
                    }
                    
                    Divider().padding(.vertical, 4)
                    
                    Button(action: {
                        data.menuHaptics()
                        data.setUserAccessLevel(newAccessLevel: 2)
                    }) {
                        if data.userAccessLevel == 2 {
                            SettingsRowView(content: "Silver", symbol: tick)
                        } else {
                            SettingsRowView(content: "Silver")
                        }
                    }
                    
                    Divider().padding(.vertical, 4)
                    
                    Button(action: {
                        data.menuHaptics()
                        data.setUserAccessLevel(newAccessLevel: 3)
                    }) {
                        if data.userAccessLevel == 3 {
                            SettingsRowView(content: "Gold", symbol: tick)
                        } else {
                            SettingsRowView(content: "Gold")
                        }
                    }
                }
                
                GroupBox(label: SettingsLabelView(labelText: "Onboarding", labelImage: "person.fill.badge.plus")){
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "Resets the onboarding screen so it can be tested after a user has onboarded. This takes you back to onboarding immediately.")
                    Divider().padding(.vertical, 4)
                    
                    Button(action: {
                        isOnboarding = true
                        data.menuHaptics()
                    }) {
                        SettingsRowView(content: "Reset Onboarding Screen")
                    }
                }
                
                
            } //VSTACK
            .padding(.horizontal, 20)
        } // SCROLLVIEW
        .navigationBarTitle("Beta Test Settings")
    }
}

struct BetaTestSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        BetaTestSettingsView()
    }
}
