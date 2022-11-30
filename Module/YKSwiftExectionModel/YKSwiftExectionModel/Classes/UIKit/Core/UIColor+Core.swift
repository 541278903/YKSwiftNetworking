//
//  UIColor+Core.swift
//  YKSwiftExectionModel
//
//  Created by edward on 2021/5/19.
//

import Foundation
import UIKit


extension UIColor {
    
    
    /// 便利构造Hex颜色
        ///
        /// - Parameters:
        ///   - string: hex值
        ///   - alpha: alpha值，默认1.0
    public convenience init(hex string: String, alpha: CGFloat = 1.0) {
        
        var cString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if cString.count < 6 {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }
        // strip 0X if it appears
        //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        if cString.hasPrefix("0X") {
            cString = (cString as NSString).substring(from: 2)
        }
        //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        if cString.count != 6 {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }
        
        let scanner = Scanner(string: cString)
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let red = CGFloat(Int(color >> 16) & mask) / 255.0
        let green = CGFloat(Int(color >> 8) & mask) / 255.0
        let blue = CGFloat(Int(color) & mask) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    
    public static func yk_color(hex hexString:String) -> UIColor {
        return UIColor(hex: hexString)
    }
    
    
    /// 生成纯色图片
    /// - Returns: 纯色图片
    public func image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage.init()
        UIGraphicsEndImageContext()
        return image
        
    }
    
}
