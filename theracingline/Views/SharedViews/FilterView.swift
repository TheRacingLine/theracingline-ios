//
//  FilterView.swift
//  theracingline-iOS
//
//  Created by David Ellis on 25/09/2021.
//

import SwiftUI
import SwiftDate

struct FilterView: View {
    
    @ObservedObject var data = DataController.shared
    @Environment(\.presentationMode) var presentationMode

    
    @State private var startDate = Date() - 1.weeks
    @State private var endDate = Date() + 2.years
    @State private var selectionStatDate = Date() - 1.weeks
    
    
    @State private var singleSeaterFilter = true
    @State private var sportsCarFilter = true
    @State private var touringCarFilter = true
    @State private var stockCarFilter = true
    @State private var rallyFilter = true
    @State private var bikeFilter = true
    @State private var otherSeriesFilter = true
        
    @State private var raceFilter = true
    @State private var qualifyingFilter = true
    @State private var practiceFilter = true

    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Text("Series Type")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                    
                    
                    // SAVE FILTER SETTINGS HERE
                    
                    data.setSingleSeaterFilter(setting: singleSeaterFilter)
                    data.setSportsCarFilter(setting: sportsCarFilter)
                    data.setTouringCarsFilter(setting: touringCarFilter)
                    data.setStockCarsFilter(setting: stockCarFilter)
                    data.setRallyFilter(setting: rallyFilter)
                    data.setBikesFilter(setting: bikeFilter)
                    data.setOtherFilter(setting: otherSeriesFilter)
                    
                    data.setRaceFilter(setting: raceFilter)
                    data.setQualifyingFilter(setting: qualifyingFilter)
                    data.setPracticeFilter(setting: practiceFilter)
                    
                    data.setFilterStartDate(date: setStartDate(date: startDate))
                    data.setFilterEndDate(date: setEndDate(date:endDate))
                    
                    data.saveFilterStringSettings()
                }.padding(.trailing, 10)
            } // HSTACK
            .padding(.top)
            .padding(.bottom, 5)
            VStack(alignment: .leading, spacing: 5) {

                HStack {
                    Toggle("Single Seater", isOn: $singleSeaterFilter)
                        .onChange(of: singleSeaterFilter, perform: { value in
                            if singleSeaterFilter {
                                data.setSingleSeaterFilter(setting: true)
                            } else {
                                data.setSingleSeaterFilter(setting: false)
                            } // IF ELSE
                            singleSeaterFilter = data.getSingleSeaterFilter()
                            data.saveFilterStringSettings()
                        }) // ONCHANGE
                        .onAppear {
                            singleSeaterFilter = data.getSingleSeaterFilter()
                        } // ONAPPEAR
                        .onTapGesture {
                            data.menuHaptics()
                        } // ONTAPGESTURE
                } // HSTACK FOR TOGGLE
                .padding(.horizontal, 5)
                .padding(.bottom, 2)
                HStack {
                    Toggle("Sportscars", isOn: $sportsCarFilter)
                        .onChange(of: sportsCarFilter, perform: { value in
                            if sportsCarFilter {
                                data.setSportsCarFilter(setting: true)
                            } else {
                                data.setSportsCarFilter(setting: false)
                            } // IF ELSE
                            sportsCarFilter = data.getSportsCarFilter()
                            data.saveFilterStringSettings()
                        }) // ONCHANGE
                        .onAppear {
                            sportsCarFilter = data.getSportsCarFilter()
                        } // ONAPPEAR
                        .onTapGesture {
                            data.menuHaptics()
                        } // ONTAPGESTURE
                } // HSTACK FOR TOGGLE
                .padding(.horizontal, 5)
                .padding(.bottom, 2)
                HStack {
                    Toggle("Touring Cars", isOn: $touringCarFilter)
                        .onChange(of: touringCarFilter, perform: { value in
                            if touringCarFilter {
                                data.setTouringCarsFilter(setting: true)
                            } else {
                                data.setTouringCarsFilter(setting: false)
                            } // IF ELSE
                            touringCarFilter = data.getTouringCarsFilter()
                            data.saveFilterStringSettings()
                        }) // ONCHANGE
                        .onAppear {
                            touringCarFilter = data.getTouringCarsFilter()
                        } // ONAPPEAR
                        .onTapGesture {
                            data.menuHaptics()
                        } // ONTAPGESTURE
                } // HSTACK FOR TOGGLE
                .padding(.horizontal, 5)
                .padding(.bottom, 2)
                HStack {
                    Toggle("Stock Cars", isOn: $stockCarFilter)
                        .onChange(of: stockCarFilter, perform: { value in
                            if stockCarFilter {
                                data.setStockCarsFilter(setting: true)
                            } else {
                                data.setStockCarsFilter(setting: false)
                            } // IF ELSE
                            stockCarFilter = data.getStockCarsFilter()
                            data.saveFilterStringSettings()
                        }) // ONCHANGE
                        .onAppear {
                            stockCarFilter = data.getStockCarsFilter()
                        } // ONAPPEAR
                        .onTapGesture {
                            data.menuHaptics()
                        } // ONTAPGESTURE
                } // HSTACK FOR TOGGLE
                .padding(.horizontal, 5)
                .padding(.bottom, 2)
                HStack {
                    Toggle("Rally", isOn: $rallyFilter)
                        .onChange(of: rallyFilter, perform: { value in
                            if rallyFilter {
                                data.setRallyFilter(setting: true)
                            } else {
                                data.setRallyFilter(setting: false)
                            } // IF ELSE
                            rallyFilter = data.getRallyFilter()
                            data.saveFilterStringSettings()
                        }) // ONCHANGE
                        .onAppear {
                            rallyFilter = data.getRallyFilter()
                        } // ONAPPEAR
                        .onTapGesture {
                            data.menuHaptics()
                        } // ONTAPGESTURE
                } // HSTACK FOR TOGGLE
                .padding(.horizontal, 5)
                .padding(.bottom, 2)
                HStack {
                    Toggle("Bikes", isOn: $bikeFilter)
                        .onChange(of: bikeFilter, perform: { value in
                            if bikeFilter {
                                data.setBikesFilter(setting: true)
                            } else {
                                data.setBikesFilter(setting: false)
                            } // IF ELSE
                            bikeFilter = data.getBikesFilter()
                            data.saveFilterStringSettings()
                        }) // ONCHANGE
                        .onAppear {
                            bikeFilter = data.getBikesFilter()
                        } // ONAPPEAR
                        .onTapGesture {
                            data.menuHaptics()
                        } // ONTAPGESTURE
                } // HSTACK FOR TOGGLE
                .padding(.horizontal, 5)
                .padding(.bottom, 2)
                HStack {
                    Toggle("Other Series", isOn: $otherSeriesFilter)
                        .onChange(of: otherSeriesFilter, perform: { value in
                            if otherSeriesFilter {
                                data.setOtherFilter(setting: true)
                            } else {
                                data.setOtherFilter(setting: false)
                            } // IF ELSE
                            otherSeriesFilter = data.getOtherFilter()
                            data.saveFilterStringSettings()
                        }) // ONCHANGE
                        .onAppear {
                            otherSeriesFilter = data.getOtherFilter()
                        } // ONAPPEAR
                        .onTapGesture {
                            data.menuHaptics()
                        } // ONTAPGESTURE
                } // HSTACK FOR TOGGLE
                .padding(.horizontal, 5)
                Divider()
            } // VSTACK
            VStack {
                HStack {
                    Text("Session Type")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                }
                HStack {
                    Toggle("Race", isOn: $raceFilter)
                        .onChange(of: raceFilter, perform: { value in
                            if raceFilter {
                                data.setRaceFilter(setting: true)
                            } else {
                                data.setRaceFilter(setting: false)
                            } // IF ELSE
                            raceFilter = data.getRaceFilter()
                        }) // ONCHANGE
                        .onAppear {
                            rallyFilter = data.getRaceFilter()
                        } // ONAPPEAR
                        .onTapGesture {
                            data.menuHaptics()
                        } // ONTAPGESTURE
                } // HSTACK FOR TOGGLE
                .padding(.horizontal, 5)
                HStack {
                    Toggle("Qualifying", isOn: $qualifyingFilter)
                        .onChange(of: qualifyingFilter, perform: { value in
                            if qualifyingFilter {
                                data.setQualifyingFilter(setting: true)
                            } else {
                                data.setQualifyingFilter(setting: false)
                            } // IF ELSE
                            qualifyingFilter = data.getQualifyingFilter()
                        }) // ONCHANGE
                        .onAppear {
                            qualifyingFilter = data.getQualifyingFilter()
                        } // ONAPPEAR
                        .onTapGesture {
                            data.menuHaptics()
                        } // ONTAPGESTURE
                } // HSTACK FOR TOGGLE
                .padding(.horizontal, 5)
                HStack {
                    Toggle("Practice", isOn: $practiceFilter)
                        .onChange(of: practiceFilter, perform: { value in
                            if practiceFilter {
                                data.setPracticeFilter(setting: true)
                            } else {
                                data.setPracticeFilter(setting: false)
                            } // IF ELSE
                            practiceFilter = data.getPracticeFilter()
                        }) // ONCHANGE
                        .onAppear {
                            practiceFilter = data.getPracticeFilter()
                        } // ONAPPEAR
                        .onTapGesture {
                            data.menuHaptics()
                        } // ONTAPGESTURE
                } // HSTACK FOR TOGGLE
                .padding(.horizontal, 5)
                Divider()
            }
            VStack {
                HStack {
                    Text("Between Dates")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.bottom, 5)
                DatePicker(selection: $startDate, in: selectionStatDate..., displayedComponents: .date){
                    Text("Start Date")
                }.padding(.bottom, 0).id(startDate)
                DatePicker(selection: $endDate, in: selectionStatDate..., displayedComponents: .date){
                        Text("End Date")
                }.padding(.bottom, 0).id(endDate)
                Divider()
            }.padding(.bottom)
            Button {
                // reset filter
                resetFilter()
            } label: {
                Text("Reset Filter")
                    .foregroundColor(.red)
                    
            }.padding(.bottom)

        }.padding(.horizontal)
            .padding(.vertical, 2)
            .onAppear(){
                self.singleSeaterFilter = data.getSingleSeaterFilter()
                self.raceFilter = data.getRaceFilter()
                self.startDate = data.getFilterStartDate()
                self.endDate = data.getFilterEndDate()
            }
    }
    
    func resetFilter() {
        singleSeaterFilter = true
        sportsCarFilter = true
        touringCarFilter = true
        stockCarFilter = true
        rallyFilter = true
        bikeFilter = true
        otherSeriesFilter =  true
        raceFilter = true
        qualifyingFilter = true
        practiceFilter = true
        startDate = setStartDate(date: Date())
        endDate = setEndDate(date:Date() + 2.years)
    }
    
    func setStartDate(date: Date) -> Date {
        
        let seconds = TimeZone.current.secondsFromGMT()
        let minutesToGMT = (seconds / 60) + (seconds % 60)
        
        let midnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)! + minutesToGMT.minutes
        
        return midnight
    }
    
    func setEndDate(date: Date) -> Date {
        
        let seconds = TimeZone.current.secondsFromGMT()
        let minutesToGMT = (seconds / 60) + (seconds % 60)
        
        let almostMidnight = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)! // + minutesToGMT.minutes
//        let fourAM = almostMidnight + 4.hours + 30.minutes
        
        return almostMidnight
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}


