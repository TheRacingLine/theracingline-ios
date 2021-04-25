//
//  widgetNoRaces.swift
//  theracingline-widgetExtension
//
//  Created by David Ellis on 24/02/2021.
//

import SwiftUI

struct widgetNoRaces: View {
    var body: some View {
        Spacer()
        Text("No more events this week. Check the app for next week's races.")
            .font(.system(size: 10))
        Spacer()
    }
}

struct widgetNoRaces_Previews: PreviewProvider {
    static var previews: some View {
        widgetNoRaces()
    }
}
