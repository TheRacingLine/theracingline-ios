//
//  SettingsDescriptionView.swift
//  theracingline
//
//  Created by David Ellis on 15/11/2020.
//

import SwiftUI

struct SettingsDescriptionView: View {
    
    var text: String
    var useBlack: Bool?
    
    var body: some View {
        
        if useBlack != nil {
            HStack(alignment: .center, spacing: 5) {
                Text(text)
                    .lineLimit(nil)
                    .font(.footnote)
                Spacer()
            }
        } else {
            HStack(alignment: .center, spacing: 5) {
                Text(text)
                    .lineLimit(nil)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                Spacer()
            }
        }
    }
}

struct SettingsDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsDescriptionView(text: "Select which series you would like to display in your lists and which series you'd like to receive push notifications for.dfgvergergerergergergergergwerafwagwe4rgserg ergergerger aergervregr ergreer ergergergerg ergergergreaerg ergergergre ergereragre ergergera ergregeargg")
        

    }
}
