//
//  ConfigurationSeriesRowView.swift
//  theracingline
//
//  Created by David Ellis on 30/11/2020.
//

import SwiftUI

struct ConfigurationSeriesRowView: View {
    
    @ObservedObject var data = DataController.shared
    
    var seriesName: String
    
    @State private var seriesVisible = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5){
            HStack {
                Toggle(seriesName, isOn: $seriesVisible)
                    .onChange(of: seriesVisible) { value in
                        if seriesVisible {
                            if !data.visibleSeries.contains(seriesName) {
                                data.visibleSeries.append(seriesName)
                                print(data.visibleSeries)
                            }
                        } else if !seriesVisible {
                            while data.visibleSeries.contains(seriesName) {
                                let index = data.visibleSeries.firstIndex(of: seriesName)
                                data.visibleSeries.remove(at: index!)
                                data.seriesWithNotifications.remove(at: index!)
                                print(data.visibleSeries)
                            }
                        }
                        data.setVisibleSeriesPreferences()
                    } // TOGGLE
                    .onChange(of: data.visibleSeries, perform: { value in
                        checkIfSeriesVisible()
                    })
                .onAppear {
                    checkIfSeriesVisible()
                } //ONAPPEAR
                .onTapGesture {
                    data.menuHaptics()
                }
            } //HSTACK
        } //VSTACK
    }
    
    func checkIfSeriesVisible(){
        if data.visibleSeries.contains(seriesName){
            seriesVisible = true
        } else {
            seriesVisible = false
        }
    }
}

struct ConfigurationSeriesRowView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationSeriesRowView(seriesName: "Formula 1")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
