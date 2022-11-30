//
//  YKAppDelegate.swift
//  YK_Swift_CommandModule
//
//  Created by edward on 2021/5/20.
//

import Foundation
import IQKeyboardManagerSwift

open class YKAppDelegate: UIResponder, YKSwiftMainAppDelegate  {
    
    public let window: UIWindow = {
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        return window
    }();

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // MARK: 设置debug工具
        (self as YKSwiftMainAppDelegate).setupDebugTool?()
        // MARK: 设置rootViewController
        if let controller = (self as YKSwiftMainAppDelegate).setupController?()
        {
            self.window.rootViewController = controller
            self.window.makeKeyAndVisible()
        }
        
        // MARK: 启动IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // MARK: 设置多媒体
        (self as YKSwiftMainAppDelegate).registMedia?()
        // MARK: 设置玩控制器后设置
        (self as YKSwiftMainAppDelegate).afterSetup?()
        // MARK: 设置监听
        (self as YKSwiftMainAppDelegate).registNotification?(center: NotificationCenter.default, launchOptions: launchOptions)
        
        return true
    }
}
