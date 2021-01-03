//
//  SettingsListView.swift
//  theracingline
//
//  Created by David Ellis on 14/11/2020.
//

import SwiftUI

struct SettingsListView: View {
    
    @StateObject var storeManager: StoreManager
    @ObservedObject var data = DataController.shared
    
    var body: some View {

        ScrollView {
            VStack {
                GroupBox(label: SettingsLabelView(labelText: "About", labelImage: "info.circle")) {
                    
                    Divider().padding(.vertical, 4)
                    
                    HStack(alignment: .center, spacing: 10) {
                        Image("tRL-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(9)
                        Text("TheRacingLine is your personalised motorsport calendar tool. Custom notification times for the series you care about. All in a lightweight, independently-developed app.")
                            .font(.footnote)
                    }
                } //GROUPBOX
                
                GroupBox(label: SettingsLabelView(labelText: "Subscribe", labelImage: "flag")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "Subscribe for more series, race start times, start notifications and to remove ads.")

                    Divider().padding(.vertical, 4)
                    
                    NavigationLink(destination: SubscriptionLevelView(storeManager: storeManager)) {
                        SettingsRowView(content: "Subscription Options", symbol: "chevron.right")
                    }
                } //GROUPBOX
                

                GroupBox(label: SettingsLabelView(labelText: "Configure Series", labelImage: "app.badge")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "Select which series you would like to display in your lists and which series you'd like to receive push notifications for.")
                    
                    Divider().padding(.vertical, 4)
                    
                    NavigationLink(destination: ConfigureSeries()) {
                        SettingsRowView(content: "Configure Visible Series", symbol: "chevron.right")
                    }
                    
                    if data.userAccessLevel >= 3 {
                        Divider().padding(.vertical, 4)
                        
                        NavigationLink(destination: ConfigureNotificationView()) {
                            SettingsRowView(content: "Configure Notifications", symbol: "chevron.right")
                            
                        }
                    }
                } //GROUPBOX
                
                
                if data.userAccessLevel >= 5 {
                    GroupBox(label: SettingsLabelView(labelText: "Customisation", labelImage: "paintbrush")) {
                        Divider().padding(.vertical, 4)
                        SettingsDescriptionView(text: "Custom app icons and accent colours.")
                        
                        Divider().padding(.vertical, 4)
                        
                        NavigationLink(destination: CustomiseView()) {
                            SettingsRowView(content: "Icon", symbol: "chevron.right")
                        }
                        
                        Divider().padding(.vertical, 4)
                        
                        NavigationLink(destination: AppSelectionView()) {
                            SettingsRowView(content: "Accent Colour", symbol: "chevron.right")
                        }
                    } //GROUPBOX
                }
                
                GroupBox(label: SettingsLabelView(labelText: "Feed me coffee", labelImage: "heart.circle.fill")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "This app was built in my spare time, powered by coffee. This one off donation goes directly to my coffee intake.")
                    
                    Divider().padding(.vertical, 4)
                    
                    NavigationLink(destination: CoffeeView(storeManager: storeManager)) {
                        SettingsRowView(content: "Feed me coffee", symbol: "chevron.right")
                    }
                } //GROUPBOX
                
                GroupBox(label: SettingsLabelView(labelText: "tRL Links", labelImage: "link")) {
                    Divider().padding(.vertical, 4)
                    
                    Link(destination: URL(string: "https://theracingline.app")!) {
                        SettingsLinkView(content: "theRacingLine.app", symbol: "arrow.up.right.square", linkDestination: "theracingline.app")
                    }
                    Divider().padding(.vertical, 4)
                    
                    Link(destination: URL(string: "https://theracingline.net")!) {
                        SettingsLinkView(content: "theRacingLine.net", symbol: "arrow.up.right.square", linkDestination: "theracingline.net")
                    }
                    Divider().padding(.vertical, 4)
                    
                    Link(destination: URL(string: "https://twitter.com/theracingline")!) {
                        SettingsLinkView(content: "@theracingline", symbol: "arrow.up.right.square", linkDestination: "twitter.com/theracingline")
                    }
                } //GROUPBOX
                
                GroupBox(label: SettingsLabelView(labelText: ".dev Links", labelImage: "link")) {
                    Divider().padding(.vertical, 4)
                    
                    Link(destination: URL(string: "https://daveellis.dev")!) {
                        SettingsLinkView(content: "DaveEllis.dev", symbol: "arrow.up.right.square", linkDestination: "daveellis.dev")
                    }
                    Divider().padding(.vertical, 4)
                    
                    Link(destination: URL(string: "https://twitter.com/daveellisdev")!) {
                        SettingsLinkView(content: "@daveellisdev", symbol: "arrow.up.right.square", linkDestination: "twitter.com/daveellisdev")
                    }
                } //GROUPBOX

                GroupBox(label: SettingsLabelView(labelText: "Privacy Policy", labelImage: "lock")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "I don't collect your data. I don't want your data. Here is a boring privacy policy if you want more information on me not collecting your data.")
                    
                    Divider().padding(.vertical, 4)
                    
                    NavigationLink(destination: PrivacyPolicyView()) {
                        SettingsRowView(content: "Privacy Policy", symbol: "chevron.right")
                    }
                    
                    Divider().padding(.vertical, 4)
                    
                    NavigationLink(destination: TermsAndConditionsView()) {
                        SettingsRowView(content: "Terms & Conditions", symbol: "chevron.right")
                    }
                } //GROUPBOX
                
//                GroupBox(label: SettingsLabelView(labelText: "Beta Testing Settings", labelImage: "gearshape.2")) {
//                    Divider().padding(.vertical, 4)
//                    SettingsDescriptionView(text: "Settings useful for beta testing the app. Have a play around with these and see if it works as expected.")
//                    
//                    Divider().padding(.vertical, 4)
//                    
//                    NavigationLink(destination: BetaTestSettingsView()) {
//                        SettingsRowView(content: "Beta Settings", symbol: "chevron.right")
//                        
//                    }
//                } //GROUPBOX
                
            } // VSTACK
            .padding()
        } // SCROLLVIEW
    }
}

struct SettingsListView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsListView(storeManager: StoreManager())
    }
}
