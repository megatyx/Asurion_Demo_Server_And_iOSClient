//
//  APIKeys.swift
//  Asurion-iOS-Demo
//
//  Created by Tyler Wells on 8/23/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import Foundation

enum APIKeys {
    enum Response {
        enum ConfigurationResponse: String, CodingKey {
            case settings, workHours
            case chatEnabled = "isChatEnabled"
            case callEnabled = "isCallEnabled"
        }
        
        enum PetsResponse: String, CodingKey {
            case pets, image_url, title, content_url, date_added
        }
    }
}
