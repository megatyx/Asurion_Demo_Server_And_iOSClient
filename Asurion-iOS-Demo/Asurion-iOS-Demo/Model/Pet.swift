//
//  Pets.swift
//  Asurion-iOS-Demo
//
//  Created by Tyler Wells on 8/23/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import Foundation

final class Pet: Decodable {
    let imageURL: URL
    let title: String
    let contentURL: URL
    let dateAdded: Date
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: APIKeys.Response.PetsResponse.self)
        self.imageURL = try values.decode(URL.self, forKey: .image_url)
        self.title = try values.decode(String.self, forKey: .title)
        self.contentURL = try values.decode(URL.self, forKey: .content_url)
        let dateString = try values.decode(String.self, forKey: .date_added)
        
        //If the JSON was correct, then it should go here.
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.expectedServerDateFormat
        
        guard let dateAdded = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: APIKeys.Response.PetsResponse.date_added,
                                                   in: values,
                                                   debugDescription: "Unable to Parse the given Date")
        }
        self.dateAdded = dateAdded
        
    }
}
