//
//  Date+Helpers.swift
//  CS342Support
//
//  Created by Santiago Gutierrez on 9/22/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation

extension Date {
    
    public func fullFormattedString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: .full, timeStyle: .none)
    }
    
    public func shortFormattedString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: .short, timeStyle: .none)
    }
    
    public var yesterday: Date {
        return dayByAdding(-1) ?? Date().addingTimeInterval(-86400)
    }
    
    public var tomorrow: Date {
        return dayByAdding(1) ?? Date().addingTimeInterval(86400)
    }
    
    public var startOfDay: Date {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        return cal.startOfDay(for: self)
    }
    
    public func ISOStringFromDate() -> String {
        let dateFormatter = DateFormatter()
        let timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = timeZone
        
        return dateFormatter.string(from: self) + "Z" //this is in UTC, 0 seconds from GMT.
    }
    
    public func shortStringFromDate() -> String {
        let dateFormatter = DateFormatter()
        let timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.timeZone = timeZone
        
        return dateFormatter.string(from: self)
    }
    
    public func dayByAdding(_ daysToAdd: Int) -> Date? {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        
        guard let startOfDay = calendar.date(from: components) else {
            fatalError("*** Unable to create the start date ***")
        }
        return (calendar as NSCalendar).date(byAdding: .day, value: daysToAdd, to: startOfDay, options: [])
    }
    
}
