//
//  YKSwiftBaseNetworking.swift
//  YKSwiftNetworking
//
//  Created by linghit on 2021/9/1.
//

import UIKit
import Alamofire

class YKSwiftBaseNetworking: NSObject {
    
    public static func request(request:YKSwiftNetworkRequest, progressCallBack:(_ progress:Float )->Void, successCallBack:(_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Void, failureCallBack:(_ request:YKSwiftNetworkRequest, _ isCache:Bool, _ responseObject:Any, _ error:Error?)->Void)
    {
        
    }
    
    public static func upload(request:YKSwiftNetworkRequest, progressCallBack:(_ progress:Float )->Void, successCallBack:(_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Void, failureCallBack:(_ request:YKSwiftNetworkRequest, _ isCache:Bool, _ responseObject:Any, _ error:Error?)->Void)
    {
        
    }
    
    public static func download(request:YKSwiftNetworkRequest, progressCallBack:(_ progress:Float )->Void, successCallBack:(_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Void, failureCallBack:(_ request:YKSwiftNetworkRequest, _ isCache:Bool, _ responseObject:Any, _ error:Error?)->Void)
    {
        
    }

}
