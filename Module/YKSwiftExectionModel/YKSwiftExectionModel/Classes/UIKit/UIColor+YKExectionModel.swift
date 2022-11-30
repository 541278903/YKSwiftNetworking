//
//  UIColor+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by linghit on 2022/4/21.
//

import UIKit

extension UIColor {
    
    public static func yk_randomColor() -> UIColor {
       return UIColor(red: CGFloat((arc4random_uniform(UInt32(255.0))))/255.0 , green: CGFloat((arc4random_uniform(UInt32(255.0))))/255.0, blue: CGFloat((arc4random_uniform(UInt32(255.0))))/255.0, alpha: 1.0)
    }
    
    public static func yk_tiling(imageName: String) -> UIColor {
        let imgPattern = UIImage.init(named: imageName) ?? UIImage.init()
        return UIColor.init(patternImage: imgPattern)
    }
    
    public static func yk_normalLabelColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor.black
        }
    }
    
    public static func yk_normalBackGroundColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }
}
