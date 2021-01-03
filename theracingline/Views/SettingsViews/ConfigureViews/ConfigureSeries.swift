//
//  ConfigureSeries.swift
//  theracingline
//
//  Created by David Ellis on 15/11/2020.
//

import SwiftUI

struct ConfigureSeries: View {
    
    @ObservedObject var data = DataController.shared


    var body: some View {
        
        List {
            
            HStack {
                Spacer()
                
                Button(action: {
                    data.selectAllVisibleSeries()
                    data.menuHaptics()
                }) {
                    Text("Select All")
                }.buttonStyle(BorderlessButtonStyle())
                
                Spacer()

                Button(action: {
                    data.selectNoneVisibileSeries()
                    data.menuHaptics()
                }) {
                    Text("Select None")
                }.buttonStyle(BorderlessButtonStyle())
                
                
                Spacer()
            }
            ForEach(data.seriesList, id: \.self) { seriesName in
                if getSeriesAccessLevel(seriesName: seriesName) <= data.userAccessLevel {
                    ConfigurationSeriesRowView(seriesName: seriesName)
                }
            }
        } // LIST
        .navigationBarTitle("Visible Series")
    } // BODY
    
    func getSeriesAccessLevel(seriesName: String) -> Int {
        
        let seriesSessions = data.sessions.filter {$0.series == seriesName }
        
        if seriesSessions.count == 0 {
            return 4
        } else {
            return seriesSessions[0].accessLevel
        }
    }
}

struct ConfigureSeries_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureSeries()
    }
}
