//
//  NSMutableAttributedString+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by edward on 2021/5/22.
//

import Foundation

extension NSMutableAttributedString
{
    
    public func yk_addStrikeLine() -> Void {
        self.yk_addStrikeLine(range: NSRange(location: 0, length: self.length))
    }
    
    public func yk_addStrikeLine(range:NSRange) -> Void {
//        self.addAttributes([NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle(),NSAttributedString.Key.baselineOffset:NSUnderlineStyle()], range: range)
    }
    
    
    public func yk_addAttributes(_ attrs: [NSAttributedString.Key : Any] = [:], range: NSRange) -> Void {
        if attrs.count <= 0 {
            self.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.red,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)], range: range)
        }else{
            self.addAttributes(attrs, range: range)
        }
    }
    
    
}
