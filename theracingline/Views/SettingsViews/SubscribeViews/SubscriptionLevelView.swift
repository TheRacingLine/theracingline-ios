//
//  SubscriptionLevelView.swift
//  theracingline
//
//  Created by David Ellis on 15/11/2020.
//

import SwiftUI
import StoreKit

struct SubscriptionLevelView: View {
    
    @StateObject var storeManager: StoreManager
    @State private var showingAlert = false
    @ObservedObject var data = DataController.shared

    
    var body: some View {
        ScrollView {
            VStack {

                GroupBox(label: SettingsLabelView(labelText: "Free", labelImage: " ")) {
                    Divider().padding(.vertical, 4)
                    SubscriptionLevelList(text: "Race Dates for:", list: ["Formula 1", "Ad Supported"])
                } //GROUPBOX
                
            
                GroupBox(label: SettingsLabelView(labelText: "Gold 🥇", labelImage: " ")) {
                    Divider().padding(.vertical, 4)
                    SubscriptionLevelList(text: "Race Dates for:", list: ["All Series", "Race start times added for all series", "Configurable notifications added for all series", "Ads Removed"])

                    Divider().padding(.vertical, 4)
                    NavigationLink(destination: SubscriptionSeriesList()) {
                        SettingsRowView(content: "See current series list", symbol: "chevron.right")
                    }
                    Divider().padding(.vertical, 4)
                    
                    let sub = self.getSubLevel(subLevel: "gold")
                    
                    Text("Gold auto-renews at \(sub.localizedPrice) per month")
                        .font(.caption)
                        .padding(.bottom, 5)
                    
                    if data.userAccessLevel == 3 {
                        Text("Subscribed")
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                    } else {
                        Button(action: {
                            if Reachability.isConnectedToNetwork() {
                                storeManager.purchaseProduct(product: sub)
                            } else {
                                self.showingAlert = true
                            }
                        }) {
                            Text("Subscribe")
                        }
                        .foregroundColor(.blue)
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Requires Internet Connection"), message: Text("Subscribing requires an internet connection. Please ensure you are online, and that the app has access to the Wifi or Mobile/Cellular data connection and try again."), dismissButton: .default(Text("Ok")))
                        }
                    }
                } //GROUPBOX
                
                GroupBox(label: SettingsLabelView(labelText: "Silver 🥈", labelImage: " ")) {
                    Divider().padding(.vertical, 4)
                    SubscriptionLevelList(text: "Race Dates for:", list: ["All Series", "Ads Removed"])

                    Divider().padding(.vertical, 4)
                    
                    NavigationLink(destination: SubscriptionSeriesList()) {
                        SettingsRowView(content: "See current series list", symbol: "chevron.right")
                    }
                    Divider().padding(.vertical, 4)
                    
                    let sub = self.getSubLevel(subLevel: "silver")
                    
                    Text("Silver auto-renews at \(sub.localizedPrice) per month")
                        .font(.caption)
                        .padding(.bottom, 5)
                    
                    if data.userAccessLevel == 2 {
                        Text("Subscribed")
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                    } else if (data.userAccessLevel > 2){
                        Text("Subscribed to higher tier")
                            .foregroundColor(.gray)
                    } else {
                        Button(action: {
                            if Reachability.isConnectedToNetwork() {
                                storeManager.purchaseProduct(product: sub)
                            } else {
                                self.showingAlert = true
                            }
                        }) {
                            Text("Subscribe")
                        }
                        .foregroundColor(.blue)
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Requires Internet Connection"), message: Text("Subscribing requires an internet connection. Please ensure you are online, and that the app has access to the Wifi or Mobile/Cellular data connection and try again."), dismissButton: .default(Text("Ok")))
                        }
                    }
                } //GROUPBOX
                
                GroupBox(label: SettingsLabelView(labelText: "Bronze 🥉", labelImage: " ")) {
                    Divider().padding(.vertical, 4)
                    SubscriptionLevelList(text: "Race Dates for:", list: ["Formula 1", "IndyCar", "FIA WEC", "IMSA WeatherTech", "Ads Removed"])

                    Divider().padding(.vertical, 4)
                    
                    let sub = self.getSubLevel(subLevel: "bronze")
                    
                    Text("Bronze auto-renews at \(sub.localizedPrice) per month")
                        .font(.caption)
                        .padding(.bottom, 5)
                    
                    if data.userAccessLevel == 1 {
                        Text("Subscribed")
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                    } else if (data.userAccessLevel > 1){
                        Text("Subscribed to higher tier")
                            .foregroundColor(.gray)
                    } else {
                        Button(action: {
                            if Reachability.isConnectedToNetwork() {
                                storeManager.purchaseProduct(product: sub)
                            } else {
                                self.showingAlert = true
                            }
                        }) {
                            Text("Subscribe")
                        }
                        .foregroundColor(.blue)
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Requires Internet Connection"), message: Text("Subscribing requires an internet connection. Please ensure you are online, and that the app has access to the Wifi or Mobile/Cellular data connection and try again."), dismissButton: .default(Text("Ok")))
                        }
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
                
            } //VSTACK
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        } // SCROLLVIEW
 
        .navigationBarTitle("Subscriptions")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    storeManager.restoreSubscriptionStatus()
                }) {
                    Text("Restore Purchases")
                }
            }
        })
    }
    
    func getSubLevel(subLevel: String) -> SKProduct {
        let subscription = self.storeManager.myProducts.filter { $0.productIdentifier.contains(subLevel) }.first
        if subscription != nil {
            return subscription!
        } else {
            return storeManager.myProducts[0]
        }
    }

}

struct SubscriptionLevelView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionLevelView(storeManager: StoreManager())
    }
}
