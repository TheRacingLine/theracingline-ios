//
//  SessionListView.swift
//  theracingline
//
//  Created by David Ellis on 12/11/2020.
//

import SwiftUI
import SwiftDate

struct SessionListView: View {
    
    @ObservedObject var data = DataController.shared
    @StateObject var storeManager: StoreManager
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var showingFilterSheet = false
    
    var sessions: [Session]
    var noSessionText: String
    
    var body: some View {
        ScrollView {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")

                    TextField("Search circuit", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: {
                        print("onCommit")
                    }).foregroundColor(.primary)

                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)

                if showCancelButton  {
                    Button("Cancel") {
                            UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                            self.searchText = ""
                            self.showCancelButton = false
                    }
                    .foregroundColor(Color(.systemBlue))
                }
                
                Button(action: {
                    showingFilterSheet.toggle()
                }) {
                    if filtersApplied() {
                        ZStack{
                            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                .font(.system(size: 26))
                                .foregroundColor(.blue)
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                                .padding(.bottom)
                                .padding(.leading)
                        }
                        
                    } else {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .font(.system(size: 26))
                            .foregroundColor(.blue)
                    }
                    
                }.sheet(isPresented: $showingFilterSheet){
                    FilterView()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 2)
            .padding(.top, 8)
//            .navigationBarHidden(showCancelButton)
//            .animation(.default) // animation does not work properly
            
            LazyVStack {
                if sessions.count == 0{
                    HStack {
                        Spacer()
                        Text("😔")
                            .font(.title)
                            .padding(.top)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text(noSessionText)
                            .bold()
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    ForEach(sessions.filter { $0.circuit.lowercased().contains(searchText.lowercased()) || $0.circuit.lowercased().hasPrefix(searchText.lowercased()) })
                    { session in
                        if data.userAccessLevel >= session.accessLevel {
                            HStack {
                                SessionRowView(session: session)
                            }.padding(.horizontal, 15)
                        }
                    } // FOREACH
                } // IFELSE
                
                if data.userAccessLevel < 3 {
                    MoreSeriesButton(storeManager: storeManager, buttonText: "More Details")
                }
            } // VSTACK
//            .navigationBarTitle(Text("Search"))
            .resignKeyboardOnDragGesture()
        } // SCROLL
    }
    
    func includeSession(session: Session) -> Bool {
        
        var showSession = false
        let searchTextArray = searchArray(searchString: searchText)
        
        // if search array contains one word
        if searchTextArray.count <= 1 {
            // if text appears in any circuit or series return true
            if searchTextArray.contains(where: session.circuit.lowercased().contains) || searchTextArray.contains(where: session.series.lowercased().contains) || searchTextArray.contains(where: session.sessionName.lowercased().contains) || searchText == "" {
                showSession = true
            }
        
        // if search array contains more than one word
        } else {
            // if ALL words appear in any circut or series return true

            print("")
        }
        
 
        return showSession
    }
    
    func searchArray(searchString: String) -> [String] {
        
        // split into array
        let searchArray = searchString.lowercased().components(separatedBy: " ")
        
        // remove duplicates in array
        return Array(Set(searchArray))
    }
    
    func filtersApplied() -> Bool {
        if data.filterSeriesSingleSeater == true && data.filterSeriesSportsCar == true && data.filterSeriesTouringCars == true && data.filterSeriesStockCars == true && data.filterSeriesRally == true && data.filterSeriesBikes == true && data.filterSeriesOther == true && data.filterSessionRace == true && data.filterSessionQualifying == true && data.filterSessionPractice == true && data.filterStartDate <= Date() && data.filterEndDate > Date() + 6.months {
            //
            return false
        } else {
            return true
        }
    }
    
    
}

struct SessionListView_Previews: PreviewProvider {
    static var previews: some View {
        SessionListView(storeManager: StoreManager(), sessions: [], noSessionText: "No Sessions today.")
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
