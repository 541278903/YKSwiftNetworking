//
//  YKSceneDelegate.swift
//  YKSwiftCommandModule
//
//  Created by linghit on 2022/4/14.
//

import UIKit
import IQKeyboardManagerSwift

open class YKSceneDelegate: UIResponder {

    public var window: UIWindow?
    
    open func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        (self as? YKSwiftMainSceneDelegate)?.setupDebugTool?()
        // MARK: 设置rootViewController
        if let controller = (self as? YKSwiftMainSceneDelegate)?.setupController?()
        {
            self.window = UIWindow(windowScene: windowScene)
            self.window?.rootViewController = controller
            self.window?.backgroundColor = .white
        }
        
        // MARK: 启动IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // MARK: 设置多媒体
        (self as? YKSwiftMainSceneDelegate)?.registMedia?()
        // MARK: 设置玩控制器后设置
        (self as? YKSwiftMainSceneDelegate)?.afterSetup?()
        // MARK: 设置玩控制器后设置
        (self as? YKSwiftMainSceneDelegate)?.registNotification?(center: NotificationCenter.default, session: session, options: connectionOptions)
        
        
        self.window?.makeKeyAndVisible()

    }

}

