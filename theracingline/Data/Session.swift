//
//  Session.swift
//  theracingline
//
//  Created by David Ellis on 12/11/2020.
//

import Foundation
import SwiftDate

class Session: ObservableObject, Identifiable, Codable, Equatable {
    var id = UUID().uuidString
    var series = ""
    var accessLevel = 0
    var darkR = 0.0
    var darkG = 0.0
    var darkB = 0.0
    var lightR = 0.0
    var lightG = 0.0
    var lightB = 0.0
    var seriesType = ""
    var event = 0
    var circuit = ""
    var sessionName = ""
    var sessionType = "R"
    var roundNumber = 1
    var durationType = "L"
    var duration = 1
    var date = Date()
    var tba = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case series
        case accessLevel
        case darkR
        case darkG
        case darkB
        case lightR
        case lightG
        case lightB
        case seriesType
        case event
        case circuit
        case sessionName
        case sessionType
        case roundNumber
        case durationType
        case duration
        case date
        case tba
    }
    
    static func ==(lhs: Session, rhs: Session) -> Bool {
        return lhs.id == rhs.id && lhs.series == rhs.series && lhs.accessLevel == rhs.accessLevel && lhs.darkR == rhs.darkR && lhs.darkG == rhs.darkG && lhs.darkB == rhs.darkB && lhs.lightR == rhs.lightR && lhs.lightG == rhs.lightG && lhs.lightB == rhs.lightB && lhs.event == rhs.event && lhs.circuit == rhs.circuit && lhs.sessionName == rhs.sessionName && lhs.sessionType == rhs.sessionType && lhs.roundNumber == rhs.roundNumber && lhs.durationType == rhs.durationType && lhs.duration == rhs.duration && lhs.date == rhs.date && lhs.seriesType == rhs.seriesType && lhs.tba == rhs.tba
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: CodingKeys.id)
        try container.encode(series, forKey: CodingKeys.series)
        try container.encode(accessLevel, forKey: CodingKeys.accessLevel)
        try container.encode(darkR, forKey: CodingKeys.darkR)
        try container.encode(darkG, forKey: CodingKeys.darkG)
        try container.encode(darkB, forKey: CodingKeys.darkB)
        try container.encode(lightR, forKey: CodingKeys.lightR)
        try container.encode(lightG, forKey: CodingKeys.lightG)
        try container.encode(lightB, forKey: CodingKeys.lightB)
        try container.encode(seriesType, forKey: CodingKeys.seriesType)
        try container.encode(event, forKey: CodingKeys.event)
        try container.encode(circuit, forKey: CodingKeys.circuit)
        try container.encode(sessionName, forKey: CodingKeys.sessionName)
        try container.encode(sessionType, forKey: CodingKeys.sessionType)
        try container.encode(roundNumber, forKey: CodingKeys.roundNumber)
        try container.encode(durationType, forKey: CodingKeys.durationType)
        try container.encode(duration, forKey: CodingKeys.duration)
        try container.encode(date, forKey: CodingKeys.date)
        try container.encode(tba, forKey: CodingKeys.tba)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        series = try values.decode(String.self, forKey: .series)
        accessLevel = try values.decode(Int.self, forKey: .accessLevel)
        darkR = try values.decode(Double.self, forKey: .darkR)
        darkG = try values.decode(Double.self, forKey: .darkG)
        darkB = try values.decode(Double.self, forKey: .darkB)
        lightR = try values.decode(Double.self, forKey: .lightR)
        lightG = try values.decode(Double.self, forKey: .lightG)
        lightB = try values.decode(Double.self, forKey: .lightB)
        seriesType = try values.decode(String.self, forKey: .seriesType)
        event = try values.decode(Int.self, forKey: .event)
        circuit = try values.decode(String.self, forKey: .circuit)
        sessionName = try values.decode(String.self, forKey: .sessionName)
        sessionType = try values.decode(String.self, forKey: .sessionType)
        roundNumber = try values.decode(Int.self, forKey: .roundNumber)
        durationType = try values.decode(String.self, forKey: .durationType)
        duration = try values.decode(Int.self, forKey: .duration)
        date = try values.decode(Date.self, forKey: .date)
        tba = try values.decode(Bool.self, forKey: .tba)
    }
    
    init() {
        
    }
    
    func dateAsString() -> String {
        let formatter = DateFormatter()
        if date.compare(.isThisYear) {
            formatter.dateFormat = "MMM d"
        } else {
            formatter.dateFormat = "MMM d yyyy"
        }
        
        return formatter.string(from: date)
    }
    
    func timeAsString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: date)
    }
    
    func timeFromNow() -> String {
        return date.toRelative()
    }
    
    func getDurationText() -> String {
        var durationIsMinutes: Bool
        var text: String
        
        if duration < 60 {
            durationIsMinutes = true
        } else {
            durationIsMinutes = false
        }
        
        if durationIsMinutes {
            text = "\(duration) Minutes"
        } else {
            
            if duration % 60 == 0{
                if duration / 60 == 1 {
                    text = "\(Int(floor(Double(duration)/60))) Hour"
                } else {
                    text = "\(Int(floor(Double(duration)/60))) Hours"
                }
            } else {
                let hours = Int(floor(Double(duration)/60))
                let minutes = duration % 60
                
                if hours == 1 {
                    text = "\(Int(floor(Double(duration)/60))) Hour \(minutes) Minutes"
                } else {
                    text = "\(Int(floor(Double(duration)/60))) Hours \(minutes) Minutes"
                }
            }
        }
        
        return text
    }
    
    func day() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfTheWeekString = dateFormatter.string(from: date)
        
        return dayOfTheWeekString
//        let calendar = Calendar.current
//        let day = calendar.component(.day, from: date)
//
//        switch day {
//        case 1:
//            return "Sunday"
//        case 2:
//            return "Monday"
//        case 3:
//            return "Tuesday"
//        case 4:
//            return "Wednesday"
//        case 5:
//            return "Thursday"
//        case 6:
//            return "Friday"
//        case 7:
//            return "Saturdayday"
//        default:
//            return "Day Error"
//        }
    }
    
    
}

var testSession1: Session {
    let session = Session()

    session.series = "Formula 1"
    session.accessLevel = 0
    session.darkR = 255.0
    session.darkG = 121.0
    session.darkB = 31.0
    session.lightR = 121.0
    session.lightG = 153.0
    session.lightB = 153.0
    session.seriesType = "Single Seater"
    session.event = 14
    session.circuit = "Istanbul"
    session.sessionName = "Race"
    session.sessionType = "R"
    session.roundNumber = 14
    session.durationType = "L"
    session.duration = 58
    session.date = Date() + 3.days
    session.tba = false

    return session
}

var testSession2: Session {
    let session = Session()

    session.series = "Formula 1"
    session.accessLevel = 0
    session.darkR = 147.0
    session.darkG = 41.0
    session.darkB = 30.0
    session.lightR = 237.0
    session.lightG = 33.0
    session.lightB = 58.0
    session.seriesType = "Single Seater"
    session.event = 15
    session.circuit = "Bahrain GP"
    session.sessionName = "Race"
    session.sessionType = "R"
    session.roundNumber = 15
    session.durationType = "L"
    session.duration = 61
    session.date = Date() + 10.days
    session.tba = true

    return session
}

var testSession3: Session {
    let session = Session()

    session.series = "FIA WEC"
    session.accessLevel = 1
    session.darkR = 147.0
    session.darkG = 41.0
    session.darkB = 30.0
    session.lightR = 237.0
    session.lightG = 33.0
    session.lightB = 58.0
    session.seriesType = "Sportscars"
    session.event = 8
    session.circuit = "Bahrain"
    session.sessionName = "Race"
    session.sessionType = "R"
    session.roundNumber = 8
    session.durationType = "T"
    session.duration = 480
    session.date = Date() + 2.days
    session.tba = false

    return session
}

var testSession4: Session {
    let session = Session()

    session.series = "Formula 2"
    session.accessLevel = 2
    session.darkR = 147.0
    session.darkG = 41.0
    session.darkB = 30.0
    session.lightR = 237.0
    session.lightG = 33.0
    session.lightB = 58.0
    session.seriesType = "Single Seater"
    session.event = 10
    session.circuit = "Knockhill"
    session.sessionName = "Race"
    session.sessionType = "R"
    session.roundNumber = 10
    session.durationType = "L"
    session.duration = 57
    session.date = Date()
    session.tba = false

    return session
}
