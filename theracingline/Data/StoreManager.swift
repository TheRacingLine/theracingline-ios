//
//  StoreManager.swift
//  TestingIAP
//
//  Created by David Ellis on 12/12/2020.
//

import Foundation
import StoreKit
import SwiftUI
import TPInAppReceipt


class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @ObservedObject var data = DataController.shared
    @ObservedObject var notificatons = NotificationController.shared

    //FETCH PRODUCTS
    var request: SKProductsRequest!
    
    @Published var myProducts = [SKProduct]()
    
    func getProducts(productIDs: [String]) {
        print("Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Did receive response")
        
        if !response.products.isEmpty {
            for fetchedProduct in response.products {
                print("IAP Found")
                print(fetchedProduct.localizedTitle)
                DispatchQueue.main.async {
                    self.myProducts.append(fetchedProduct)
                }
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
    
    //HANDLE TRANSACTIONS
    @Published var transactionState: SKPaymentTransactionState?
    
    func purchaseProduct(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User can't make payment.")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                transactionState = .purchased
                updateUserAccess(productIdentifier: transaction.payment.productIdentifier)
                data.initiliseVisibleSeries()
                data.initiliseNotificationSettings()
            case .restored:
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                transactionState = .restored
                updateUserAccess(productIdentifier: transaction.payment.productIdentifier)
                data.initiliseVisibleSeries()
            case .failed, .deferred:
                print("Payment Queue Error: \(String(describing: transaction.error))")
                queue.finishTransaction(transaction)
                transactionState = .failed
            default:
                queue.finishTransaction(transaction)
            }
        }
    }
    
    func restoreProducts() {
        print("Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func updateUserAccess(productIdentifier: String){
        switch productIdentifier {
        case "dev.daveellis.theracingline.bronze":
            self.data.setUserAccessLevel(newAccessLevel: 1)
        case "dev.daveellis.theracingline.silver":
            self.data.setUserAccessLevel(newAccessLevel: 2)
        case "dev.daveellis.theracingline.gold":
            self.data.setUserAccessLevel(newAccessLevel: 3)
            self.notificatons.requestPermission()
        case "dev.daveellis.theracingline.coffee":
                print("Coffee purchased")
        default:
            self.data.setUserAccessLevel(newAccessLevel: 0)
        }
    }
    
    func restoreSubscriptionStatus() {
        InAppReceipt.refresh { (error) in
            if let err = error {
                print(err)
            } else {
            // do your stuff with the receipt data here
                if let receipt = try? InAppReceipt.localReceipt(){
                    if receipt.hasActiveAutoRenewableSubscription(ofProductIdentifier: "dev.daveellis.theracingline.gold", forDate: Date()) {
                        // user has subscription of the product, which is still active at the specified date
                        print("Gold Sub Found")
                        self.data.setUserAccessLevel(newAccessLevel: 3)
                    } else if receipt.hasActiveAutoRenewableSubscription(ofProductIdentifier: "dev.daveellis.theracingline.silver", forDate: Date()) {
                        // user has subscription of the product, which is still active at the specified date
                        print("Silver Sub Found")
                        self.data.setUserAccessLevel(newAccessLevel: 2)
                    } else if receipt.hasActiveAutoRenewableSubscription(ofProductIdentifier: "dev.daveellis.theracingline.bronze", forDate: Date()) {
                        // user has subscription of the product, which is still active at the specified date
                        print("Bronze Sub Found")
                        self.data.setUserAccessLevel(newAccessLevel: 1)
                    } else {
                        print("No Sub Found")
                        self.data.userAccessLevel = 0
                    }
                }
            }
        }
    }
}



extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}

