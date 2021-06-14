//
//  YKSwiftNetworking.swift
//  YK_Swift_Networking
//
//  Created by edward on 2021/5/21.
//

import Foundation
import Alamofire
import YK_Swift_BaseTools
import RxSwift

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
    @objc func cacheRequest(request:YKSwiftNetworkRequest, response:YKSwiftNetworkResponse, isException:Bool)->Void
    
    
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
                if (!self.ignoreDefaultHeader && self.defaultHeader != nil) {
                    for (key,value) in self.defaultHeader! {
                        _request!.header[key] = value  //MARK:设置默认请求参数
                    }
                }
                if (!self.ignoreDefaultParams && self.defaultParams != nil) {
                    for (key,value) in self.defaultParams! {
                        _request!.params[key] = value //MARK:设置默认请求参数
                    }
                }
                for (key,value) in self.commonHeader {
                    _request!.header[key] = value
                }
                for (key,value) in self.commonParams {
                    _request!.params[key] = value
                }
            }
            return _request!
        }set{
            _request =  newValue
        }
    }
    private var requestDictionary:Dictionary<String,YKSwiftNetworkRequest> = [:]
    
//    MARK:public
    open weak var delegate: YKSwiftNetworkingDelegate?
    /** 通用请求头 */
    open var commonHeader:Dictionary<String,String> = [:]
    /** 公用头部 */
    private var defaultHeader:Dictionary<String,String>? = nil
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
    open var dynamicHeaderConfig:((_ request:YKSwiftNetworkRequest) -> Dictionary<String,String>)? = nil
    
    public func get(url:String)->YKSwiftNetworking {
        return self.url(url: url).method(method: .GET)
    }
    
    
    private let RGBAColor: (CGFloat, CGFloat, CGFloat, CGFloat) -> UIColor = {red, green, blue, alpha in
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    public override init() {
        super.init()
    }
    
    public convenience init(_ defaultHeader:Dictionary<String,String>?, _ defaultParams:Dictionary<String,Any>?, _ prefixUrl:String?, _ handleResponse:@escaping((_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Error?) ) {
        self.init()
        self.defaultHeader = defaultHeader
        self.defaultParams = defaultParams
        self.handleResponse = handleResponse
    }
    
    public func url(url:String)->YKSwiftNetworking{
        var urlString:String = ""
        
        let utf8Url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.init(charactersIn: "`#%^{}\"[]|\\<> ").inverted) ?? ""
        
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            self.request.urlStr = utf8Url
            return self
        }
        var prefix:String = ""
        if self.prefixUrl == nil {
            if (YKSwiftNetworkingConfig.share.defaultPrefixUrl != nil) {
                prefix = YKSwiftNetworkingConfig.share.defaultPrefixUrl!
            }
        }else{
            prefix = self.prefixUrl!
        }
        
        var removeSlash:String? = nil
        if prefix.count > 0 && utf8Url.count > 0 {
            let lastCharInPrefix = (prefix as NSString).substring(from: prefix.count - 1)
            let firstCharInUrl = (utf8Url as NSString).substring(to: 1)
            if lastCharInPrefix == "/" && firstCharInUrl == "/" {
                removeSlash = (prefix as NSString).substring(to: prefix.count - 1)
            }
        }
        if removeSlash != nil {
            prefix = removeSlash!
        }
        urlString = "\(prefix)\(utf8Url)"
        
        self.request.urlStr = urlString
        
        return self
    }
    
    public func params(params:Dictionary<String,Any>)->YKSwiftNetworking{
        
        for (key,value) in params {
            self.request.params[key] = value
        }
        return self
    }
    
    public func method(method:YKNetworkRequestMethod)->YKSwiftNetworking{
        
        self.request.method = method
        return self
    }
    
    public func disableDynamicParams()->YKSwiftNetworking{
        
        self.request.disableDynamicParams = true
        return self
    }
    
    public func disableHandleResponse()->YKSwiftNetworking{
        
        self.request.disableHandleResponse = true
        return self
    }
    
    public func disableDynamicHeader()->YKSwiftNetworking{
        
        self.request.disableDynamicHeader = true
        return self
    }
    
    public func minRepeatInterval(repeatInterval:Double)->YKSwiftNetworking{
        
        self.request.repeatRequestInterval = repeatInterval
        return self
    }
    
    public func downloadDestPath(destPath:String)->YKSwiftNetworking{
        
        self.request.destPath = destPath
        return self
    }
    
    public func uploadData(data:Data, filename:String, mimeType:String)->YKSwiftNetworking{
        
        self.request.uploadFileData = data
        self.request.uploadName = filename
        self.request.uploadMimeType = mimeType
        return self
    }
    
    public func progress(progressBlock:@escaping ((_ progress:Double)->Void))->YKSwiftNetworking
    {
        self.request.progressBlock = progressBlock
        return self
    }
    
    public func execute()->Observable<Any>{
        
        let request = self.request.copy() as! YKSwiftNetworkRequest
        let canContinue = self.handleConfigWithRequest(request: request)
        if !canContinue {
            self._request = nil
            return Observable<Any>.empty()
        }
    
        let signal = Observable<Any>.create { observer in
            request.task = Alamofire.request(request.urlStr, method: request.methodStr, parameters: request.params, encoding: URLEncoding.default, headers: request.header).response { response in
                
                if response.error != nil {
                    observer.onError(response.error!)
                    let ykresponse = YKSwiftNetworkResponse.init()
                    self.saveTask(request: request, response: ykresponse, isException: true)
                    observer.onCompleted()
                }
                
                let ykresponse = YKSwiftNetworkResponse.init()
                ykresponse.rawData = response.data
                
                if self.handleResponse != nil && !request.disableHandleResponse
                {
                    let error = self.handleResponse!(ykresponse,request)
                    if error != nil {
                        observer.onError(error!)
                        self.saveTask(request: request, response: ykresponse, isException: true)
                    }else{
                        observer.onNext(["request":request,"response":ykresponse])
                        self.saveTask(request: request, response: ykresponse, isException: false)
                    }
                }else{
                    observer.onNext(["request":request,"response":ykresponse])
                    self.saveTask(request: request, response: ykresponse, isException: false)
                }
                
                observer.onCompleted()
            }.downloadProgress { progress in
                if request.progressBlock != nil {
                    request.progressBlock!(progress.fractionCompleted)
                }
            }
            request.task?.resume()
            self._request = nil
            
            return Disposables.create()
        }
        
        return signal
    }
    
    public func uploadDataSignal()->Observable<Any>{
        
        
        let request = self.request.copy() as! YKSwiftNetworkRequest
        request.header.updateValue("multipart/form-data", forKey: "content-type")
        let canContinue = self.handleConfigWithRequest(request: request)
        if !canContinue {
            self._request = nil
            return Observable<Any>.empty()
        }
    
        let signal = Observable<Any>.create { observer in
           
            if request.uploadFileData != nil && request.uploadName != nil && request.uploadMimeType != nil{
                Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(request.uploadFileData!, withName: "file", fileName: request.uploadName!, mimeType: request.uploadMimeType!)
                }, to: request.urlStr) { encodingResult in
                   
                }
            }else{
                let error = NSError.init(domain: "com.YKSwiftNetworking", code: -1, userInfo: ["message":"未设置数据"])
                observer.onError(error)
                observer.onCompleted()
            }
            
            self._request = nil
            
            return Disposables.create()
        }
        return signal
    }
    
//    MARK:回调处理
    
    public func handleConfigWithRequest(request:YKSwiftNetworkRequest)->Bool
    {
        if request.name == nil || request.name!.count == 0 {
            request.name = UUID.init().uuidString
        }
        
        let requestCopy = request.copy() as! YKSwiftNetworkRequest
        self.configWithRequest(request: requestCopy)
        
        let config = YKSwiftNetworkingConfig.share
        
        if !request.disableDynamicHeader && ((self.dynamicHeaderConfig != nil) || config.dynamicHeaderConfig != nil) {
            var dynamicHeaderConfig:((_ request:YKSwiftNetworkRequest)->Dictionary<String,String>?)? = nil
            
            if self.dynamicHeaderConfig != nil {
                dynamicHeaderConfig = self.dynamicHeaderConfig!
            }else if config.dynamicHeaderConfig != nil{
                dynamicHeaderConfig = config.dynamicHeaderConfig!
            }
            
            let theHeader = dynamicHeaderConfig!(requestCopy) ?? [:]
            
            for (key,value) in theHeader {
                if !request.header.keys.contains(key) {
                    request.header[key] = value
                }
            }
        }
        
        if !request.disableDynamicParams && ((self.dynamicParamsConfig != nil) || config.dynamicParamsConfig != nil)  {
            var dynamicParamsConfig:((_ request:YKSwiftNetworkRequest)->Dictionary<String,Any>?)? = nil
            
            if self.dynamicParamsConfig != nil {
                dynamicParamsConfig = self.dynamicParamsConfig!
            }else if config.dynamicParamsConfig != nil{
                dynamicParamsConfig = config.dynamicParamsConfig!
            }
            
            let theParams = dynamicParamsConfig!(requestCopy) ?? [:]
            
            for (key,value) in theParams {
                if !request.params.keys.contains(key) {
                    request.params[key] = value
                }
            }
        }
        
        if (self.handleResponse == nil && config.handleResponse != nil) {
            self.handleResponse = config.handleResponse!
        }
        
        request.startTimeInterval = Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970
        
        self.requestDictionary.updateValue(request, forKey: request.name!)
        
        
        return true
    }
    
    public func configWithRequest(request:YKSwiftNetworkRequest)->Void
    {
        //TODO:类似设置serialize
       let dataRequest =  Alamofire.request("123", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
        
        dataRequest.resume()
        
    }
    
    public func cancelAllRequest()
    {
        for (_,value) in self.requestDictionary {
            if value.task != nil {
                value.task!.cancel()
            }else if value.downloadTask != nil {
                value.downloadTask!.cancel()
            }
        }
        self.requestDictionary.removeAll()
    }
    
    public func cancelRequestWithName(name:String)->Void
    {
        if self.requestDictionary.keys.contains(name) {
            let request = self.requestDictionary[name]
            if request!.task != nil {
                request!.task!.cancel()
            }else if request!.downloadTask != nil{
                request!.downloadTask!.cancel()
            }
            self.requestDictionary.removeValue(forKey: name)
        }else{
            #if DEBUG
                print("请求已经完成或者没有name = \(name)的请求")
            #endif
        }
    }
    
    private func saveTask(request:YKSwiftNetworkRequest, response:YKSwiftNetworkResponse, isException:Bool)->Void
    {
        if YKSwiftNetworkingConfig.share.cacheRequest != nil {
            YKSwiftNetworkingConfig.share.cacheRequest!(response,request,isException)
        }else if self.delegate != nil {
            self.delegate!.cacheRequest(request: request, response: response, isException: isException)
        }
    }
    
    
    deinit {
        #if DEBUG
            print("deinit:YKSwiftNetworking")
        #endif
    }
}
