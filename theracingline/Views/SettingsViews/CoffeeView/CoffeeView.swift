//
//  CoffeeView.swift
//  theracingline
//
//  Created by David Ellis on 15/11/2020.
//

import SwiftUI
import StoreKit

struct CoffeeView: View {
    
    @StateObject var storeManager: StoreManager
    @State private var showingAlert = false


    var body: some View {
        VStack{
            GroupBox(label: SettingsLabelView(labelText: "Coffee Tip", labelImage: "heart.circle.fill")){
                Divider().padding(.vertical, 4)
                SettingsDescriptionView(text: "This app is created by a single developer, powered purely by coffee and a love of motorsport. This one-off tip will go straight to my coffee intake.")
                Divider().padding(.vertical, 4)
                
                let coffee = self.getSubLevel(subLevel: "coffee")
                Button(action: {
                    if Reachability.isConnectedToNetwork() {
                        storeManager.purchaseProduct(product: coffee)
                    } else {
                        self.showingAlert = true
                    }
                }) {
                    Text("One-Off Tip - \(coffee.localizedPrice)")
                }
                .foregroundColor(.blue)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Requires Internet Connection"), message: Text("Subscribing requires an internet connection. Please ensure you are online, and that the app has access to the Wifi or Mobile/Cellular data connection and try again."), dismissButton: .default(Text("Ok")))
                }
            }
            Spacer()
        } // VSTACK
        .padding(.horizontal, 20)
        .navigationBarTitle("Feed me coffee")
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

struct CoffeeView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeView(storeManager: StoreManager())
    }
}
