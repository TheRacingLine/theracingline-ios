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
        
        // load the visibile series preferences stored on the device
        data.getVisibleSeriesPreferences()
        
        // load notification sounds
        data.getNotificationSound()
        
        // load notification offset preferences
        notifications.loadNotificationTime(notificationNumber: 1)
        
        // load notification preferences stored on the device
        data.getNotificationPreferences()
        
        // download new data //

        // download new series list
        data.getSeriesList()
        
        // download new session list
        data.getNewSessions()
        
        // setup visible series list
        data.initiliseVisibleSeries()
        
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

extension ScrollView {
    
    public func fixFlickering() -> some View {
        
        return self.fixFlickering { (scrollView) in
            
            return scrollView
        }
    }
    
    public func fixFlickering<T: View>(@ViewBuilder configurator: @escaping (ScrollView<AnyView>) -> T) -> some View {
        
        GeometryReader { geometryWithSafeArea in
            GeometryReader { geometry in
                configurator(
                ScrollView<AnyView>(self.axes, showsIndicators: self.showsIndicators) {
                    AnyView(
                    VStack {
                        self.content
                    }
                    .padding(.top, geometryWithSafeArea.safeAreaInsets.top)
                    .padding(.bottom, geometryWithSafeArea.safeAreaInsets.bottom)
                    .padding(.leading, geometryWithSafeArea.safeAreaInsets.leading)
                    .padding(.trailing, geometryWithSafeArea.safeAreaInsets.trailing)
                    )
                }
                )
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
