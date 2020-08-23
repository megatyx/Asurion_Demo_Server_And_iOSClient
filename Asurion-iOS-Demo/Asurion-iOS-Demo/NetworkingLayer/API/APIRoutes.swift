//
//  APIRoutes.swift
//  Asurion-iOS-Demo
//
//  Created by Tyler Wells on 8/24/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import Foundation
enum APIRoutes: String {
    
    case getConfig = "getConfig"
    case getPets = "getPets"
    
    var baseURL: String {
        return ""
    }
    
    var route: String {
        return baseURL + self.rawValue
    }
}
