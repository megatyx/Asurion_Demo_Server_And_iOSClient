//
//  PetsTest.swift
//  Asurion-iOS-DemoTests
//
//  Created by Tyler Wells on 8/23/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import XCTest
@testable import Asurion_iOS_Demo

class PetsTest: XCTestCase {
    
    func testInitGoodJSON() throws {
        let jsonData = Data((#"{"image_url": "https://upload.wikimedia.org/wikipedia/commons/0/00/Two_adult_Guinea_Pigs_%28Cavia_porcellus%29.jpg","title": "Guinea Pig","content_url": "https://en.wikipedia.org/wiki/Guinea_pig","date_added": "2018-08-04T10:45:29.027Z"}"#).utf8)
        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode(Pet.self, from: jsonData)) 
    }
    
    func testInitBadJSONEmpty() throws {
        let jsonData = Data((#"{}"#).utf8)
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(Pet.self, from: jsonData))
    }

    func testInitBadJSONBadData() throws {
        let jsonData = Data((#"{"content_url": "https://en.wikipedia.org/wiki/Guinea_pig","date_added": "2018-08-04T10:45:29.027Z"}"#).utf8)
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(Pet.self, from: jsonData))
    }
}
