//
//  SubscriptionLevelList.swift
//  theracingline
//
//  Created by David Ellis on 15/11/2020.
//

import SwiftUI

struct SubscriptionLevelList: View {
    
    var text: String
    var list: [String]
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack{
                Text(text)
                    
                Spacer()
            }
            ForEach(list, id: \.self) { listItem in
                HStack {
                    Text("• \(listItem)")
                    Spacer()
                }
            }
        }
        .font(.footnote)
    }
}

struct SubscriptionLevelList_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionLevelList(text: "Race dates for:", list: ["F1", "FIA WEC", "IndyCar"])
    }
}
