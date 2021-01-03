//
//  AdView.swift
//  theracingline
//
//  Created by David Ellis on 30/11/2020.
//

import SwiftUI

struct AdView: View {
    
    var advert: Ad
    
    var body: some View {
        
        Link(destination: URL(string: advert.link)!, label: {
            ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .opacity(0.3)
                }
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.clear)
                            .background(LinearGradient(gradient: Gradient(colors: [Color("ColortRLLight"), Color("ColortRLDark")]), startPoint: .top, endPoint: .bottom))
                        Text("AD")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                    }
                    .frame(width: 45, height: 45)
                    .cornerRadius(10)
                    .padding(.horizontal, 5)
                    VStack {
                        HStack {
                            Text(advert.title)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(/*@START_MENU_TOKEN@*/Color("MenuColor")/*@END_MENU_TOKEN@*/)
                            Spacer()
                        } //HSTACK
                        HStack {
                            Text(advert.subtitle)
                                .font(.caption2)
                                .foregroundColor(/*@START_MENU_TOKEN@*/Color("MenuColor")/*@END_MENU_TOKEN@*/)
                            Spacer()
                        } //HSTACK
                    } //VSTACK
                    Spacer()
                } //HSTACK
            } //ZSTACK
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        })
    }
}

struct AdView_Previews: PreviewProvider {
    static var previews: some View {
        AdView(advert: testAd)
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
