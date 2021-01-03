//
//  ConfigurationNotificationRowView.swift
//  theracingline
//
//  Created by David Ellis on 27/11/2020.
//

import SwiftUI

struct ConfigurationNotificationRowView: View {
    
    @ObservedObject var data = DataController.shared
    @ObservedObject var notifications = NotificationController.shared
    
    var seriesName: String
    
    @State private var seriesNotification = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5){
            HStack {
                Toggle(seriesName, isOn: $seriesNotification)
                    .onChange(of: seriesNotification) { value in
                        if seriesNotification {
                            if !data.seriesWithNotifications.contains(seriesName) {
                                data.seriesWithNotifications.append(seriesName)
                                print(data.seriesWithNotifications)
                            }
                        } else if !seriesNotification {
                            while data.seriesWithNotifications.contains(seriesName) {
                                let index = data.seriesWithNotifications.firstIndex(of: seriesName)
                                data.seriesWithNotifications.remove(at: index!)
                                print(data.seriesWithNotifications)
                            }
                        }
                        data.setNotificationPreferences()
                    }
                    .onChange(of: data.seriesWithNotifications, perform: { value in
                        checkIfSeriesSelected()
                    })
                .onAppear {
                    checkIfSeriesSelected()
                }
                .onTapGesture {
                    data.menuHaptics()
                }
            }
        }
    }
    
    func checkIfSeriesSelected(){
        if data.seriesWithNotifications.contains(seriesName){
            seriesNotification = true
        } else {
            seriesNotification = false
        }
    }
}

struct ConfigurationNotificationRowView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationNotificationRowView(seriesName: "Formula 1")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
