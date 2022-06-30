//
//  SettingsListView.swift
//  theracingline
//
//  Created by David Ellis on 14/11/2020.
//

import SwiftUI
import StoreKit

struct SettingsListView: View {
    
    @StateObject var storeManager: StoreManager
    @State private var showingAlert = false
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
                
                if Reachability.isConnectedToNetwork(){
                    GroupBox(label: SettingsLabelView(labelText: "TRL Premium", labelImage: "flag")) {
                        Divider().padding(.vertical, 4)
                        SettingsDescriptionView(text: "Subscribe for race start times and session notifications in your time zone.")
                        Divider().padding(.vertical, 4)

                        if storeManager.monthlySub == true || storeManager.annualSub == true {
                            VStack {
                                Text("Subscribed")
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                                    .padding(10.0)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .stroke(lineWidth: 2.0))
                                            .foregroundColor(.green)
                                Text("Thank You")
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .padding(.vertical, 10)
                            }
                        } else {
                            SubscriptionOptions(storeManager: storeManager)
                        }
                    
                        Divider().padding(.vertical, 4)
                        
                        NavigationLink(destination: SubscriptionLevelView(storeManager: storeManager)) {
                            SettingsRowView(content: "TRL Premium Options", symbol: "chevron.right")
                        }
                    } //GROUPBOX
                } else {
                    GroupBox(label: SettingsLabelView(labelText: "TRL Premium", labelImage: "flag")) {
                        Divider().padding(.vertical, 4)
                            Text("Subscribing requires an internet connection. Please ensure you are online, and that the app has access to the Wifi or Mobile/Cellular data connection and try again.")
                                .font(.footnote)
                    } //GROUPBOX
                }
                

                GroupBox(label: SettingsLabelView(labelText: "Settings", labelImage: "app.badge")) {
                    Divider().padding(.vertical, 4)
                    
                    NavigationLink(destination: ConfigureSeries()) {
                        SettingsRowView(content: "Visible Series", symbol: "chevron.right")
                    }
                    
                    if data.userAccessLevel >= 3 {
                        Divider().padding(.vertical, 4)
                        
                        NavigationLink(destination: ConfigureNotificationView()) {
                            SettingsRowView(content: "Notifications", symbol: "chevron.right")
                        }
                        
                        Divider().padding(.vertical, 4)
                        
                        NavigationLink(destination: ConfigureSoundsView()) {
                            SettingsRowView(content: "Sounds", symbol: "chevron.right")
                        }
                    }
                    
                    Divider().padding(.vertical, 4)
                    
                    NavigationLink(destination: WidgetsFAQ()) {
                        SettingsRowView(content: "Widgets", symbol: "chevron.right")
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
                
                GroupBox(label: SettingsLabelView(labelText: "FAQs", labelImage: "questionmark.circle")) {
                    Divider().padding(.vertical, 4)
                    
                    NavigationLink(destination: FAQView()) {
                        SettingsRowView(content: "You have questions, I have answers", symbol: "chevron.right")
                    }
                } //GROUPBOX
                
                GroupBox(label: SettingsLabelView(labelText: "Coffee Tip", labelImage: "heart.circle.fill")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "This app was built in my spare time, powered by coffee. This one off donation goes directly to my coffee intake.")
                    
                    Divider().padding(.vertical, 4)
                    
                    NavigationLink(destination: CoffeeView(storeManager: storeManager)) {
                        SettingsRowView(content: "Feed me coffee", symbol: "chevron.right")
                    }
                } //GROUPBOX
                
                GroupBox(label: SettingsLabelView(labelText: "tRL Links", labelImage: "link")) {
                    Divider().padding(.vertical, 4)
                    
                    Link(destination: URL(string: "https://twitter.com/theracingline")!) {
                        SettingsLinkView(content: "@theracingline", symbol: "arrow.up.right.square", linkDestination: "twitter.com/theracingline")
                    }
                    Divider().padding(.vertical, 4)

                    Link(destination: URL(string: "https://twitter.com/daveellisdev")!) {
                        SettingsLinkView(content: "@daveellisdev", symbol: "arrow.up.right.square", linkDestination: "twitter.com/daveellisdev")
                    }
                    Divider().padding(.vertical, 4)
                    Link(destination: URL(string: "https://daveellis.dev")!) {
                        SettingsLinkView(content: "DaveEllis.dev", symbol: "arrow.up.right.square", linkDestination: "daveellis.dev")
                    }
                } //GROUPBOX
                
                GroupBox(label: SettingsLabelView(labelText: "Our Friends", labelImage: "link")) {
                    Divider().padding(.vertical, 4)
                    
                    Link(destination: URL(string: "https://www.hydrorace.co.uk/")!) {
                        SettingsLinkView(content: "Hydrorace Drinks Bottles", symbol: "arrow.up.right.square", linkDestination: "hydrorace.co.uk")
                    }
                    Divider().padding(.vertical, 4)
                    
                    Link(destination: URL(string: "https://soundsgoodsoundworks.com/")!) {
                        SettingsLinkView(content: "Sounds Good Sound Works", symbol: "arrow.up.right.square", linkDestination: "soundsgoodsoundworks.com")
                    }
                    Divider().padding(.vertical, 4)
                    
                    Link(destination: URL(string: "https://endurancechat.podbean.com/")!) {
                        SettingsLinkView(content: "Endurance Chat Podcast", symbol: "arrow.up.right.square", linkDestination: "endurancechat.podbean.com")
                    }
                    Divider().padding(.vertical, 4)
                    
                    Link(destination: URL(string: "https://www.youtube.com/c/GregzVR/featured")!) {
                        SettingsLinkView(content: "GregzVR VR Sim Racing", symbol: "arrow.up.right.square", linkDestination: "youtube.com/c/GregzVR/featured")
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
                Group {
                    
                    GroupBox(label: SettingsLabelView(labelText: "Version", labelImage: "gearshape.fill")) {
                        
                        Divider().padding(.vertical, 4)

                        SettingsDescriptionView(text: "Version 1.48", useBlack: true)
                    } //GROUPBOX
                
                
//                    GroupBox(label: SettingsLabelView(labelText: "Beta Testing Settings", labelImage: "gearshape.2")) {
//                        Divider().padding(.vertical, 4)
//                        SettingsDescriptionView(text: "Settings useful for beta testing the app. Have a play around with these and see if it works as expected.")
//
//                        Divider().padding(.vertical, 4)
//
//                        NavigationLink(destination: BetaTestSettingsView()) {
//                            SettingsRowView(content: "Beta Settings", symbol: "chevron.right")
//
//                        }
//                    } //GROUPBOX
                } // GROUP
                
            } // VSTACK
            .padding()
        } // SCROLLVIEW
    }
    
    func getSubLevel(subLevel: String) -> SKProduct {
        let subscription = self.storeManager.myProducts.filter { $0.productIdentifier.contains(subLevel) }.first
        if subscription != nil {
            return subscription!
        } else {
            print(storeManager.myProducts)
            return storeManager.myProducts[0]
        }
    }
}

struct SettingsListView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsListView(storeManager: StoreManager())
    }
}
