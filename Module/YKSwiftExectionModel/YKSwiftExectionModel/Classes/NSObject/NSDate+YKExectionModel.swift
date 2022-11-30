//
//  NSDate+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by edward on 2021/5/21.
//

import Foundation

extension NSDate
{
    
    public static func yk_currentDateString(format:String) -> String {
        let date = Date()
        let fmt = DateFormatter()
        fmt.dateFormat = format
        return fmt.string(from: date)
    }
    
    public func yk_dateString(format:String) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        fmt.locale = Locale.init(identifier: "zh_CN")
        let interFrom1970 = self.timeIntervalSince1970
        return fmt.string(from: Date.init(timeIntervalSince1970: interFrom1970))
    }
    
    public static func yk_dateStr(timeStampSince1970:String, format:String) ->String {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        return fmt.string(from: Date.init(timeIntervalSince1970: TimeInterval.init(Float(timeStampSince1970) ?? 0)))
    }
    
    public func yk_dateAfterDays(days:Int) -> NSDate {
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let comps = NSDateComponents.init()
        comps.day = days
        let date = calendar?.date(byAdding: comps as DateComponents, to: self as Date, options: NSCalendar.Options.init(rawValue: 0))
        return date! as NSDate
    }
    
    public func yk_dateAfterHours(hours:Int) -> NSDate {
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let comps = NSDateComponents.init()
        comps.hour = hours
        let date = calendar?.date(byAdding: comps as DateComponents, to: self as Date, options: NSCalendar.Options.init(rawValue: 0))
        return date! as NSDate
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
    
    public func yk_year() -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([Calendar.Component.year], from: self as Date)
        return components.year ?? 0
    }
    
    public func yk_month() -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([Calendar.Component.month], from: self as Date)
        return components.month ?? 0
    }
    
    public func yk_day() -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: self as Date)
        return components.day ?? 0
    }
    
    public func yk_hour() -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([Calendar.Component.hour], from: self as Date)
        return components.hour ?? 0
    }
    
    public func yk_minute() -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([Calendar.Component.minute], from: self as Date)
        return components.minute ?? 0
    }
    
    public func yk_second() -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([Calendar.Component.second], from: self as Date)
        return components.second ?? 0
    }
}
