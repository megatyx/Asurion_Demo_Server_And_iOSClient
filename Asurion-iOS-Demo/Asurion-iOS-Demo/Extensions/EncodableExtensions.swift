//
//  EncodableExtensions.swift
//  Asurion-iOS-Demo
//
//  Created by Tyler Wells on 8/24/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import Foundation
extension Encodable {
    func encodeToJSONData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            return try encoder.encode(self)
        } catch {
            throw error
        }
    }
    
    func encodeToDictionary() throws -> [String:Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
