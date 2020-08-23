//
//  AppConfiguration.swift
//  Asurion-iOS-Demo
//
//  Created by Tyler Wells on 8/23/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import Foundation

final class AppConfiguration: Decodable {
    let workingTime: OpenDayTime
    let workingTimeString: String
    let isChatEnabled: Bool
    let isCallEnabled: Bool
    
    init(workingTime: OpenDayTime, isChatEnabled: Bool = false, isCallEnabled: Bool = false, workingTimeString: String = "") {
        self.workingTimeString = workingTimeString
        self.workingTime = workingTime
        self.isCallEnabled = isCallEnabled
        self.isChatEnabled = isChatEnabled
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: APIKeys.Response.ConfigurationResponse.self)
        let settingsContainer =  try? values.nestedContainer(keyedBy: APIKeys.Response.ConfigurationResponse.self,
        forKey: .settings)
        let container = (settingsContainer != nil) ? settingsContainer!:values
        self.isChatEnabled = try container.decode(Bool.self, forKey: .chatEnabled)
        self.isCallEnabled = try container.decode(Bool.self, forKey: .callEnabled)
        
        let workingHoursString = try container.decode(String.self, forKey: .workHours)
        self.workingTimeString = workingHoursString
        let decodedDateStrings = workingHoursString
            .split(maxSplits: 1, omittingEmptySubsequences: true, whereSeparator: {$0 == " "})
            .joined(separator: "-")
            .components(separatedBy: "-")
            .map({$0.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ":", with: "")})
        
        guard decodedDateStrings.count == 4,
            let startDay = OpenDay(shortDay: decodedDateStrings[0]),
            let endDay = OpenDay(shortDay: decodedDateStrings[1], relativeToPrevious: startDay),
            let startTime = Int(decodedDateStrings[2]),
            let endTime = Int(decodedDateStrings[3]) else {
            throw DecodingError.dataCorruptedError(forKey: APIKeys.Response.ConfigurationResponse.workHours,
                                                   in: container,
                                                   debugDescription: "Unable to Parse the given Date")
        }
        self.workingTime = OpenDayTime(startDay: startDay, endDay: endDay, startTime: startTime, endTime: endTime)
    }
}
