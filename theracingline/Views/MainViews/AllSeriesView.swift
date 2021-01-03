//
//  AllSeriesView.swift
//  theracingline
//
//  Created by David Ellis on 13/11/2020.
//

import SwiftUI

struct AllSeriesView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        SeriesListView(sessions: data.allSessions, seriesList: data.seriesList, noSeriesText: "No Series")
            .navigationTitle("All Series")
    }
}

struct AllSeriesView_Previews: PreviewProvider {
    static var previews: some View {
        AllSeriesView()
    }
}
