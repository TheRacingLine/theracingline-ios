//
//  MainView.swift
//  theracingline
//
//  Created by David Ellis on 09/01/2021.
//

import SwiftUI
import StoreKit

struct MainView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    let productIDs = ["dev.daveellis.theracingline.coffee",
                      "dev.daveellis.theracingline.bronze",
                      "dev.daveellis.theracingline.silver",
                      "dev.daveellis.theracingline.gold",
                      "dev.daveellis.theracingline.annual"]

    @StateObject var storeManager = StoreManager()
    
    @ObservedObject var data = DataController.shared
    @ObservedObject var notifications = NotificationController.shared

    
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    
    var body: some View {
        
        
        
        if !isOnboarding {
            
            // iPhone layout
            if horizontalSizeClass == .compact{
                theracinglineHomeView(storeManager: storeManager)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                        toForeground()
                    }
                    .onAppear(perform: {
                        onboardFunctions()
                        SKPaymentQueue.default().add(storeManager)
                        storeManager.getProducts(productIDs: productIDs)
                    })
                    .onChange(of: data.sessions, perform: { value in
                        notifications.rebuildNotifications()
                    })
            } else {
                theracinglineSideBarView(storeManager: storeManager)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                        toForeground()
                    }
                    .onAppear(perform: {
                        onboardFunctions()
                        SKPaymentQueue.default().add(storeManager)
                        storeManager.getProducts(productIDs: productIDs)
                    })
                    .onChange(of: data.sessions, perform: { value in
                        notifications.rebuildNotifications()
                    })
            }
   
        } else {
            theracinglineOnboarding()
                .onAppear(){
                    onboardFunctions()
                }
        }
    }
    
    func onboardFunctions(){
        
        // load device data first
        
        // access level first
        data.getUserAccessLevel()
        
        // get the series list stored on the device
        data.loadSeriesData()
        
        // get the session data stored on the device
        data.loadData()
        
        // load notification preferences stored on the device
        data.getNotificationPreferences()
        
        // load the visibile series preferences stored on the device
        data.getVisibleSeriesPreferences()
        
        // load notification offset preferences
        notifications.loadNotificationTime(notificationNumber: 1)
        
        // download new data //

        // download new series list
        data.getSeriesList()
        
        // download new session list
        data.getNewSessions()
        
        // setup visible series list
        data.initiliseVisibleSeries()
        
        // setup notifications
        data.initiliseNotificationSettings()
        
        storeManager.restoreSubscriptionStatus()
    }
    
    func toForeground() {
        
        // download new series list
        data.getSeriesList()
        
        // download new session list
        data.getNewSessions()
        
        // get subscription status
        storeManager.restoreSubscriptionStatus()

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
