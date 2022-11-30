//
//  NSString+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by edward on 2021/5/22.
//

import Foundation
import CommonCrypto

extension NSString
{
    
    public func yk_dateString(fromFormat: NSString, toFormat: NSString) -> NSString {
        let formatter = DateFormatter.init()
        formatter.dateFormat = fromFormat as String
        let date = formatter.date(from: self as String)
        formatter.dateFormat = toFormat as String
        return formatter.string(from: date ?? Date.init()) as NSString
    }
    
    public func yk_dayTimeInterval() -> NSString  {
        let agoTimeLong = TimeInterval(self.longLongValue)
        let currentTimeLong = Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970
        let distanceSecond = currentTimeLong - agoTimeLong
        
        if distanceSecond >= 86400 {
            return self.yk_dateTimeWithLonglongTimeFormat(format: "yyyy-MM-dd")
        }else if (distanceSecond >= 3600){
            return "\(distanceSecond/3600)小时前" as NSString
        }else if (distanceSecond >= 60){
            return "\(distanceSecond/60)分钟前" as NSString
        }else{
            return "\(distanceSecond)秒前" as NSString
        }
    }
    
    public func yk_timeRemain() -> NSString {
        let remainTimeLong = Int(self.longLongValue >= 0 ? self.longLongValue : 0)
        
        let dayLong = 60 * 60 * 24
        let hourLong = 60 * 60
        let minuteLong = 60
        
        let remainDay = remainTimeLong / dayLong;
        let remainHour = (remainTimeLong % dayLong) / hourLong;
        let remainMinute = (remainTimeLong % hourLong) / minuteLong;
        let remainSecond = (remainTimeLong % minuteLong);
        
        let remainString = NSMutableString.init()
        if remainDay > 0 {
            remainString.appending("\(remainDay)天")
        }
        if (remainHour > 0 || remainString.length != 0){
            remainString.appending("\(remainHour)时")
        }
        if (remainMinute > 0 || remainString.length != 0) {
            remainString.appending("\(remainMinute)分")
        }
        remainString.appending("\(remainSecond)秒")
        return remainString as NSString
    }
    
    public func yk_timeRemainMillisecond() -> NSString {
        let remainTimeLong = Int(self.longLongValue >= 0 ? self.longLongValue : 0)
        
        let dayLong = 60 * 60 * 24
        let hourLong = 60 * 60
        let minuteLong = 60
        
        let remainTimeSecond = remainTimeLong / 10
        let remainMillisecond = remainTimeLong % 10
        
        let remainDay = remainTimeSecond / dayLong;
        let remainHour = (remainTimeSecond % dayLong) / hourLong;
        let remainMinute = (remainTimeSecond % hourLong) / minuteLong;
        let remainSecond = (remainTimeSecond % minuteLong);
        
        let remainString = NSMutableString.init()
        if remainDay > 0 {
            remainString.appending("\(remainDay)")
        }
        if (remainHour > 0 || remainString.length != 0){
            remainString.appending("\(remainHour)")
        }
        if (remainMinute > 0 || remainString.length != 0) {
            remainString.appending("\(remainMinute)")
        }
        if "\(remainSecond)".count == 1 {
            remainString.appending("0")
        }
        remainString.appending("\(remainSecond)")
        remainString.appending("\(remainMillisecond)")
        return remainString as NSString
    }
    
    public func yk_heightWithContent(width: CGFloat, font: UIFont) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byCharWrapping
        paragraphStyle.alignment = NSTextAlignment.left
        
        let height = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:paragraphStyle], context: nil).size.height
        return height
    }
    
    public func yk_widthWithContent(height: CGFloat, font: UIFont) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byCharWrapping
        paragraphStyle.alignment = NSTextAlignment.left
        
        let width = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:paragraphStyle], context: nil).size.width
        return width
    }
    
    public func yk_sizeWithContent(fontSize: CGFloat) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byCharWrapping
        paragraphStyle.alignment = NSTextAlignment.left
        
        let size = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize),NSAttributedString.Key.paragraphStyle:paragraphStyle], context: nil).size
        return size
    }
    
    public func yk_convertToDate(formant: NSString) -> NSDate {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = formant as String
        return dateFormatter.date(from: self as String)! as NSDate
    }
    
    public static func yk_distance(time: NSString)-> NSString {
        let agoTimeLong = Double(time.longLongValue)
        let currentTimeLong = Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970
        
        let distanceSecond = Int32(currentTimeLong - agoTimeLong)
        
        if distanceSecond > 0 {
            if distanceSecond >= 31104000 {
                return "\(distanceSecond/3110400)年前" as NSString
            }else if (distanceSecond >= 2592000) {
                return "\(distanceSecond/2592000)个月前" as NSString
            }else if (distanceSecond >= 86400) {
                return "\(distanceSecond/86400)天前" as NSString
            }else if (distanceSecond >= 3600) {
                return "\(distanceSecond/3600)小时前" as NSString
            }else if (distanceSecond >= 60) {
                return "\(distanceSecond/60)分钟前" as NSString
            }else{
                return "\(distanceSecond)秒前" as NSString
            }
        }else{
            let date = NSDate.init(timeIntervalSince1970: agoTimeLong)
            let now = NSDate.init(timeIntervalSinceNow: 0)
            let dateyear = date.yk_year()
            let datemonth = date.yk_month()
            let dateday = date.yk_day()
            let datehour = date.yk_hour()
            let dateminute = date.yk_minute()
            let nowyear = now.yk_year()
            let nowmonth = now.yk_month()
            let nowday = now.yk_day()
            if (dateyear == nowyear && datemonth == nowmonth ) {
                if dateday == nowday {
                    return "今天\(datehour):\(dateminute)" as NSString
                }else if dateday == nowday + 1 {
                    return "明天\(datehour):\(dateminute)" as NSString
                }else if dateday == nowday + 2 {
                    return "后天\(datehour):\(dateminute)" as NSString
                }else if dateday == nowday + 2 {
                    return "本月\(dateday)日 \(datehour):\(dateminute)" as NSString
                }
            }else if (dateyear == nowyear && datemonth != nowmonth){
                return "\(datemonth)/\(dateday) \(datehour):\(dateminute)" as NSString
            }else {
                return "\(dateyear)/\(datemonth)/\(dateday) \(datehour):\(dateminute)" as NSString
            }
        }
        return "" as NSString
    }
    
    public func yk_md5() -> NSString {
        let str = (self as String).cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt((self as String).lengthOfBytes(using: String.Encoding.utf8))
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(str!, strLen, result)
        
        
        return "\(result[0])\(result[1])\(result[2])\(result[3])\(result[4])\(result[5])\(result[6])\(result[7])\(result[8])\(result[9])\(result[10])\(result[11])\(result[12])\(result[13])\(result[14])\(result[15])" as NSString
    }
    
    public func yk_decodeFromPercentEscapeString() -> NSString {
        let ouputString = NSMutableString.init(string: self)
        ouputString.replacingOccurrences(of: "+", with: " ", options: [NSString.CompareOptions.literal], range: NSRange.init(location: 0, length: ouputString.length))
        return ouputString.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
    }
    
    public func yk_stringLineSpacing(lineSpacing: CGFloat, fontSize: CGFloat) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle.init()
        style.lineSpacing = lineSpacing
        let string = NSMutableAttributedString.init(string: self as String, attributes: [NSAttributedString.Key.paragraphStyle:style])
        return string
        
    }
    
    public func yk_heightWithLineSpacing(lineSpacing: CGFloat, fontSize: CGFloat, width: CGFloat) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = NSTextAlignment.left
        paragraphStyle.lineSpacing = lineSpacing
        let size = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: [NSMutableAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)], context: nil).size
        return size
    }
    
    public func yk_hexStringDenary(denary: Int, formatLength: NSInteger) -> NSString {
        var nLetterValue = ""
        var str = ""
        var ttmpig:UInt16 = UInt16(0.0)
        var denary = denary
        for _ in 0..<9 {
            ttmpig = UInt16(denary % 16)
            denary = denary / 16
            switch ttmpig {
            case 10:
                nLetterValue = "A"
            case 11:
                nLetterValue = "B"
            case 12:
                nLetterValue = "C"
            case 13:
                nLetterValue = "D"
            case 14:
                nLetterValue = "E"
            case 15:
                nLetterValue = "F"
            default:
                nLetterValue = "\(ttmpig)"
            }
            str = nLetterValue.appending(str)
            if denary == 0 {
                break
            }
        }
        
        while str.count < length {
            str = "0\(str)"
        }
        return str as NSString
    }
    
     public func yk_complementHexString() -> NSString  {
        return "" as NSString
     }
    
    
    public func yk_dateTimeWithLonglongTimeFormat(format: NSString) -> NSString {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format as String
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: Date.init(timeIntervalSinceNow: 0)) as NSString
    }
}
