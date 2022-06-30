//
//  ConfigureNotificationTimeView.swift
//  theracingline
//
//  Created by David Ellis on 03/12/2020.
//

import SwiftUI

struct ConfigureNotificationTimeView: View {
    var body: some View {
        VStack {
            GroupBox(label: SettingsLabelView(labelText: "Notification Offset", labelImage: "info.circle")) {
                
                Divider().padding(.vertical, 4)
                
                SettingsDescriptionView(text: "Set the amount of time before the green flag that you want a notification to display.")
            } //GROUPBOX
            .padding(.horizontal, 20)
            HStack{
                Spacer()
                Text("Days")
                    .fontWeight(.bold)
                Spacer()
                Text("Hours")
                    .fontWeight(.bold)
                Spacer()
                Text("Minutes")
                    .fontWeight(.bold)
                Spacer()
            }
            HStack{
                Spacer()
                TimePickerView(notificationSelector: 1)
                    .frame(height: 150)
                Spacer()
                Spacer()
            }.padding(.bottom, 50)

            Spacer()
        }.navigationBarTitle("Notifications")

    }
}

struct ConfigureNotificationTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureNotificationTimeView()
    }
}
