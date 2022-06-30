//
//  ConfigureNotificationView.swift
//  theracingline
//
//  Created by David Ellis on 03/12/2020.
//

import SwiftUI

struct ConfigureNotificationView: View {
    
    // 0 - series selection
    // 1 - notification timer
    @State var selected = 0
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        VStack {
            Picker(selection: $selected, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/, content: {
                Text("Series").tag(0)
                Text("Sessions").tag(1)
                Text("Offset").tag(2)
            }).pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selected, perform: { value in
                data.simpleMenuHaptics()
            })
            if selected == 0 {
                ConfigureNotificationSeriesView()
            } else if selected == 1 {
                ConfigureNotificationSessionView()
            } else if selected == 2 {
                ConfigureNotificationTimeView()
            }
        }
    }
}

struct ConfigureNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureNotificationView()
    }
}
