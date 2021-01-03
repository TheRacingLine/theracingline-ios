//
//  SeriesListView.swift
//  theracingline
//
//  Created by David Ellis on 13/11/2020.
//

import SwiftUI

struct SeriesListView: View {
    
    @ObservedObject var data = DataController.shared
    
    var sessions: [Session]
    var seriesList: [String]
    var noSeriesText: String
    
    var body: some View {
//        ScrollView {
            List {
                if seriesList.count == 0 {
                    Text(noSeriesText)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.top, 50)
                        .padding(.horizontal, 20)
                } else {
                    
                    ForEach(seriesList, id: \.self) { seriesName in
                        let seriesAllSessions = seriesSessions(seriesName: seriesName, sessionsList: sessions)
                        if seriesAllSessions.count > 0 {
                            NavigationLink(destination: SeriesSessionListView(sessions: seriesAllSessions, noSessionText: "No Sessions")) {
                                SeriesRowView(seriesSessions: seriesAllSessions)
                            }
                        }
                    } // FOREACH
                    
                    if data.visibleSeries.count == 0 {
                        HStack{
                            Spacer()
                            Text("No Visible Series. Check The Settings.")
                            Spacer()
                        }
                    }
                } // IFELSE
            } // VSTACK
//        } // SCROLLVIEW
    } // BODY
    
    func seriesSessions(seriesName: String, sessionsList: [Session]) -> [Session] {
        
        return sessionsList.filter { $0.series == seriesName && $0.accessLevel <= data.userAccessLevel }.sorted { $0.date < $1.date }
    }
}

struct SeriesListView_Previews: PreviewProvider {
    
    @ObservedObject var data = DataController.shared

    static var previews: some View {
        SeriesListView(sessions: [testSession1, testSession2, testSession3, testSession4], seriesList: ["Formula 1", "Formula 2", "FIA WEC"], noSeriesText: "No Series Found")
        
    }
}
