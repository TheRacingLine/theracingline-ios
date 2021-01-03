//
//  theracinglineOnboarding.swift
//  theracingline
//
//  Created by David Ellis on 24/11/2020.
//

import SwiftUI
import Network

struct theracinglineOnboarding: View {
        
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State private var showingAlert = false


    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 10) {
                // SERIES IMAGES
                Image("tRL-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height: 320)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 8, x: 6, y: 8)

                // DESCRIPTION
                HStack(alignment: .center) {
                    Text("Calendars".uppercased()).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Image(systemName: "calendar")
                }.padding(.horizontal, 40)
                .foregroundColor(Color.white)
                .frame(width: 320)
                
                HStack(alignment: .center) {
                    Text("Race Times".uppercased()).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Image(systemName: "clock")
                }.padding(.horizontal, 40)
                .foregroundColor(Color.white)
                .frame(width: 320)
                
                HStack(alignment: .center) {
                    Text("Notifications".uppercased()).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Image(systemName: "app.badge")
                }.padding(.horizontal, 40)
                .foregroundColor(Color.white)
                .frame(width: 320)
                
                HStack(alignment: .center) {
                    Text("More coming soon...".uppercased()).font(.footnote).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }.padding(.horizontal, 40)
                .padding(.vertical, 20)
                .foregroundColor(Color.white)
                // BUTTON
                
                    Button(action: {
                                                
                        if Reachability.isConnectedToNetwork() {
                            isOnboarding = false
                            DataController.shared.initiliseVisibleSeries()
                            DataController.shared.menuHaptics()
                        } else {
                            self.showingAlert = true
                        }
                    }) {
                    HStack(spacing: 8) {
                        Text("Get Started")

                        Image(systemName: "arrow.right.circle")
                            .imageScale(.large)
                    }.foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule().strokeBorder(Color.white, lineWidth: 1.25)
                            
                    ).accentColor(Color.white)
                    .padding(.vertical, 20)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Requires Internet Connection"), message: Text("theRacingLine requires an internet connection to download the latest race data. Please ensure you are online, and that the app has access to the Wifi or Mobile/Cellular data connection and try again."), dismissButton: .default(Text("Ok")))
                    }
                }

            } // VSTACK
        }// ZSTACK
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: [Color("ColortRLLight"), Color("ColortRLDark")]), startPoint: .top, endPoint: .bottom))
//        .padding(.horizontal, 20)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct theracinglineOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        theracinglineOnboarding()
    }
}
