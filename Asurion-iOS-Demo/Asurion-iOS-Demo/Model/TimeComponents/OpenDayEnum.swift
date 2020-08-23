//
//  OpenDayEnum.swift
//  Asurion-iOS-Demo
//
//  Created by Tyler Wells on 8/23/20.
//  Copyright © 2020 Tyler Wells. All rights reserved.
//

import Foundation

enum OpenDay: Int {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday

    init?(shortDay: String, relativeToPrevious: OpenDay? = nil) {
        switch shortDay {
        case "M", "Mon", "Monday", "m", "mon", "monday":
            self = .monday
        case "Tue", "Tuesday", "Tu", "tu", "tuesday":
            self = .tuesday
        case "W", "Wed", "Wednesday", "wed", "w", "wednesday":
            self = .wednesday
        case "Th", "th", "thu", "Thu", "Thurs", "Thursday", "thurs", "thursday":
            self = .thursday
        case "F", "Fri", "Fr", "f", "fri", "fr", "Friday", "friday":
            self = .friday
        case "Sat", "Sa", "Saturday", "sat", "sa", "saturday":
            self = .saturday
        case "Sun", "Sunday", "Su", "su", "sun", "sunday":
            self = .sunday
        case "S", "s":
            guard let prevousDay = relativeToPrevious else {
                self = .saturday
                print("Warning: no previous date for comparison")
                return
            }
            if prevousDay.rawValue >= OpenDay.saturday.rawValue {
                self = .sunday
            } else {
                return nil
            }
        case "T", "t":
            guard let prevousDay = relativeToPrevious else {
                self = .tuesday
                print("Warning: no previous date for comparison")
                return
            }
            if prevousDay.rawValue >= OpenDay.tuesday.rawValue && prevousDay.rawValue < OpenDay.friday.rawValue {
                self = .thursday
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    static func weekdayIsBetweenTwo(startDay: OpenDay, endDay: OpenDay, comparisonDay: OpenDay) -> Bool{
        var startDayValue = startDay.rawValue
        if comparisonDay == startDay || comparisonDay == endDay {return true}
        if startDay == endDay {return false}
        
        var shouldBreakLoop: Bool = false
        while (shouldBreakLoop == false) {
            startDayValue += 1
            if startDayValue > 7 { startDayValue = 1}
            if startDayValue == endDay.rawValue {return false}
            if startDayValue == comparisonDay.rawValue {return true}
        }
    }
}
