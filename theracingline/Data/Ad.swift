//
//  Ad.swift
//  theracingline
//
//  Created by David Ellis on 02/12/2020.
//

import Foundation

class Ad: ObservableObject, Identifiable, Codable {
    var id = UUID().uuidString
    var title = ""
    var subtitle = ""
    var link = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case link
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: CodingKeys.id)
        try container.encode(title, forKey: CodingKeys.title)
        try container.encode(subtitle, forKey: CodingKeys.subtitle)
        try container.encode(link, forKey: CodingKeys.link)

    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        subtitle = try values.decode(String.self, forKey: .subtitle)
        link = try values.decode(String.self, forKey: .link)
    }
    
    init () {
        
    }
}

var testAd: Ad {
    let ad = Ad()
    
    ad.id = "1"
    ad.title = "GregzVR"
    ad.subtitle = "No-nonsense Sim Racing and VR Gaming Videos"
    ad.link = "https://www.youtube.com/c/GregzVR"
    
    return ad
}
