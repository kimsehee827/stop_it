//
//  Date.swift
//  Front
//
//  Created by 오인경 on 2021/08/18.
//

import Foundation

extension Date {
    
    var onlyDate: Date? {
        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = TimeZone(identifier: "KST")
            return calender.date(from: dateComponents)
        }
    }
    
    var today: String {
        return Date().onlyDate!.toString(dateFormat: "yyyy-MM-dd")
    }
    
    var onlyDateString: String {
        return self.onlyDate!.toString(dateFormat: "yyyy-MM-dd")
    }
    
    var isToday: Bool {
        return self.onlyDate!.toString(dateFormat: "yyyy-MM-dd") == Date().onlyDateString
    }
    
    func isSameDay(date: Date) -> Bool {
        return self.onlyDateString == date.onlyDateString
    }
    
    func toString(dateFormat format: String = "yyyy-MM-dd-HH-mm-ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    static func fromString(str: String, dateFormat format: String = "yyyy-MM-dd-HH-mm-ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        
        return dateFormatter.date(from: str)
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    static func getToday() -> Date {
        let today = Date()
        let result = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: today)!
        
        return result
    }
    
    static func getYesterday() -> Date {
        let today = Date()
        let hour = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: today)!
        let result = Calendar.current.date(byAdding: .day, value: -1, to: hour)!
        
        return result
    }
    
    static func getYesterday(date: Date) -> Date {
        let today = date
        let hour = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let result = Calendar.current.date(byAdding: .day, value: -1, to: hour)!
        
        return result
    }
    
    static func getYesterday23() -> Date {
        let result = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
        return Calendar.current.date(byAdding: .day, value: -1, to: result)!
    }
    
}
