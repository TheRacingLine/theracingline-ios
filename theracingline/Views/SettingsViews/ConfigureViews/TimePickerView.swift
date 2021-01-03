//
//  TimePickerView.swift
//  theracingline
//
//  Created by David Ellis on 03/12/2020.
//

import SwiftUI

struct TimePickerView: View {
    
    //@ObservedObject var data = DataController.shared
    @ObservedObject var notifications = NotificationController.shared
    @ObservedObject var data = DataController.shared

    @State private var selectedDays = 0
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    @State private var showingAlert = false
    
    var notificationSelector: Int
    
    var days = Array(0...6)
    var hours = Array(0...23)
    var minutes = Array(0...59)

    var body: some View {
        GeometryReader { geometry in
            VStack{
                HStack {
                    Spacer()
                    Picker(selection: self.$selectedDays, label: Text("Days")) {
                        ForEach(0..<self.days.count) { day in
                            Text("\(day)")
                        }
                    }.onAppear(){
                        self.selectedDays = notifications.getNotificatimeTimeDays(notificationNumber: notificationSelector)
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width / CGFloat(3.5), height: geometry.size.height)
                    .clipped()
                    Picker(selection: self.$selectedHours, label: Text("Hours")) {
                        ForEach(0..<self.hours.count) { hour in
                            Text("\(hour)")
                        }
                    }.onAppear(){
                        self.selectedHours = notifications.getNotificatimeTimeHours(notificationNumber: notificationSelector)
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width / CGFloat(3.5), height: geometry.size.height)
                    .clipped()
                    Picker(selection: self.$selectedMinutes, label: Text("Minutes")) {
                        ForEach(0..<self.minutes.count) { minute in
                            Text("\(minute)")
                        }
                    }.onAppear(){
                        self.selectedMinutes = notifications.getNotificatimeTimeMinutes(notificationNumber: notificationSelector)
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width / CGFloat(3.5), height: geometry.size.height)
                    .clipped()
                    Spacer()
                }
                Button(action: {
                    self.showingAlert = true
                    notifications.setNotificationTime(notificationNumber: notificationSelector, days: self.selectedDays, hours: self.selectedHours, minutes: self.selectedMinutes)
                    notifications.saveNotificationTime(notificationNumber: notificationSelector)
                    notifications.rebuildNotifications()
                    data.menuHaptics()
                }) {
                    Text("Confirm Notification Offset")
                }.padding()
                
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Notification Offset Confirmed"), dismissButton: .default(Text("Ok")))
                }
            }
        }
    }
}

struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerView(notificationSelector: 1)
    }
}
