//
//  YKAppSetting.swift
//  YKSwiftBaseTools
//
//  Created by linghit on 2022/6/13.
//

import UIKit

public enum YKAppSettingTarget {
    case Main
    case Clip
    case Widget
    case Custom
}

public class YKAppSetting: NSObject {
    
    public static let share:YKAppSetting = YKAppSetting()
    
    private var _isProduct:Bool = false
    public var isProduct:Bool {
        get {
            return _isProduct
        }
        set {
            _isProduct = newValue
        }
    }
    
    private var _currentEnvironment:YKAppSettingTarget = .Main
    public var currentEnvironment:YKAppSettingTarget {
        get {
            return _currentEnvironment
        }
        set {
            _currentEnvironment = newValue
        }
    }
    
    private var productConfigsCache:[String:Any?] = [:]
    private var sandBoxConfigsCache:[String:Any?] = [:]
     
    
    private override init() {
        super.init()
        self.isProduct = UserDefaults.standard.bool(forKey: "open_product_environment")
    }

    
}

public extension YKAppSetting {
    
    func getConfig(withKey key:String, sandBoxOperate sandBox:()->Any, productOperate product:()->Any) -> Any {
        
        if !self.isProduct {
            var data:Any = ""
            if let sanboxCache = self.sandBoxConfigsCache[key],
               let sanBox = sanboxCache
            {
                data = sanBox
            }else {
                data = sandBox()
                self.sandBoxConfigsCache.updateValue(data, forKey: key)
                
            }
            return data
        }else {
            var data:Any = ""
            if let productCache = self.productConfigsCache[key],
               let produce = productCache
            {
                data = produce
            }else {
                data = product()
                self.productConfigsCache.updateValue(data, forKey: key)
            }
            return data
        }
    }
    
    func clearCacheData(isAll:Bool, clearKey key:String) {
        
        if isAll {
            if self.isProduct {
                self.productConfigsCache.removeAll()
            }else {
                self.sandBoxConfigsCache.removeAll()
            }
        }else {
            if self.isProduct {
                self.productConfigsCache.updateValue(nil, forKey: key)
            }else {
                self.sandBoxConfigsCache.updateValue(nil, forKey: key)
            }
        }
    }
    
}
