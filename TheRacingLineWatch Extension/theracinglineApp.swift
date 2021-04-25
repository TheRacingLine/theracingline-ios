//
//  theracinglineApp.swift
//  TheRacingLineWatch Extension
//
//  Created by David Ellis on 03/04/2021.
//

import SwiftUI

@main
struct theracinglineApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
