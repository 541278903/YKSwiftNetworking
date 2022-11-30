//
//  NSObject+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by edward on 2021/5/22.
//

import Foundation

extension NSObject
{
    
    public func yk_deepCopy() -> NSObject {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! NSObject
    }
    
    public func yk_model(dic:Dictionary<String, Any>, mapDict:Dictionary<String,Any>) -> NSObject {
        return NSObject.init(dic: dic, mapDict: mapDict)
    }
    
    convenience init(dic:Dictionary<String,Any>, mapDict:Dictionary<String,Any>){
        self.init()
        var outCount: UInt32 = 0
        let ivars = class_copyIvarList(object_getClass(self), &outCount)
        
        for i in 0..<outCount {
            let ivar = ivars![Int(i)]
            let cname = ivar_getName(ivar)!
            let sname = String(cString: cname)
            var value = dic[sname]
            if value == nil {
                value = dic[mapDict[sname] as! String]
            }
            setValue(value, forKey: sname)
        }
    }
    
    public func yk_model(dic:Dictionary<String, Any>) -> NSObject {
        return NSObject.init(dic: dic)
    }
    
    convenience init(dic:Dictionary<String,Any>){
        self.init()
        var outCount: UInt32 = 0
        let ivars = class_copyIvarList(object_getClass(self), &outCount)
        
        for i in 0..<outCount {
            let ivar = ivars![Int(i)]
            let cname = ivar_getName(ivar)!
            let sname = String(cString: cname)
            let value = dic[sname]
            setValue(value, forKey: sname)
        }
    }
    
    public func value(forObject key:String) -> NSObject {
        
        let subObject = self.value(forKey: key) as? NSObject
        
        var object:NSObject = NSObject.init()
        
        if let sub = subObject {
            object = sub
        }
        
        return object
    }
    
    /// 模型转字典
    /// - Returns: 返回模型对应的字典
    public func yk_toDic() -> Dictionary<String, Any> {

        
        return convertToDictNesting(obj: self, remainFeild: nil, replace: nil)
    }
    
    /// 模型转字典
    /// - Parameter remainFeild: 只留下相对应字段
    /// - Returns: 字典
    public func yk_toDic(remainFeild: [String]? = nil) -> Dictionary<String,Any> {
        
        return convertToDictNesting(obj: self, remainFeild: remainFeild, replace: nil)
    }
    
    //暂时不推荐使用
//    public func yk_toDic(replace: (((label: String, value: Any)) -> (String, Any))? = nil) -> Dictionary<String,Any> {
//
//        return convertToDictNesting(obj: self, remainFeild: nil, replace: replace)
//    }
//
//    public func yk_toDic(remainFeild: [String]? = nil, replace: (((label: String, value: Any)) -> (String, Any))? = nil) -> Dictionary<String,Any> {
//
//        return convertToDictNesting(obj: self, remainFeild: remainFeild, replace: replace)
//    }
    
    
    private func convertToDictNesting(obj: Any, remainFeild: [String]? = nil, replace: (((label: String, value: Any)) -> (String, Any))? = nil) -> [String: Any] {
            var dict: [String: Any] = [:]
            var children: [Mirror.Child] = []
            if let superChildren = Mirror(reflecting: obj).superclassMirror?.children {
                children.append(contentsOf: superChildren)
            }
            children.append(contentsOf: Mirror(reflecting: obj).children)
            for child in children {
                if let key = child.label {
                    if let remainFeild = remainFeild, !remainFeild.contains(key) {
                        continue
                    }
                    let subMirror = Mirror(reflecting: child.value)
                    if let displayStyle = subMirror.displayStyle, displayStyle == .optional {
                        if subMirror.children.isEmpty {
                            continue
                        }
                    }
                    //解析类型属性
                    let subDict = convertToDictNesting(obj: child.value, remainFeild: remainFeild, replace: replace)
                    if subDict.isEmpty {
                        if let replaceReturn = replace?((key, child.value)) {
                            if !replaceReturn.0.isEmpty {
                                if let aryValue = replaceReturn.1 as? [Any] {
                                    var dictAry: [Any] = []
                                    for value in aryValue {
                                        let subDict = convertToDictNesting(obj: value, remainFeild: remainFeild, replace: replace)
                                        if subDict.isEmpty {
                                            dictAry.append(value)
                                        } else {
                                            dictAry.append(subDict)
                                        }
                                    }
                                    dict[replaceReturn.0] = dictAry
                                } else {
                                    dict[replaceReturn.0] = replaceReturn.1
                                }
                            }
                        } else {
                            if let aryValue = child.value as? [Any] {
                                var dictAry: [Any] = []
                                for value in aryValue {
                                    let subDict = convertToDictNesting(obj: value, remainFeild: remainFeild, replace: replace)
                                    if subDict.isEmpty {
                                        dictAry.append(value)
                                    } else {
                                        dictAry.append(subDict)
                                    }
                                }
                                dict[key] = dictAry
                            } else {
                                dict[key] = child.value
                            }
                        }
                    } else {
                        //非基础数据类型暂时只支持label替换
                        if let replace = replace?((key, child.value)) {
                            if !replace.0.isEmpty {
                                if let someDict = subDict["some"] {
                                    dict[replace.0] = someDict
                                } else {
                                    dict[replace.0] = subDict
                                }
                            }
                        } else {
                            if let someDict = subDict["some"] {
                                dict[key] = someDict
                            } else {
                                dict[key] = subDict
                            }
                        }
                    }
                }
            }
            return dict
    }
}
