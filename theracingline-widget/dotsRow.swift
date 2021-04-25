//
//  dotsRow.swift
//  theracingline-widgetExtension
//
//  Created by David Ellis on 24/02/2021.
//

import SwiftUI

struct dotsRow: View {
    
    @Environment(\.widgetFamily) private var widgetFamily
    var sessions: [Session]
    var maxVisible: Int
    var maxDots: Int

    var body: some View {

        if sessions.count > maxVisible {

            // number of additional races to be displayed in the dots
            let count = sessions.count - maxVisible

            HStack {
                Text("+\(count)")
                    .font(.system(size: 10))

                // for each race that could not be displayed in full
                ForEach(Array(sessions.enumerated()), id: \.1) { i, element in

                    // set
                    if i >= maxVisible {
                        if ((i < maxDots && widgetFamily == .systemSmall) || (i < maxDots && widgetFamily != .systemSmall)) {
                            let gradientStart = Color(red: element.darkR / 255, green: element.darkG / 255, blue: element.darkB / 255)
                            let gradientEnd = Color(red: element.lightR / 255, green: element.lightG / 255, blue: element.lightB / 255)
                            Circle()
                                .fill(LinearGradient(
                                      gradient: .init(colors: [gradientStart, gradientEnd]),
                                      startPoint: .init(x: 0.5, y: 0),
                                      endPoint: .init(x: 0.5, y: 0.6)
                                    ))
                                .frame(width: 8, height: 8)
                        }
                    }
                } // FOREACH FOR LIST
                Spacer()
            } // HSTACK
        } // DOTS
    }
}
//
//struct dotsRow_Previews: PreviewProvider {
//    static var previews: some View {
//dotsRow(sessions: <#[Session]#>, maxVisible: <#Int#>, maxDots: <#Int#>)
//    }
//}
