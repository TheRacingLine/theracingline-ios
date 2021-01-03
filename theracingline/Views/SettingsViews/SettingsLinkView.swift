//
//  SettingsLinkView.swift
//  theracingline
//
//  Created by David Ellis on 15/11/2020.
//

import SwiftUI


struct SettingsLinkView: View {
    
    var content: String
    var symbol: String
    var linkDestination: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            HStack {
                Link(content, destination: URL(string: "https://\(linkDestination)")!)
                Spacer()
                Image(systemName: symbol)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct SettingsLinkView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLinkView(content: "theRacingLine.net", symbol: "chevron.right", linkDestination: "theracingline.net")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
