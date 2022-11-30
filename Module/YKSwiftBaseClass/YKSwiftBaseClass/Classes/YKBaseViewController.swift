//
//  YKBaseViewController.swift
//  YKSwiftBaseClass
//
//  Created by linghit on 2021/11/17.
//

import UIKit
import SHFullscreenPopGestureSwift


@available(iOS 9.0, *)
open class YKBaseViewController : UIViewController
{
    
    public let isIPad:Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    open var yk_disableDEBUGShake:Bool = false
    
    public func yk_authorizationStatus() async -> Bool {
        let setting = await UNUserNotificationCenter.current().notificationSettings()
        return setting.authorizationStatus == .authorized
    }
    
    private var _userInterfaceStyle:UIUserInterfaceStyle? = nil
    @available(iOS 12.0, *)
    public var userInterfaceStyle:UIUserInterfaceStyle? {
        get {
            return _userInterfaceStyle
        }
    } 
    
    public var yk_hideNavigationBar:Bool = false {
        didSet {
            self.sh_prefersNavigationBarHidden = yk_hideNavigationBar
        }
    }
    
    public var yk_disablePopGesture:Bool = false {
        didSet {
            self.sh_interactivePopDisabled = yk_disablePopGesture
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("viewDidAppear\(self)")
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
        
        debugPrint("viewDidDisappear\(self)")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("viewDidLoad\(self)")
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        autoExecute()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        debugPrint("viewDidLayoutSubviews\(self)")
        var safeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 11, *) {
            safeAreaInsets = self.view.safeAreaInsets
        }
        didReloadLayout(safeAreaInsets: safeAreaInsets)
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 12.0, *) {
            let uIS = previousTraitCollection?.userInterfaceStyle
            _userInterfaceStyle = uIS
            changeUserInterfaceStyle(style: uIS)
        } else {
            // Fallback on earlier versions
            _userInterfaceStyle = .light
        }
    }
    
    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
#if DEBUG
        if motion == .motionShake {
            if !self.yk_disableDEBUGShake {
                let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .alert)
                
                guard let actions = debugShakeActions() else {
                    return
                }
                
                for item in actions {
                    alertController.addAction(item)
                }
                
                present(alertController, animated: true, completion: nil)
            }
        }

#endif
    }
    
    open func autoExecute() {
        
    }
    
    open func didSetupUI(view: UIView) -> Void {
        
    }
    
    open func didBindData() -> Void {
        
    }
    
    open func didReloadLayout(safeAreaInsets: UIEdgeInsets) -> Void {
        
    }
    
    open func debugShakeActions()->Array<UIAlertAction>?
    {
        var array = Array<UIAlertAction>.init()
        array.append(UIAlertAction.init(title: "查看设备/账号信息", style: .default, handler: { action in
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "kShowBaseDeviceInfoNotification"), object: nil)
        }))
        array.append(UIAlertAction.init(title: "查看UI结构", style: .default, handler: { action in
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "Lookin_3D"), object: nil)
        }))
        array.append(UIAlertAction.init(title: "查看网络记录", style: .default, handler: { action in
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "kShowBaseNetworkingInfoNotification"), object: nil)
        }))
        return array
    }
    
    @available(iOS 12.0, *)
    open func changeUserInterfaceStyle(style:UIUserInterfaceStyle?){
        
    }
    
    
    deinit {
        debugPrint("deinit\(self)")
    }
}

private extension YKBaseViewController {
    
    func debugPrint(_ text:String) -> Void {
        #if DEBUG
        print("YKBase:  \(text)")
        #endif
    }
}
