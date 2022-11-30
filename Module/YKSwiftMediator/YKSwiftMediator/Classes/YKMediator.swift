//
//  YKMediator.swift
//  Alamofire
//
//  Created by edward on 2021/5/24.
//

import Foundation
import CoreGraphics


public class YKMediator:NSObject
{
    public static let share = YKMediator.init()
    
    private var cachedTarget:[String:AnyObject] = [:]
    
    public func openUrlStr(urlString:String, params:[String:Any], shouldCacheTarget:Bool)->AnyObject?
    {
        let targetAction = urlString.components(separatedBy: "/");
        
        if targetAction.count < 3 {
            return nil
        }
        let moduleName = targetAction[0]
        let targetName = targetAction[1]
        let actionName = targetAction[2]
        return self.performTarget(moduleName: moduleName, targetName: targetName, actionName: actionName, params: params, shouldCacheTarget: shouldCacheTarget)
    }
    
    /*
     scheme://[target]/[action]?[params]
     
     url sample:
     aaa://targetA/actionB?id=1234
     */
    public func performAction(url:URL, completion: ((_ dictionary:[String:Any]?)->Void)?)->AnyObject?
    {
        let components = URLComponents.init(string: url.absoluteString)
        
        guard let host = components?.host else { return nil }
        
        let nameSpaceAndTraget = host.components(separatedBy: CharacterSet.init(charactersIn: "."))
        guard nameSpaceAndTraget.count == 2 else { return nil }
        
        let nameSpace = nameSpaceAndTraget[0]
        let target = nameSpaceAndTraget[1]
        guard let action = components?.path.replacingOccurrences(of: "_", with: ":").replacingOccurrences(of: "/", with: "") else { return nil }
        
        // 在这里添加 外部禁止的逻辑
        // 判断 action 或 target , 入不允许 则返回
        
        var params: [String: Any]?
        if let queryItems = components?.queryItems {
            params = [String: Any]()
            for queryItem in queryItems {
                if queryItem.value != nil {
                    params?[queryItem.name] = queryItem.value!
                }
            }
        }
        
        // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
        let result = self.performTarget(moduleName: nameSpace, targetName: target, actionName: action, params: params ?? [:], shouldCacheTarget: false)
        if completion != nil {
            if result != nil {
                completion!(["result":result!])
            }else{
                completion!(nil)
            }
        }
        return result
    }
    
    public func performTarget(moduleName:String, targetName:String?, actionName:String?, params:[String:Any], shouldCacheTarget:Bool)->AnyObject?
    {
        if targetName == nil && actionName == nil {
            return nil
        }
        
        // generate target
        let targetClassString = "\(moduleName).Target_\(targetName!)"
        let target = self.safeFetchCachedTarget(key: targetClassString)
        
        // generate action
        let actionString = "Action_\(actionName!)"
        _ = Selector(actionString)
        
        if target == nil {
            // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
            self.NoTargetActionResponseWithTargetString(targetString: targetClassString, selectorString: actionString, originParams: params)
            return nil
        }
        
        if shouldCacheTarget {
            self.safeSetCachedTarget(target: target!, key: targetClassString)
        }
        
        if target!.responds(to: Selector("Action_\(actionName!)")) {
            return self.safePerformAction(action: Selector("Action_\(actionName!)"), target: target!, params: params)
        }else if target!.responds(to: Selector("Action_\(actionName!):")){
            return self.safePerformAction(action: Selector("Action_\(actionName!):"), target: target!, params: params)
        }else{
            // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
//            action = NSSelectorFromString("notFound:")
            if target!.responds(to: Selector(("notFound"))) {
                return self.safePerformAction(action: Selector(("notFound")), target: target!, params: params)
            }else if target!.responds(to: Selector(("notFound:"))) {
                return self.safePerformAction(action: Selector(("notFound:")), target: target!, params: params)
            }else
            {
                // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
                self.NoTargetActionResponseWithTargetString(targetString: targetClassString, selectorString: actionString, originParams: params)
                self.cachedTarget.removeValue(forKey: targetClassString)
                return nil
            }
        }
    }
    
    private func releaseCachedTargetWithFullTargetName(fullTargetName:String?)->Void
    {
        /*
         fullTargetName在oc环境下，就是Target_XXXX。要带上Target_前缀。在swift环境下，就是XXXModule.Target_YYY。不光要带上Target_前缀，还要带上模块名。
         */
        if fullTargetName == nil {
            return
        }
        self.cachedTarget.removeValue(forKey: fullTargetName!)
    }
    
    private func NoTargetActionResponseWithTargetString(targetString:String, selectorString:String, originParams:[String:Any])->Void
    {
        let action = Selector.init(("Action_response:"))
        var resultTarget:NSObject = NSObject.init()
        let type: AnyClass? = NSClassFromString("YKSwiftMediator.Target_NoTargetAction")
        if type == nil {
            resultTarget = NSObject.init()
        }else{
            resultTarget = (type as! NSObject.Type).init()
        }
        let params:[String:Any] = ["originParams":originParams, "targetString":targetString, "selectorString":selectorString]
        
        _ = self.safePerformAction(action: action, target: resultTarget, params: params)
    }
    
    private func safePerformAction(action:Selector, target:AnyObject, params:[String:Any])->AnyObject?
    {
        if target.responds(to: action) {
            let object = (target.perform(action, with: params))?.takeUnretainedValue()
            return object
        }else{
            return nil
        }
    }
    
    private func safeFetchCachedTarget(key:String)->AnyObject?
    {
        let target = self.cachedTarget[key]
        var resultTarget:NSObject = NSObject.init()
        if target == nil {
            let type = NSClassFromString(key) as? NSObject.Type
            guard let targetType = type else { return nil }
            resultTarget = targetType.init()
        }else{
            resultTarget = self.cachedTarget[key] as! NSObject
        }
        return resultTarget
    }
    
    private func safeSetCachedTarget(target:AnyObject, key:String)->Void
    {
        self.cachedTarget[key] = target
    }
}
