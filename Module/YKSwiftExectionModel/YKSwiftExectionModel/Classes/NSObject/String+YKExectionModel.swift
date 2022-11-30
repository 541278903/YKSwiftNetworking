//
//  String+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by linghit on 2021/11/18.
//

import Foundation
import CommonCrypto

extension String
{
    
    public static func uuId() -> String {
        return String.stringWithUUID()
    }
    
    public static func stringWithUUID() -> String {
        return UUID.init().uuidString
    }
    
    public func rangeOfSubString(subStr: String) -> [NSRange] {
        var ranges:[NSRange] = []
        
        let string1 = self.appending(subStr)
        let nsstring1 = NSString.init(string: string1)
        var temp = ""
        
        for (i,_) in self.enumerated() {
            temp = nsstring1.substring(with: NSMakeRange(i, subStr.count))
            if temp.elementsEqual(subStr) {
                let range = NSMakeRange(i, subStr.count)
                ranges.append(range)
            }
        }
        
        return ranges
    }
    
    public static func pathOfDocument() -> String {
        let pathArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true)
        return pathArray[0]
    }
    
    public static func pathOfLibrary() -> String
    {
        let pathArray = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask,true)
        return pathArray[0]
    }
    
    public static func pathOfCache() -> String {
        let pathArray = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask,true)
        return pathArray[0]
    }
    
    public static func pathOfApplicationSupport() -> String {
        let pathArray = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask,true)
        return pathArray[0]
    }
    
    public subscript(of index: Int) -> String {
       if index < 0 || index >= self.count{
           return ""
       }
       for (i,item) in self.enumerated(){
           if index == i {
               return "\(item)"
           }
       }
       return ""
    }
    
    /// 根据range获取字符串 a[1...3]
    public subscript(r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(r.lowerBound, 0))
        let end = index(startIndex, offsetBy: min(r.upperBound, count - 1))
        return String(self[start...end])
    }
    
    /// 根据range获取字符串 a[0..<2]
    public subscript(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: max(r.lowerBound, 0))
        let end = index(startIndex, offsetBy: min(r.upperBound, count))
        return String(self[start..<end])
    }
    
    /// 根据range获取字符串 a[...2]
    public subscript(r: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: min(r.upperBound, count - 1))
        return String(self[startIndex...end])
    }
    
    /// 根据range获取字符串 a[0...]
    subscript(r: PartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(r.lowerBound, 0))
        let end = index(startIndex, offsetBy: count - 1)
        return String(self[start...end])
    }
    
    /// 根据range获取字符串 a[..<3]
    public subscript(r: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: min(r.upperBound, count))
        return String(self[startIndex..<end])
    }
    
    /// 截取字符串: index 开始到结尾
    /// - Parameter index: 开始截取的index
    /// - Returns: string
    public func subString(_ index: Int) -> String {
        guard index < count else {
            return ""
        }
        let start = self.index(endIndex, offsetBy: index - count)
        return String(self[start..<endIndex])
    }
    
    /// 截取字符串
    /// - Parameters:
    ///   - begin: 开始截取的索引
    ///   - end: 结束截取的索引
    /// - Returns: 字符串
    public func substring(start: Int, end: Int) -> String {
        if end<start {
            return ""
        }
        let starIndex = self.index(startIndex, offsetBy: start)
        let endIndex  = self.index(startIndex, offsetBy: end)
        return String(self[starIndex ..< endIndex])
    }
    
    /// 截取字符串
    /// - Parameters:
    ///   - start: 开始截取的索引
    ///   - count: 截取的个数（从开始索引开始）
    /// - Returns: 子字符串
    public func substring(start: Int, _ count: Int) -> String {
        let starIndex = self.index(startIndex, offsetBy: start)
        let endIndex  = self.index(starIndex, offsetBy: count)
        return String(self[starIndex ..< endIndex])
        
    }
    
    // MARK: ===============截取到指定位置的字符串===============
    public func substringToIndex(_ index: Int) -> String {
        let string = self.prefix(index)
        
        return String(string)
    }
    
    // MARK: ===============从指定位置截取到字符串的最后===============
    public func substringFromIndex(_ index: Int) -> String {
        let string = self.suffix(self.count - index)
        
        return String(string)
    }
    
    // MARK: ===============截取指定位置的字符串===============
    public func substringWithRange(_ range: NSRange) -> String {
        let starIndex = self.index(startIndex, offsetBy: range.location)
        let endIndex  = self.index(starIndex, offsetBy: range.length)
        
        let string = self[starIndex ..< endIndex]
        
        return String(string)
    }
    
    // MARK: ===============获取子符串的位置===============
    public func getRange(_ cString: String) -> NSRange {
        if self.isEmpty {
            return NSRange(location: 0, length: 0)
        }
        
        let range = self.range(of: cString)
        
        if range == nil {
            return NSRange(location: 0, length: 0)
        }
        
        let location = distance(from: startIndex, to: range!.lowerBound)
        let length   = distance(from: range!.lowerBound, to: range!.upperBound)
        
        return NSRange(location: location, length: length)
    }
    
    // MARK: ===============插入单个字符===============
    public mutating func insertCharacter(_ character: Character, _ index: Int) -> String {
        self.insert(character, at: self.index(startIndex, offsetBy: index))
        
        return self
    }
    
    // MARK: ===============插入字符串===============
    mutating func insertString(_ string: String, _ index: Int) -> String {
        self.insert(contentsOf: string, at: self.index(startIndex, offsetBy: index))
        
        return self
    }
}
