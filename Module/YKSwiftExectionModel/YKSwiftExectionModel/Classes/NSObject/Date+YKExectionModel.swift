//
//  Date+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by linghit on 2021/11/19.
//

import Foundation

extension Date
{
    public static func yk_currentDateString(format:String) -> String {
        let date = Date()
        let fmt = DateFormatter()
        fmt.dateFormat = format
        return fmt.string(from: date)
    }
    
    public func yk_dateString(format formatString:String) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = formatString
        fmt.locale = Locale.init(identifier: "zh_CN")
        let interFrom1970 = self.timeIntervalSince1970
        return fmt.string(from: Date.init(timeIntervalSince1970: interFrom1970))
    }
    
    public static func yk_dateStr(timeStampSince1970:String, format formatString:String) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = formatString
        return fmt.string(from: Date.init(timeIntervalSince1970: TimeInterval.init(Float(timeStampSince1970) ?? 0)))
    }
    
    public func yk_date(afterDays days:Int) -> Date? {
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let comps = NSDateComponents.init()
        comps.day = days
        let date = calendar?.date(byAdding: comps as DateComponents, to: self as Date, options: NSCalendar.Options.init(rawValue: 0))
        return date
    }
    
    public func yk_date(afterHours hours:Int) -> Date? {
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let comps = NSDateComponents.init()
        comps.hour = hours
        let date = calendar?.date(byAdding: comps as DateComponents, to: self as Date, options: NSCalendar.Options.init(rawValue: 0))
        return date
    }
    
    public static func yk_isToday(timeInterval:TimeInterval) -> Bool {
        
        let calendar = NSCalendar.current
        
        let betweenedDate  = NSDate.init(timeIntervalSince1970: timeInterval)
        let components = calendar.dateComponents([Calendar.Component.year,
                                                  Calendar.Component.month,
                                                  Calendar.Component.day], from: betweenedDate as Date)
        
        let currentDate  = NSDate.init(timeIntervalSinceNow: 0)
        let currentcomponents = calendar.dateComponents([Calendar.Component.year,
                                                  Calendar.Component.month,
                                                  Calendar.Component.day], from: currentDate as Date)
        
        if (components.year == currentcomponents.year && components.month == currentcomponents.month && components.day == currentcomponents.day) {
            return true
        }
        return false
    }
    
    public var yk_year:Int {
        get {
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([Calendar.Component.year], from: self as Date)
            return components.year ?? 0
        }
    }
    
    public var yk_month:Int {
        get {
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([Calendar.Component.month], from: self as Date)
            return components.month ?? 0
        }
    }
    
    public var yk_day:Int {
        get {
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([Calendar.Component.day], from: self as Date)
            return components.day ?? 0
        }
    }
    
    public var yk_hour:Int {
        get {
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([Calendar.Component.hour], from: self as Date)
            return components.hour ?? 0
        }
    }
    
    public var yk_minute:Int {
        get {
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([Calendar.Component.minute], from: self as Date)
            return components.minute ?? 0
        }
    }
    
    public var yk_second:Int {
        get {
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([Calendar.Component.second], from: self as Date)
            return components.second ?? 0
        }
    }
}
