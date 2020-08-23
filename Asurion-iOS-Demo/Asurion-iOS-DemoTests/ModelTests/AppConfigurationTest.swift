//
//  AppConfigurationTest.swift
//  Asurion-iOS-DemoTests
//
//  Created by Tyler Wells on 8/23/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import XCTest
@testable import Asurion_iOS_Demo


class AppConfigurationTest: XCTestCase {

    func testInitGoodJSON() {
        let jsonData = Data((#"{"settings": {"isChatEnabled" : true,"isCallEnabled" : true,"workHours" : "M-F 9:00 - 18:00"}}"#).utf8)
        XCTAssertNoThrow(try JSONDecoder().decode(AppConfiguration.self, from: jsonData))
    }
    
    func testInitAlternativeGoodJSON_Tuesday_Thursday() throws {
        let jsonData = Data((#"{"settings": {"isChatEnabled" : true,"isCallEnabled" : true,"workHours" : "T-T 9:00 - 18:00"}}"#).utf8)
        let appconfig = try JSONDecoder().decode(AppConfiguration.self, from: jsonData)
        print(appconfig.workingTime.startDay)
        print(appconfig.workingTime.endDay)
        XCTAssertNoThrow(try JSONDecoder().decode(AppConfiguration.self, from: jsonData))
    }
    
    func testInitAlternativeGoodJSON_Friday_Monday() throws {
        let jsonData = Data((#"{"settings": {"isChatEnabled" : true,"isCallEnabled" : true,"workHours" : "F-M 9:00 - 18:00"}}"#).utf8)
        XCTAssertNoThrow(try JSONDecoder().decode(AppConfiguration.self, from: jsonData))
    }
    
    func testInitBadJSON_No_Settings_Should_Recover() throws {
        let jsonData = Data((#"{"isChatEnabled" : true,"isCallEnabled" : true,"workHours" : "F-M 9:00 - 18:00"}"#).utf8)
        XCTAssertNoThrow(try JSONDecoder().decode(AppConfiguration.self, from: jsonData))
    }

}
