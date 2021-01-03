//
//  FAQView.swift
//  theracingline
//
//  Created by David Ellis on 02/01/2021.
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        VStack{
            GroupBox(label: SettingsLabelView(labelText: "Can I Request Series?", labelImage: "questionmark.circle")) {
                Divider().padding(.vertical, 4)
                SettingsDescriptionView(text: "Yes. Hit me up on Twitter @daveellisdev and I'll prioritise the requests")
            } //GROUPBOX
            GroupBox(label: SettingsLabelView(labelText: "Can I Request Features?", labelImage: "questionmark.circle")) {
                Divider().padding(.vertical, 4)
                SettingsDescriptionView(text: "Yes. Tweet or email me your ideas. I can't promise I'll be able to include every suggestion, but I'll do my best")
            } //GROUPBOX
            GroupBox(label: SettingsLabelView(labelText: "It seems expensive?", labelImage: "questionmark.circle")) {
                Divider().padding(.vertical, 4)
                SettingsDescriptionView(text: "TheRacingLine is not free to run, as I have server costs associated with hosting the data. However, I have tried to keep it as cheap as possible.")
            } //GROUPBOX
        }.padding()
    }
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}
