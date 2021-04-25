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
                GroupBox(label: SettingsLabelView(labelText: "What's the deal with widgets?", labelImage: "questionmark.circle")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "I've released the widgets in beta format for now. They work, but there are a few bugs. If you fancy giving me feedback you can tweet at me @daveellisdev", useBlack: true)
                } //GROUPBOX
                GroupBox(label: SettingsLabelView(labelText: "My widget is saying no races", labelImage: "questionmark.circle")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "If the app says there are races, but the widget does not, leave the widget and it should sort itself soon.", useBlack: true)
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
