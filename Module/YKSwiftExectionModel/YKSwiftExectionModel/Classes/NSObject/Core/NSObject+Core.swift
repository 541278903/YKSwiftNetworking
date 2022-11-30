//
//  NSObject+Core.swift
//  YKSwiftExectionModel
//
//  Created by edward on 2021/5/20.
//

import Foundation
import UIKit


extension NSObject
{
    
    public var topMostController:UIViewController {
        get {
            var topController = UIApplication.shared.keyWindow?.rootViewController
            while ((topController?.presentedViewController) != nil) {
                topController = topController?.presentedViewController
            }
            return topController ?? UIViewController.init()
        }
    }
    
    @objc public var topWindow:UIWindow {
        get {
            if let window = UIApplication.shared.delegate?.window {
                return window!
            } else {
                if #available(iOS 13.0, *) {
                    let array:Set = UIApplication.shared.connectedScenes
                    let windowScene:UIWindowScene = array.first as! UIWindowScene
                    
                    if let mainWindow:UIWindow = windowScene.value(forKeyPath: "delegate.window") as? UIWindow {
                        return mainWindow
                    } else {
                        return UIApplication.shared.windows.first!
                    }
                } else {
                    return UIApplication.shared.keyWindow!
                }
            }
        }
    }
    
}
