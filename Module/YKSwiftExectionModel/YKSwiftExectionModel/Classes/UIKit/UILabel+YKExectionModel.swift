//
//  UILabel+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by linghit on 2021/11/18.
//

import UIKit

extension UILabel
{
    public func yk_textColor(_ color: UIColor) -> UILabel {
        self.textColor = color
        return self
    }
    
    public func yk_text(_ text: String?) -> UILabel {
        self.text = text
        return self
    }
    
    public func yk_attrText(_ text: NSAttributedString?) -> UILabel {
        self.attributedText = text
        return self
    }
    
    public func yk_font(fontSize: CGFloat,weight: UIFont.Weight) -> UILabel {
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        return self
    }
    
    public func yk_fontSize(_ fontSize: CGFloat) -> UILabel {
        self.font = UIFont.systemFont(ofSize: fontSize)
        return self
    }
    
    public func yk_unlimitedLine() -> UILabel {
        self.numberOfLines = 0
        return self
    }
    
    public func yk_numberOfLine(_ number: Int) -> UILabel {
        self.numberOfLines = number
        return self
    }
    
    public func yk_textAlignment(_ alignment: NSTextAlignment) -> UILabel {
        self.textAlignment = alignment
        return self
    }
    
}
