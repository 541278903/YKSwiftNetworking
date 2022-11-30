//
//  Target_NoTargetAction.swift
//  YK_Swift_MainMediator
//
//  Created by edward on 2021/5/24.
//

import Foundation


class Target_NoTargetAction: NSObject {
    
    
    @objc func Action_response(_ params:[String:Any]) -> Void  {
        let vc = YKNoActionResponseViewController.init()
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
    }

}
