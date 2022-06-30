//
//  SubscriptionOptions.swift
//  theracingline-iOS
//
//  Created by Dave on 30/03/2022.
//

import SwiftUI
import StoreKit

struct SubscriptionOptions: View {
    
    @StateObject var storeManager: StoreManager
    @State private var showingAlert = false
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        Group {
            Text("Monthly")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text("One Month Free Trial")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.caption)
                .foregroundColor(.green)
            Text("Auto renews")
                .font(.caption)
        }
        Group {
            let sub = self.getSubLevel(subLevel: "gold")

            if storeManager.monthlySub == true {
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
                }
            } else {
                Button(action: {
                    if Reachability.isConnectedToNetwork() {
                        storeManager.purchaseProduct(product: sub)
                    } else {
                        self.showingAlert = true
                    }
                }) {
                    VStack {
                        Text("Subscribe for \(sub.localizedPrice) / month")
                            .padding(10.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 2.0))
                            .padding(.vertical, 5)
                    }
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
            Text("One Month Free Trial")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.caption)
                .foregroundColor(.green)
            Text("2 Months Free")
                .font(.caption)
            Text("Auto renews")
                .font(.caption)
        }
        
        // MARK:- Annual Subscription Button
        Group {
            let sub = self.getSubLevel(subLevel: "annual")

            if storeManager.annualSub == true {
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
                }
            } else {
                Button(action: {
                    if Reachability.isConnectedToNetwork() {
                        storeManager.purchaseProduct(product: sub)
                    } else {
                        self.showingAlert = true
                    }
                }) {
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

struct SubscriptionOptions_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionOptions(storeManager: StoreManager())
    }
}
