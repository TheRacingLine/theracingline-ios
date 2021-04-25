//
//  Session.swift
//  theracingline
//
//  Created by David Ellis on 12/11/2020.
//

import Foundation
import SwiftDate

class Session: ObservableObject, Identifiable, Codable, Equatable, Hashable {
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
        
        return self.date.toRelative()
        
//        let currentDateTime = Date()
//        let raceDayMidnight = Calendar.current.date(bySettingHour: 9, minute: 30, second: 0, of: self.date)!
//
//        let diffMinuteComponents = Calendar.current.dateComponents([.minute], from: currentDateTime, to: self.date)
//        let diffMinutes = diffMinuteComponents.minute
//
//        let diffHourComponents = Calendar.current.dateComponents([.hour], from: currentDateTime, to: self.date)
//        let diffHour = diffHourComponents.hour
//
//        let diffDayComponents = Calendar.current.dateComponents([.day], from: currentDateTime, to: raceDayMidnight)
//        let diffDay = diffDayComponents.day
//
//        let diffMonthComponents = Calendar.current.dateComponents([.month], from: currentDateTime, to: self.date)
//        let diffMonth = diffMonthComponents.month
//
//        let diffYearComponents = Calendar.current.dateComponents([.year], from: currentDateTime, to: self.date)
//        let diffYear = diffYearComponents.year
//
//
//        if diffHour! <= 0 {
//            // less than 1 hour, show minutes
//
//            if diffMinutes! <= 0 {
//                // less than 1 minute, show started
//                return ("started")
//            } else if diffMinutes! == 1 {
//                return "in \(diffMinutes!) minute"
//            }
//            return "in \(diffMinutes!) minutes"
//
//        } else if diffDay! <= 0 {
//            //less than 1 day, show hours
//            if diffHour! == 1 {
//                return "in \(diffHour!) hour"
//            }
//            return "in \(diffHour!) hours"
//        } else if diffDay! < 14 {
//            // less than 2 weeks, show days
//            if diffDay! == 1 {
//                return "tomorrow"
//            } else {
//
//                return "in \(diffDay!) days"
//            }
//        } else if diffMonth! <= 0 {
//            // less than 1 month, show weeks
//            let weeks = diffDay! / 7
//            return "in \(weeks) weeks"
//        } else if diffYear == 0 {
//            // less than 1 year, show months
//            if diffMonth! == 1 {
//                return "next month"
//            } else {
//                return "in \(diffMonth!) months"
//            }
//        } else if diffYear! > 1 {
//            return "next year"
//        }
//
//        return " "
    }
    
    func getDurationText() -> String {
        
        if durationType == "T" {
            var durationIsMinutes: Bool
            var text: String
            
            if duration < 60 {
                durationIsMinutes = true
            } else {
                durationIsMinutes = false
            }
            
            if durationIsMinutes {
                text = "- \(duration) Minutes"
            } else {
                
                if duration % 60 == 0{
                    if duration / 60 == 1 {
                        text = "- \(Int(floor(Double(duration)/60))) Hour"
                    } else {
                        text = "- \(Int(floor(Double(duration)/60))) Hours"
                    }
                } else {
                    let hours = Int(floor(Double(duration)/60))
                    let minutes = duration % 60
                    
                    if hours == 1 {
                        text = "- \(Int(floor(Double(duration)/60))) Hour \(minutes) Minutes"
                    } else {
                        text = "- \(Int(floor(Double(duration)/60))) Hours \(minutes) Minutes"
                    }
                }
            }
            
            return text
        } else if durationType == "L" {
            return "- \(duration) Laps"
        } else if durationType == "DM" {
            return "- \(duration) Miles"
        } else if durationType == "DKM" {
            return "- \(durationType) km"
        } else if durationType == "NO"{
            return ""
        } else {
            return "- Unknown duration"
        }
    }
    
    func day() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfTheWeekString = dateFormatter.string(from: date)
        
        return dayOfTheWeekString
    }
    
    func dateInTimeZone() -> Date {
        let seconds = TimeZone.current.secondsFromGMT()
        let minutesToGMT = (seconds / 60) + (seconds % 60)
        
        return self.date + minutesToGMT.minutes
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
}

var testSession1: Session {
    let session = Session()

    session.series = "Formula 1"
    session.accessLevel = 0
    session.darkR = 175.0
    session.darkG = 34.0
    session.darkB = 34.0
    session.lightR = 237.0
    session.lightG = 33.0
    session.lightB = 58.0
    session.seriesType = "Single Seater"
    session.event = 14
    session.circuit = "Silverstone"
    session.sessionName = "Race"
    session.sessionType = "R"
    session.roundNumber = 14
    session.durationType = "L"
    session.duration = 58
    session.date = Date() + 30.minutes
    session.tba = false

    return session
}

var testSession2: Session {
    let session = Session()

    session.series = "FIA WEC"
    session.accessLevel = 0
    session.darkR = 42.0
    session.darkG = 147.0
    session.darkB = 172.0
    session.lightR = 36.0
    session.lightG = 173.0
    session.lightB = 144.0
    session.seriesType = "Sportscars"
    session.event = 2
    session.circuit = "Spa"
    session.sessionName = "Race"
    session.sessionType = "R"
    session.roundNumber = 2
    session.durationType = "T"
    session.duration = 360
    session.date = Date() + 1.hours
    session.tba = false

    return session
}

var testSession3: Session {
    let session = Session()

    session.series = "IndyCar"
    session.accessLevel = 0
    session.darkR = 129.0
    session.darkG = 129.0
    session.darkB = 129.0
    session.lightR = 172.0
    session.lightG = 172.0
    session.lightB = 172.0
    session.seriesType = "Sportscars"
    session.event = 1
    session.circuit = "Texas"
    session.sessionName = "Race"
    session.sessionType = "R"
    session.roundNumber = 1
    session.durationType = "R"
    session.duration = 150
    session.date = Date() + 1.hours + 30.minutes
    session.tba = false

    return session
}

var testSession4: Session {
    let session = Session()

    session.series = "BTCC"
    session.accessLevel = 0
    session.darkR = 34.0
    session.darkG = 43.0
    session.darkB = 93.0
    session.lightR = 56.0
    session.lightG = 65.0
    session.lightB = 130.0
    session.seriesType = "Touring Cars"
    session.event = 10
    session.circuit = "Knockhill"
    session.sessionName = "Race 1"
    session.sessionType = "R"
    session.roundNumber = 10
    session.durationType = "L"
    session.duration = 21
    session.date = Date() + 1.hours + 15.minutes
    session.tba = false

    return session
}

var testSession5: Session {
    let session = Session()

    session.series = "BTCC"
    session.accessLevel = 0
    session.darkR = 34.0
    session.darkG = 43.0
    session.darkB = 93.0
    session.lightR = 56.0
    session.lightG = 65.0
    session.lightB = 130.0
    session.seriesType = "Touring Cars"
    session.event = 10
    session.circuit = "Knockhill"
    session.sessionName = "Race 2"
    session.sessionType = "R"
    session.roundNumber = 10
    session.durationType = "L"
    session.duration = 21
    session.date = Date() + 2.hours + 15.minutes
    session.tba = false

    return session
}

var testSession6: Session {
    let session = Session()

    session.series = "BTCC"
    session.accessLevel = 0
    session.darkR = 34.0
    session.darkG = 43.0
    session.darkB = 93.0
    session.lightR = 56.0
    session.lightG = 65.0
    session.lightB = 130.0
    session.seriesType = "Touring Cars"
    session.event = 10
    session.circuit = "Knockhill"
    session.sessionName = "Race 3"
    session.sessionType = "R"
    session.roundNumber = 10
    session.durationType = "L"
    session.duration = 21
    session.date = Date() + 3.hours + 15.minutes
    session.tba = false

    return session
}


var testSession7: Session {
    let session = Session()

    session.series = "MotoGP"
    session.accessLevel = 0
    session.darkR = 199.0
    session.darkG = 3.0
    session.darkB = 14.0
    session.lightR = 170.0
    session.lightG = 0.0
    session.lightB = 10.0
    session.seriesType = "Bikes"
    session.event = 10
    session.circuit = "Sachsenring"
    session.sessionName = "Race"
    session.sessionType = "R"
    session.roundNumber = 10
    session.durationType = "L"
    session.duration = 45
    session.date = Date() + 2.hours + 45.minutes
    session.tba = false

    return session
}

var noSessions: Session {
    let session = Session()

    session.series = "No Series"
    session.accessLevel = 0
    session.darkR = 199.0
    session.darkG = 3.0
    session.darkB = 14.0
    session.lightR = 170.0
    session.lightG = 0.0
    session.lightB = 10.0
    session.seriesType = "No Vehicle"
    session.event = 10
    session.circuit = "No Circuit"
    session.sessionName = "NoSessions"
    session.sessionType = "R"
    session.roundNumber = 10
    session.durationType = "L"
    session.duration = 45
    session.date = Date()
    session.tba = false

    return session
}
