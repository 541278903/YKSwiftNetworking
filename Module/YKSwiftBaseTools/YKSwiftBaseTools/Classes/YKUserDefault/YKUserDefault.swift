//
//  YKUserDefault.swift
//  YK_Swift_BaseTools
//
//  Created by edward on 2021/5/18.
//

import Foundation


public class YKUserDefault:NSObject
{
    //单例
    private static let shared = YKUserDefault()
    private var onceKeysArray:[String] = {
        var array = UserDefaults.standard.object(forKey: "onceKeysArray")
        if array == nil{
            array = [String]()
        }
        return [String]()
    }()
    private var normalKeysArray:[String] = {
        var array = UserDefaults.standard.object(forKey: "normalKeysArray")
        if array == nil{
            array = [String]()
        }
        return [String]()
    }()
    
    private let userDefault:UserDefaults = UserDefaults.standard
    
    override private init() {
        super.init()
        
    }
    
    /// 设置缓存一次性内容
    /// - Parameters:
    ///   - value: 值
    ///   - key: 键
    /// - Returns: 无
    public static func setOnceValue(value:Any,key:String)->Void{
        if !YKUserDefault.shared.onceKeysArray.contains(key) {
            YKUserDefault.shared.onceKeysArray.append(key)
        }
        YKUserDefault .setCacheValue(value: value, key: key)
    }
    
    /// 设置缓存
    /// - Parameters:
    ///   - value: 值
    ///   - key: 键
    /// - Returns: 无
    public static func setCacheValue(value:Any,key:String)->Void{
        YKUserDefault.shared.userDefault.setValue(YKUserDefault.shared.onceKeysArray, forKey: "onceKeysArray")
        if !YKUserDefault.shared.normalKeysArray.contains(key) {
            YKUserDefault.shared.normalKeysArray.append(key)
        }
        YKUserDefault.shared.userDefault.setValue(YKUserDefault.shared.normalKeysArray, forKey: "normalKeysArray")
        YKUserDefault.shared.userDefault.setValue(value, forKey: key)
        YKUserDefault.shared.userDefault.synchronize()
    }
    
    /// 清理所有一次性缓存
    public static func clearAllOnceValue(){
        YKUserDefault.shared.onceKeysArray.forEach { (key) in
            YKUserDefault.shared.userDefault.setValue(nil, forKey: key)
        }
    }
    
    /// 清理所有键值
    public static func clearAllValue(){
        YKUserDefault.shared.normalKeysArray.forEach { (key) in
            YKUserDefault.shared.userDefault.setValue(nil, forKey: key)
        }
    }
    
    /// 获取缓存
    /// - Parameter key: 键
    /// - Returns: 值
    public static func getObjectForKey(key:String)->Any?{
        
        return YKUserDefault.shared.userDefault.object(forKey: key)
    }
    
}
