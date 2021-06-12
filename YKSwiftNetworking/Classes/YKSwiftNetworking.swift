//
//  YKSwiftNetworking.swift
//  YK_Swift_Networking
//
//  Created by edward on 2021/5/21.
//

import Foundation
import Alamofire
import ReactiveCocoa
import YK_Swift_BaseTools

public enum YKNetworkRequestMethod {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

@objc
public protocol YKSwiftNetworkingDelegate: NSObjectProtocol{
    
    /// 可设置缓存内容 需要开启缓存开关yk_isCache
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    ///   - isException: 是否报错
    func cacheRequest(request:YKSwiftNetworkRequest, response:YKSwiftNetworkResponse, isException:Bool)->Void
    
    
    @objc optional func networkingTest(test:String)->String
}

public typealias complateBlockType = (_ responData:Any?, _ error:Error?) -> Void

public typealias progressBlockType = (_ progress:Double) -> Void

public class YKSwiftNetworking:NSObject
{
//    MARK:privte
    private var _request:YKSwiftNetworkRequest? = nil
    private var request:YKSwiftNetworkRequest{
        get{
            if _request == nil {
                _request = YKSwiftNetworkRequest.init()
            }
            return _request!
        }set{
            
        }
    }
    
//    MARK:public
    open weak var delegate: YKSwiftNetworkingDelegate?
    /** 通用请求头 */
    open var commonHeader:Dictionary<String,Any> = [:]
    /** 公用头部 */
    private var defaultHeader:Dictionary<String,Any>? = nil
    /** 通用参数 */
    open var commonParams:Dictionary<String,Any> = [:]
    /** 公用参数 */
    private var defaultParams:Dictionary<String,Any>? = nil
    /** 接口前缀 */
    open var prefixUrl:String? = nil
    /** 忽略Config中配置的默认请求头 */
    open var ignoreDefaultHeader:Bool = false
    /** 忽略Config中配置的默认请求参数 */
    open var ignoreDefaultParams:Bool = false
    /// 根据需求处理回调信息判断是否是正确的回调 即中转统一处理源数据
    open var handleResponse:((_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest) -> Error?)? = nil
    /**
     动态参数的配置，每次执行请求都会加上这次的参数
     */
    open var dynamicParamsConfig:((_ request:YKSwiftNetworkRequest) -> Dictionary<String,Any>)? = nil
    /**
     动态请求头的配置，每次执行请求都会加上这次的请求头
     */
    open var dynamicHeaderConfig:((_ request:YKSwiftNetworkRequest) -> Dictionary<String,Any>)? = nil
    
    public func get(url:String)->YKSwiftNetworking {
        return self.url(url: url).method(method: .GET)
    }
    
    
    private let RGBAColor: (CGFloat, CGFloat, CGFloat, CGFloat) -> UIColor = {red, green, blue, alpha in
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    public override init() {
        super.init()
    }
    
    public convenience init(_ defaultHeader:Dictionary<String,Any>?, _ defaultParams:Dictionary<String,Any>?, _ prefixUrl:String?, _ handleResponse:@escaping((_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Error?) ) {
        self.init()
        self.defaultHeader = defaultHeader
        self.defaultParams = defaultParams
        self.handleResponse = handleResponse
    }
    
    public func url(url:String)->YKSwiftNetworking{
        var urlString:String = ""
        
        let utf8Url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.init(charactersIn: "`#%^{}\"[]|\\<> ").inverted)
        
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
//            self.request.
        }
        return self
    }
    
    public func params(params:Dictionary<String,Any>)->YKSwiftNetworking{
        
        return self
    }
    
    public func method(method:YKNetworkRequestMethod)->YKSwiftNetworking{
        
        return self
    }
    
}
