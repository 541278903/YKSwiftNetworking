//
//  UIResponder+Core.swift
//  YKSwiftExectionModel
//
//  Created by edward on 2021/5/19.
//

import UIKit


extension UIResponder {
    
    @objc open func routerEvent(eventName: String, userInfo: [String:Any], needBuried: Bool) -> Void {
        
        var need = needBuried
        if need {
            self.handleBuried(eventName: eventName, userInfo: userInfo)
            need = false//埋点完后便把标识改为false
        }
        self.next?.routerEvent(eventName: eventName, userInfo: userInfo, needBuried: need)
    }
    
    private func handleBuried(eventName: String, userInfo: [String:Any]) -> Void {
        //数据埋点操作 -暂时埋点写入本地数据中
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "handleBuried"), object: nil, userInfo: ["eventName":eventName,"userInfo":userInfo])
    }
}
