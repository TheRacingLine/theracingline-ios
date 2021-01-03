//
//  MoreSeriesButton.swift
//  theracingline
//
//  Created by David Ellis on 24/11/2020.
//

import SwiftUI

struct MoreSeriesButton: View {
    
    @StateObject var storeManager: StoreManager
    var buttonText: String
    
    var body: some View {
        
        NavigationLink(
            destination: SubscriptionLevelView(storeManager: storeManager)) {
            HStack(spacing: 8) {
                Text(buttonText)

                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
            }.foregroundColor(.blue)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule().strokeBorder(Color.blue, lineWidth: 1.25)
                    
            ).accentColor(Color.white)
            .padding(.vertical, 20)
        }
    }
}

struct MoreSeriesButton_Previews: PreviewProvider {
    static var previews: some View {
        MoreSeriesButton(storeManager: StoreManager(), buttonText: "More Series")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
