//
//  WidgetsFAQ.swift
//  theracingline-iOS
//
//  Created by David Ellis on 03/03/2021.
//

import SwiftUI

struct WidgetsFAQ: View {
    var body: some View {
        ScrollView{
            VStack{
                GroupBox(label: SettingsLabelView(labelText: "My widget is saying no races", labelImage: "questionmark.circle")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "If the app says there are races, but the widget does not, leave the widget and it should sort itself soon. The widget updates every 15 minutes.", useBlack: true)
                }
                GroupBox(label: SettingsLabelView(labelText: "My widget looks different to the app", labelImage: "questionmark.circle")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "This is because the app has gotten the new race data, but the widget won't update for another 15 minutes. It will update soon.", useBlack: true)
                }
                GroupBox(label: SettingsLabelView(labelText: "I subscribed but the widget still says I haven't", labelImage: "questionmark.circle")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "Give it time. The widget will update when an event passes. This is due to Apples limits in how often the widget is allowed to update.", useBlack: true)
                }
            } //VSTACK
            .padding()
        } //SCROLLVIEW
    .navigationBarTitle("Widgets")
    }
}

struct WidgetsFAQ_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsFAQ()
    }
}
