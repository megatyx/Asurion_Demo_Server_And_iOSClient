//
//  NetworkHeadersProtocols.swift
//  Asurion-iOS-Demo
//
//  Created by Tyler Wells on 8/23/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import Foundation

protocol HTTPHeadersEncodable {}
extension HTTPHeadersEncodable {
    func addHeaders(_ headers: [String:String]?, request: inout URLRequest) {
        guard let headers = headers else {return}
        for (key,value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
