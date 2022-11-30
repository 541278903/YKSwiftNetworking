//
//  UIAlertController+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by edward on 2021/11/17.
//

import UIKit

extension UIAlertController
{
    public static func yk_alert(withOKTitle title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确认", style: .default, handler: nil))
        return alert
    }
    
    public static func yk_alert(with title: String?, message: String?, buttonTitle: String?,handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: buttonTitle, style: .default, handler: handler)
        alert.addAction(action)
        return alert
    }
    
    public static func yk_alert(withArray title: String?, message: String?,actions: Array<UIAlertAction>) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        for item in actions {
            alert.addAction(item)
        }
        
        return alert
    }
    
    public static func yk_alert(withOKAndCancel title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "确认", style: .destructive, handler: handler)
        let cancel = UIAlertAction.init(title: "取消", style: .default, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        return alert
    }
    
    public static func yk_alert(with title: String?, message: String?, titles: [String], handler: ((_ index:Int ) -> Void)? = nil) -> UIAlertController {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        for (i,item) in titles.enumerated() {
            let action = UIAlertAction.init(title: item, style: .default) { action in
                if handler != nil {
                    handler!(i)
                }
            }
            alertVC.addAction(action)
        }
        
        return alertVC
    }
    
    public static func yk_alertSheet(withTitle title: String?,message: String?,titles: [String],handler: ((_ index:Int ) -> Void)? = nil) -> UIAlertController {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        
        for (i,item) in titles.enumerated() {
            let action = UIAlertAction.init(title: item, style: .default) { action in
                if handler != nil {
                    handler!(i)
                }
            }
            alertVC.addAction(action)
        }
        
        alertVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        return alertVC
    }
}
