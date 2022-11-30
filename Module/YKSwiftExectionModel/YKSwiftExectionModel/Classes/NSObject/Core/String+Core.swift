//
//  String+Core.swift
//  YKSwiftExectionModel
//
//  Created by edward on 2022/4/21.
//

import UIKit

extension String {
    
    
    public func width(withHeight height:CGFloat, font:UIFont) -> CGFloat {
        let attrs = [NSAttributedString.Key.font:font]
        let maxSize = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let options:NSStringDrawingOptions = [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading]
        let size = (self as NSString).boundingRect(with: maxSize, options: options, attributes: attrs, context: nil).size
        return size.width
        
    }
    
    public func height(withWidth width:CGFloat, font:UIFont) -> CGFloat {
        let attrs = [NSAttributedString.Key.font:font]
        let maxSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let options:NSStringDrawingOptions = [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading]
        let size = (self as NSString).boundingRect(with: maxSize, options: options, attributes: attrs, context: nil).size
        return size.height
    }
    
    public func toImage(withBundle bundle:Bundle? = nil) -> UIImage? {
        let path = bundle?.bundlePath
        return UIImage()
    }
    
}
