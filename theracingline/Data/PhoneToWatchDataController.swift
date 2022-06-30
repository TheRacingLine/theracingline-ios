//
//  PhoneToWatchDataController.swift
//  TheRacingLineWatch Extension
//
//  Created by David Ellis on 04/04/2021.
//

import Foundation
import WatchConnectivity
import SwiftUI


class PhoneToWatchDataController: NSObject, WCSessionDelegate {
    
    static var shared = PhoneToWatchDataController()
    @ObservedObject var dataCont = DataController.shared
    
    var wcSession: WCSession?
    
    func setupWCSession() {
        if WCSession.isSupported() {
            wcSession = WCSession.default
            wcSession?.delegate = self
            wcSession?.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            print("Activated")
        default:
            print("Not able to talk to watch :(")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Now inactive :(")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Did deactive :(")
    }
    
    func sendContext(context: [String:Any]){
        try? wcSession?.updateApplicationContext(context)
    }
    
    func convertSessionsToContext(sessions: [Session]) -> [String:Any] {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(sessions){
            return ["sessions":encoded]
        }
        return ["failed":0]
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any ]) -> Void) {
                    
        if let defaults = UserDefaults(suiteName: "group.dev.daveellis.theracingline") {
            if let data = defaults.data(forKey: "sessions"){
                let decoder = JSONDecoder()
                if let jsonSessions = try? decoder.decode([Session].self, from: data) {
                    
                   
                    if(dataCont.userAccessLevel < 3) {
                        jsonSessions.forEach { session in
                            session.accessLevel = -1
                        }
                    }
                    
                    DispatchQueue.main.async{
                        replyHandler(self.convertSessionsToContext(sessions: jsonSessions.filter { self.dataCont.visibleSeries.contains($0.series) }))
                    }
                }
            }
        }
        
    }
}
