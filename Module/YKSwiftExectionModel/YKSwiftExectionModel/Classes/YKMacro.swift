//
//  YKMacro.swift
//  YK_Swift_CommandModule
//
//  Created by edward on 2021/5/19.
//

import Foundation


let version = "1.0.1"

public let isiPhoneX:Bool = {
    
    var isPhoneX = false
    if #available(iOS 11, *) {
        isPhoneX = (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0)>0
    }else{
        isPhoneX = false
    }
    return isPhoneX
}()

/*** 沙盒 ***/
public let YKHomePath = NSHomeDirectory()
public let YKTempPath = NSTemporaryDirectory()
public let YKDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
public let YKCachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]

public let YKScale = IS_IPAD ? 1.5 : 1

/*** 日志 ***/
public func YKLog(_ items: Any...,file:String = #file, lineNum:Int = #line)->Void{
    debugDo({
        let fileArr = file.components(separatedBy: ["/","."])
        let filename = fileArr[fileArr.endIndex-2];
        print("file:\(filename)-line:\(lineNum)-msg:\(items)");
    })
}

/// 测试工作
public let debugDo:(_ todo:() -> Void) -> Void = { todoBlock in
    #if DEBUG
        todoBlock()
    #endif
}
 
public let lengthScale:(CGFloat) -> CGFloat = { originalLength in
    let scale = 375.0 / UIScreen.main.bounds.size.width
    return ((originalLength / scale) > originalLength ? originalLength : (originalLength / scale))
}

/*** UserDefaults ***/
public let YKSetUserDefault:(String,Any?) -> Void = { key, value in
    UserDefaults.standard.setValue(value, forKey: key)
}
public let YKGetUserDefault:(String) -> Any? = { key in
    return UserDefaults.standard.object(forKey:key)
}
/*** Notification ***/
public let YKSendNotification:(String,Any?,[AnyHashable:Any]?) -> Void = { name,sendObject,info in
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: sendObject, userInfo: info)
}

// 当前版本
public let YK_SYSTEM_VERSION = UIDevice.current.systemVersion
public let YK_APP_NAME = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
public let YK_APP_VERSION = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
public let YK_APP_BUILD = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
public let YK_APP_BUNDLE_ID = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? ""


//APP名称相关
public let KAPPENDAPPNAME:(String) -> String = { formatString in
    let appname = YK_APP_NAME
    return String.init(format: formatString, arguments: [appname])
}

/*** 错误 ***/
public let YKDomain = YK_APP_BUNDLE_ID
public let YKError: (String) -> Error = { errorMessage in
    return YKError_(errorMessage,-1)
}
public let YKError_: (String,Int) -> Error = { errorMessage,code in
    return NSError.init(domain: YKDomain, code: code, userInfo: [
        NSLocalizedDescriptionKey:errorMessage,
        NSLocalizedFailureReasonErrorKey:errorMessage,
        NSLocalizedRecoverySuggestionErrorKey:errorMessage,
    ])
}

//屏幕宽度
public let YKScreenW:CGFloat = UIScreen.main.bounds.size.width
//屏幕高度
public let YKScreenH:CGFloat = UIScreen.main.bounds.size.height
//状态栏高度
public let KSTATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.size.height


//手机下巴高度(0)则不是刘海屏
public let KBottom_HEIGHT:CGFloat = isiPhoneX ? 34 : 0
//tabbar高度
public let KTabBar_HEIGHT:CGFloat = (KBottom_HEIGHT + 49)
//导航栏高度
public let KTOP_MARGIN:CGFloat = (KSTATUSBAR_HEIGHT + 44)

// 手机型号
public let IS_IPAD = UI_USER_INTERFACE_IDIOM() == .pad
public let IS_IPHONE = UI_USER_INTERFACE_IDIOM() == .phone
public let IS_RETINA = UIScreen.main.scale >= 2.0

