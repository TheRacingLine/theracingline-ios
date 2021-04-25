//
//  FAQView.swift
//  theracingline
//
//  Created by David Ellis on 02/01/2021.
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        ScrollView{
            VStack{
                GroupBox(label: SettingsLabelView(labelText: "Can I Request Series?", labelImage: "questionmark.circle")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "Yes! Hit me up on Twitter @daveellisdev and I'll prioritise the requests.", useBlack: true)
                } //GROUPBOX
                GroupBox(label: SettingsLabelView(labelText: "Can I Request Features?", labelImage: "questionmark.circle")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "Yes! Tweet or email me your ideas. I can't promise I'll be able to include every suggestion, but I'll do my best.", useBlack: true)
                } //GROUPBOX
//                GroupBox(label: SettingsLabelView(labelText: "It seems expensive?", labelImage: "questionmark.circle")) {
//                    Divider().padding(.vertical, 4)
//                    SettingsDescriptionView(text: "TheRacingLine is not free to run, as I have server costs associated with hosting the data. However, I have tried to keep it as cheap as possible.", useBlack: true)
//                } //GROUPBOX
                GroupBox(label: SettingsLabelView(labelText: "Why so many TBAs?", labelImage: "questionmark.circle")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "Many race start times are not published until closer to the event. I include start times as soon as the organisers have published them.", useBlack: true)
                } //GROUPBOX
                GroupBox(label: SettingsLabelView(labelText: "Why are some start times not correct?", labelImage: "questionmark.circle")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "For events such as NASCAR green flag times are often not published, but TV times are. When there is no clear green flag time, I will use the TV time.", useBlack: true).lineLimit(nil)
                } //GROUPBOX
                GroupBox(label: SettingsLabelView(labelText: "Why no rally stage times?", labelImage: "questionmark.circle")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "Unfortunately the amount of work required to do this is too high at the moment. I may re-evaluate this as time goes on.", useBlack: true)
                } //GROUPBOX
            } //VSTACK
            .padding()
        } //SCROLLVIEW
        .navigationBarTitle("FAQ")
    } //BODY
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}
