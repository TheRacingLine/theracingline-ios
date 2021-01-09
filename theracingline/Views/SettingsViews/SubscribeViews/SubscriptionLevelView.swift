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
        ScrollView{
            VStack {
                GroupBox(label: SettingsLabelView(labelText: "Subscription  🥇", labelImage: " ")) {
                    Divider().padding(.vertical, 4)
                    SubscriptionLevelList(text: "Features added:", list: ["Race dates for all series", "Race start times added for all series", "Configurable notifications added for all races"])

                    Divider().padding(.vertical, 4)
                    NavigationLink(destination: SubscriptionSeriesList()) {
                        SettingsRowView(content: "See current series list", symbol: "chevron.right")
                    }
                    Divider().padding(.vertical, 4)
                    
                    
                    Text("Monthly")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Text("Auto renews")
                        .font(.caption)
                    
                    // MARK:- Monthly Syubscription Button
                    Group {
                        let sub = self.getSubLevel(subLevel: "gold")

                        if storeManager.monthlySub == true {
                            Text("Subscribed")
                                .foregroundColor(.green)
                                .fontWeight(.bold)
                                .padding(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(lineWidth: 2.0))
                                        .foregroundColor(.green)
                        } else {
                            Button(action: {
                                if Reachability.isConnectedToNetwork() {
                                    storeManager.purchaseProduct(product: sub)
                                } else {
                                    self.showingAlert = true
                                }
                            }) {
                                Text("Subscribe for \(sub.localizedPrice) / month")
                                    .padding(10.0)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .stroke(lineWidth: 2.0))
                                    .padding(.vertical, 5)
                            }
                            .foregroundColor(.blue)
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Requires Internet Connection"), message: Text("Subscribing requires an internet connection. Please ensure you are online, and that the app has access to the Wifi or Mobile/Cellular data connection and try again."), dismissButton: .default(Text("Ok")))
                            }
                        }
                    }
                    VStack{
                        Divider().padding(.vertical, 4)
                        
                        Text("Annual")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("2 Months Free")
                            .font(.caption)
                        Text("Auto renews")
                            .font(.caption)
                    }
                    
                    // MARK:- Annual Subscription Button
                    Group {
                        let sub = self.getSubLevel(subLevel: "annual")

                        if storeManager.annualSub == true {
                            Text("Subscribed")
                                .foregroundColor(.green)
                                .fontWeight(.bold)
                                .padding(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(lineWidth: 2.0))
                                        .foregroundColor(.green)
                        } else {
                            Button(action: {
                                if Reachability.isConnectedToNetwork() {
                                    storeManager.purchaseProduct(product: sub)
                                } else {
                                    self.showingAlert = true
                                }
                            }) {
//                                Text("Subscribe for £29.99 / year")
                                Text("Subscribe for \(sub.localizedPrice) / year")
                                    .padding(10.0)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .stroke(lineWidth: 2.0))
                                    .padding(.vertical, 5)
                            }
                            .foregroundColor(.blue)
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Requires Internet Connection"), message: Text("Subscribing requires an internet connection. Please ensure you are online, and that the app has access to the Wifi or Mobile/Cellular data connection and try again."), dismissButton: .default(Text("Ok")))
                            }
                        }
                    }
                    
                } //GROUPBOX
                Spacer()
            } //VSTACK
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
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
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
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

struct SubscriptionLevelView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionLevelView(storeManager: StoreManager())
    }
}
