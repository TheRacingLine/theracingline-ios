//
//  InfoView.swift
//  TheRacingLineWatch Extension
//
//  Created by David Ellis on 06/04/2021.
//

import SwiftUI

struct InfoView: View {
    
    var navTitle: String

    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                        .frame(width: .infinity)
                    VStack {
                        HStack {
                            Spacer()
                            Text("Remember to open the iPhone app every-so-often to get the most up to date race data.")
                            Spacer()
                        } //.padding()
                    }.padding()
                } //SYNC DATE ZSTACK
            } // VSTACK
        } // SCROLLVIEW
        .navigationBarTitle(Text(navTitle))
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(navTitle: "Info")
    }
}
