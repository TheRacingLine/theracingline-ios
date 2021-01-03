//
//  SettingsRowView.swift
//  theracingline
//
//  Created by David Ellis on 14/11/2020.
//

import SwiftUI

struct SettingsRowView: View {
    
    var content: String
    var symbol: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            HStack {
                Text(content)
                    .foregroundColor(Color("MenuColor"))
                Spacer()
                if symbol != nil {
                    Image(systemName: symbol!)
                    .foregroundColor(.gray)
                    .font(.caption)
                }
            }
            
        }
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(content: "Beta Settings", symbol: "chevron.right")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
