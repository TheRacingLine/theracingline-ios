//
//  ConfigureNotificationSeriesView.swift
//  theracingline
//
//  Created by David Ellis on 15/11/2020.
//

import SwiftUI

struct ConfigureNotificationSeriesView: View {
    
    @ObservedObject var data = DataController.shared
    @ObservedObject var notifications = NotificationController.shared

    var body: some View {
        List {
            HStack {
                Spacer()
                
                Button(action: {
                    data.selectAllNotificationsSeries()
                    data.menuHaptics()
                }) {
                    Text("Select All")
                }.buttonStyle(BorderlessButtonStyle())
                
                Spacer()

                Button(action: {
                    data.selectNoneNotificationsSeries()
                    data.menuHaptics()
                }) {
                    Text("Select None")
                }.buttonStyle(BorderlessButtonStyle())
                
                
                Spacer()
            }
            ForEach(data.getVisibleSeriesListInOrder(), id: \.self) { seriesName in
                
                ConfigurationNotificationRowView(seriesName: seriesName)
            }
        } // LIST
        .navigationBarTitle("Notifications")
        .onAppear(){
            notifications.requestPermission()
        }
        .onChange(of: data.seriesWithNotifications, perform: { value in
            notifications.rebuildNotifications()
        })
    } // BODY
}

struct ConfigureNotificationSeriesView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureNotificationSeriesView()
    }
}
