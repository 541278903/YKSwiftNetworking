//
//  YKModel.swift
//  YKSwiftBaseClass
//
//  Created by edward on 2021/11/18.
//

import UIKit
import KakaJSON

open class YKModel: Convertible {

    public var Id:String = ""
    
    required public init() {}
    
    open func yk_jsonObject() -> [String:Any] {
        return self.kj.JSONObject()
    }
    
    open func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name
    }
    
}
