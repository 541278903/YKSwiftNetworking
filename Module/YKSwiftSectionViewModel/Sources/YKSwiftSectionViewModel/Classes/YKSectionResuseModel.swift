//
//  YKSectionResuseModel.swift
//  YKSwiftSectionViewModel
//
//  Created by edward on 2021/12/7.
//

import Foundation

public class YKSectionResuseModel: NSObject {
    
    public var className:AnyClass? = nil
    public var classId:String = ""
    
    public init(className:AnyClass?,classId:String) {
        super.init()
        self.className = className
        self.classId = classId
    }

}
