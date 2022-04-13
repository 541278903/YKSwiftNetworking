//
//  YKSwiftNetworking.swift
//  YK_Swift_Networking
//
//  Created by edward on 2021/5/21.
//

import Foundation
import Alamofire
import RxSwift

@objc public enum YKNetworkRequestMethod:Int {
    case GET = 0
    case POST = 1
    case PUT = 2
    case PATCH = 3
    case DELETE = 4
}

@objc
public protocol YKSwiftNetworkingDelegate: NSObjectProtocol{
    
    /// 可设置缓存内容 需要开启缓存开关yk_isCache
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    ///   - isException: 是否报错
    @objc optional func cacheRequest(request: YKSwiftNetworkRequest, response: YKSwiftNetworkResponse, isException: Bool) -> Void
    
}

public typealias complateBlockType = (_ responData: Any?, _ error: Error?) -> Void

public typealias progressBlockType = (_ progress: Double) -> Void

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
    private var requestDictionary:Dictionary<String, YKSwiftNetworkRequest> = [:]
    
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
    open var handleResponse:((_ response: YKSwiftNetworkResponse, _ request: YKSwiftNetworkRequest) -> Error?)? = nil
    /**
     动态参数的配置，每次执行请求都会加上这次的参数
     */
    open var dynamicParamsConfig:((_ request: YKSwiftNetworkRequest) -> Dictionary<String,Any>)? = nil
    /**
     动态请求头的配置，每次执行请求都会加上这次的请求头
     */
    open var dynamicHeaderConfig:((_ request: YKSwiftNetworkRequest) -> Dictionary<String,String>)? = nil
    
    /// 根据需求处理正在加载的内容
    open var loadingHandle:((_ loading:Bool) -> Void)?
    
    
    /** 保存一下手动传入的Header，保证他是最高优先级 */
    private var inputHeaders:Dictionary<String,Any> = [:]
    
    /** 保存一下手动传入的参数，保证他是最高优先级 */
    private var inputParams:Dictionary<String,Any> = [:]
    
    
    public override init() {
        super.init()
    }
    
    /// 构造
    /// - Parameters:
    ///   - defaultHeader: 默认头文件
    ///   - defaultParams: 默认菜蔬
    ///   - prefixUrl: 默认连接头
    ///   - handleResponse: 默认处理方式
    public convenience init(_ defaultHeader: Dictionary<String,String>?, _ defaultParams: Dictionary<String,Any>?, _ prefixUrl: String?, _ handleResponse: @escaping((_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Error?) ) {
        self.init()
        self.defaultHeader = defaultHeader
        self.defaultParams = defaultParams
        self.handleResponse = handleResponse
    }
    
//    MARK:设置请求属性
    
    /// 本次请求地址
    /// - Parameter url: 地址
    /// - Returns: networking
    public func url(_ url: String) -> YKSwiftNetworking {
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
    
    /// 本次请求参数
    /// - Parameter params: 参数
    /// - Returns: networking
    public func params(_ params: Dictionary<String,Any>?) -> YKSwiftNetworking {
        if let par = params {
            self.inputParams = par
            for (key,value) in par {
                self.request.params[key] = value
            }
        }
        
        return self
    }
    
    public func header(_ header: Dictionary<String,String>?) -> YKSwiftNetworking {
        if let hea = header {
            self.inputHeaders = hea
            for (key,value) in hea {
                self.request.header[key] = value
            }
        }
        return self
    }
    
    /// 本次请求方式
    /// - Parameter method: 请求方式
    /// - Returns: networking
    public func method(_ method: YKNetworkRequestMethod) -> YKSwiftNetworking {
        self.request.method = method
        return self
    }
    
    /// 本次请求不默认使用动态参数
    /// - Returns: networking
    public func disableDynamicParams() -> YKSwiftNetworking {
        
        self.request.disableDynamicParams = true
        return self
    }
    
    /// 本次请求默认不适用统一处理方式
    /// - Returns: networking
    public func disableHandleResponse() -> YKSwiftNetworking {
        
        self.request.disableHandleResponse = true
        return self
    }
    
    /// 本次请求忽略动态头文件
    /// - Returns: networking
    public func disableDynamicHeader() -> YKSwiftNetworking {
        
        self.request.disableDynamicHeader = true
        return self
    }
    
    /// 最小响应时间
    /// - Parameter repeatInterval: 时间默认300
    /// - Returns: networking
    public func minRepeatInterval(_ repeatInterval: Double) -> YKSwiftNetworking {
        
        self.request.repeatRequestInterval = repeatInterval
        return self
    }
    
    /// 下载地址
    /// - Parameter destPath: 缓存地址文件夹
    /// - Returns: networking
    public func downloadDestPath(_ destPath: String) -> YKSwiftNetworking {
        
        self.request.destPath = destPath
        return self
    }
    
    /// 上传设置
    /// - Parameters:
    ///   - data: 上传数据
    ///   - filename: 上传文件名
    ///   - mimeType: 上传文件类型
    /// - Returns: networking
    public func uploadData(data: Data, filename: String, mimeType: String, formDataName: String) -> YKSwiftNetworking {
        
        self.request.uploadFileData = data
        self.request.uploadName = filename
        self.request.uploadMimeType = mimeType
        self.request.formDataName = formDataName
        return self
    }
    
    
    /// 进度
    /// - Parameter progressBlock: 进度回调
    /// - Returns: networking
    public func progress(_ progressBlock: @escaping ((_ progress:Double)->Void)) -> YKSwiftNetworking {
        self.request.progressBlock = progressBlock
        return self
    }
    
//    MARK:扩展内容
    
    /// get请求
    /// - Parameter url: 地址
    /// - Returns: networking
    public func get(_ url: String) -> YKSwiftNetworking {
        return self.url(url).method(.GET)
    }
    
    /// post请求
    /// - Parameter url: 地址
    /// - Returns: networking
    public func post(_ url: String) -> YKSwiftNetworking {
        return self.url(url).method(.POST)
    }
    
    /// put请求
    /// - Parameter url: 地址
    /// - Returns: networking
    public func put(_ url: String) -> YKSwiftNetworking {
        return self.url(url).method(.PUT)
    }
    
    /// delete请求
    /// - Parameter url: 地址
    /// - Returns: networking
    public func delete(_ url:String) -> YKSwiftNetworking {
        return self.url(url).method(.GET)
    }
    
    /// patch请求
    /// - Parameter url: 地址
    /// - Returns: networking
    public func patch(_ url: String) -> YKSwiftNetworking {
        return self.url(url).method(.PATCH)
    }
    
    public func showloading() -> YKSwiftNetworking {
        self.request.isShowLoading = true
        return self
    }
    
//    MARK:执行内容
    
    /// 普通请求响应
    /// - Returns: 响应
    public func execute() -> Observable<Any> {
        
        let request = self.request.copy() as! YKSwiftNetworkRequest
        let canContinue = self.handleConfig(with: request)
        if !canContinue {
            self._request = nil
            return Observable<Any>.empty()
        }
        if request.isShowLoading && self.loadingHandle != nil {
            self.loadingHandle!(true);
        }
        let observable = Observable<Any>.create { [weak request,weak self] observer in
            
            guard let weakRequest = request else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"初始化发生错误",
                    NSLocalizedFailureReasonErrorKey:"初始化发生错误",
                    NSLocalizedRecoverySuggestionErrorKey:"初始化发生错误",
                ]))
                return Disposables.create() }
            guard let weakSelf = self else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"初始化发生错误",
                    NSLocalizedFailureReasonErrorKey:"初始化发生错误",
                    NSLocalizedRecoverySuggestionErrorKey:"初始化发生错误",
                ]))
                return Disposables.create() }
            
            var progressBlock:((_ progress:Double)->Void)?
            if let proBlock = weakRequest.progressBlock {
                progressBlock = proBlock
            }
            
            
            weakRequest.task = YKSwiftBaseNetworking.request(request: weakRequest, progressCallBack: { progress in
                
                if let block = progressBlock {
                    block(progress)
                }
            }, successCallBack: { [weak self] response, request in
                
                if let strongself = self {
                    
                    if request.isShowLoading && strongself.loadingHandle != nil {
                        strongself.loadingHandle!(false);
                    }
                    
                    var error:Error? = nil
                    if strongself.handleResponse != nil && !request.disableHandleResponse
                    {
                        error = strongself.handleResponse!(response,request)
                        if error != nil {
                            observer.onError(error!)
                        }else{
                            observer.onNext(["request":request,"response":response])
                        }
                    }else{
                        observer.onNext(["request":request,"response":response])
                    }
                    
                    strongself.saveTask(request: request, response: response, isException: error != nil)
                }
                
                self.saveTask(request: request, response: response, isException: error != nil)
                observer.onCompleted()
            }, failureCallBack: { [weak self] request, isCache, responseObject, error in
                
                if let err = error {
                    observer.onError(err)
                }
                
                if let strongself = self {
                    
                    if request.isShowLoading && strongself.loadingHandle != nil {
                        strongself.loadingHandle!(false);
                    }
                    
                    let ykresponse = YKSwiftNetworkResponse()
                    ykresponse.rawData = responseObject
                    strongself.saveTask(request: request, response: ykresponse, isException: true)
                }
                
                observer.onCompleted()
            })
            
            weakSelf._request = nil
            
            return Disposables.create()
        }
        
        return observable
    }
    
    /// 上传响应
    /// - warning: 请务必调用uploadData(data:Data, filename:String, mimeType:String)
    /// - Returns: 响应
    public func uploadDataSignal() -> Observable<Any> {
        
        
        let request = self.request.copy() as! YKSwiftNetworkRequest
        request.header.updateValue("multipart/form-data", forKey: "content-type")
        let canContinue = self.handleConfig(with: request)
        if !canContinue {
            self._request = nil
            return Observable<Any>.empty()
        }
        if request.isShowLoading && self.loadingHandle != nil {
            self.loadingHandle!(true);
        }
        let observable = Observable<Any>.create { [weak request, weak self] observer in
            
            guard let weakRequest = request else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"初始化发生错误",
                    NSLocalizedFailureReasonErrorKey:"初始化发生错误",
                    NSLocalizedRecoverySuggestionErrorKey:"初始化发生错误",
                ]))
                return Disposables.create() }
            guard let weakSelf = self else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"初始化发生错误",
                    NSLocalizedFailureReasonErrorKey:"初始化发生错误",
                    NSLocalizedRecoverySuggestionErrorKey:"初始化发生错误",
                ]))
                return Disposables.create() }
            
           
            if weakRequest.uploadFileData != nil && weakRequest.uploadName != nil && weakRequest.uploadMimeType != nil && weakRequest.formDataName != nil{
                
                var progressBlock:((_ progress:Double)->Void)?
                if let proBlock = weakRequest.progressBlock {
                    progressBlock = proBlock
                }
                
                YKSwiftBaseNetworking.upload(request: weakRequest) { progress in
                    if let block = progressBlock {
                        block(progress)
                    }
                } successCallBack: { [weak self] response, request in
                    if let strongself = self {
                        if request.isShowLoading && strongself.loadingHandle != nil {
                            strongself.loadingHandle!(false);
                        }
                        var error:Error? = nil
                        if strongself.handleResponse != nil && !request.disableHandleResponse
                        {
                            error = strongself.handleResponse!(response,request)
                            if error != nil {
                                observer.onError(error!)
                            }else{
                                observer.onNext(["request":request,"response":response])
                            }
                        }else{
                            observer.onNext(["request":request,"response":response])
                        }
                        strongself.saveTask(request: request, response: response, isException: error != nil)
                    }
                    
                    observer.onCompleted()
                } failureCallBack: { [weak self] request, isCache, responseObject, error in
                    if let err = error {
                        observer.onError(err)
                    }
                    if let strongself = self {
                        if request.isShowLoading && strongself.loadingHandle != nil {
                            strongself.loadingHandle!(false);
                        }
                        let ykresponse = YKSwiftNetworkResponse.init()
                        strongself.saveTask(request: request, response: ykresponse, isException: true)
                    }
                    observer.onCompleted()
                }
            }else{
                let error = NSError.init(domain: "com.YKSwiftNetworking", code: -1, userInfo: [NSLocalizedDescriptionKey:"未设置数据:上传前请先调用uploadData()方法"])
                observer.onError(error)
                observer.onCompleted()
            }
            weakRequest.task?.resume()
            weakSelf._request = nil
            
            return Disposables.create()
        }
        return observable
    }
    
    /// 下载响应
    /// - warning: 请务必调用downloadDestPath
    /// - Returns: 响应
    public func downloadDataSignal() -> Observable<Any> {
        let request = self.request.copy() as! YKSwiftNetworkRequest
        let canContinue = self.handleConfig(with: request)
        if !canContinue {
            self._request = nil
            return Observable<Any>.empty()
        }
        if request.isShowLoading && self.loadingHandle != nil {
            self.loadingHandle!(true);
        }
        let observable = Observable<Any>.create { [weak request, weak self] observer in
            
            guard let weakRequest = request else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"初始化发生错误",
                    NSLocalizedFailureReasonErrorKey:"初始化发生错误",
                    NSLocalizedRecoverySuggestionErrorKey:"初始化发生错误",
                ]))
                return Disposables.create() }
            guard let weakSelf = self else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"初始化发生错误",
                    NSLocalizedFailureReasonErrorKey:"初始化发生错误",
                    NSLocalizedRecoverySuggestionErrorKey:"初始化发生错误",
                ]))
                return Disposables.create() }
            
            var progressBlock:((_ progress:Double)->Void)?
            if let proBlock = weakRequest.progressBlock {
                progressBlock = proBlock
            }
            
            weakRequest.task = YKSwiftBaseNetworking.download(request: weakRequest, progressCallBack: { progress in
                if let block = progressBlock {
                    block(progress)
                }
            }, successCallBack: { [weak self] response, request in
                
                if let strongself = self {
                    if request.isShowLoading && strongself.loadingHandle != nil {
                        strongself.loadingHandle!(false);
                    }
                    var error:Error? = nil
                    if strongself.handleResponse != nil && !request.disableHandleResponse
                    {
                        error = strongself.handleResponse!(response,request)
                        if error != nil {
                            observer.onError(error!)
                        }else{
                            observer.onNext(["request":request,"response":response])
                        }
                    }else{
                        observer.onNext(["request":request,"response":response])
                    }
                    strongself.saveTask(request: request, response: response, isException: error != nil)
                }
                observer.onCompleted()
            }, failureCallBack: { [weak self] request, isCache, responseObject, error in
                if let err = error {
                    
                    observer.onError(err)
                }
                if let strongself = self {
                    if request.isShowLoading && strongself.loadingHandle != nil {
                        strongself.loadingHandle!(false);
                    }
                    let ykresponse = YKSwiftNetworkResponse.init()
                    strongself.saveTask(request: request, response: ykresponse, isException: true)
                }
                
                observer.onError(error!)
                let ykresponse = YKSwiftNetworkResponse.init()
                self.saveTask(request: request, response: ykresponse, isException: true)
                observer.onCompleted()
            })
            weakSelf._request = nil
            
            
            return Disposables.create()
        }
        return observable
    }
    
//    MARK:直接请求独立响应式
    
    /// 不使用响应普通正常请求
    /// - Parameters:
    ///   - method: 请求方式
    ///   - url: 请求地址
    ///   - params: 请求参数
    ///   - header: 请求头文件
    ///   - complate: 请求回调
    /// - Returns: 空
    public static func executeByMethod(method: YKNetworkRequestMethod,url: String,params: Dictionary<String,Any>?,header: Dictionary<String,String>?,complate: @escaping complateBlockType) -> Void {
        _ = YKSwiftNetworking.init(nil, nil, nil, { response, request in
            return nil
        }).url(url).method(method).params(params).header(header).disableDynamicHeader().disableDynamicParams().disableHandleResponse().execute().mapWithRawData().subscribe(onNext: { result in
            complate(result,nil)
        }, onError: { error in
            complate(nil,error)
        })

    }
    
    
    /// 不适用响应默认GET请求
    /// - Parameters:
    ///   - url: 请求地址
    ///   - params: 请求参数
    ///   - header: 请求头文件
    ///   - complate: 请求方式
    /// - Returns: 空
    public static func GET(url: String, params: Dictionary<String,Any>?, header: Dictionary<String,String>?, _  complate: @escaping complateBlockType) -> Void {
        YKSwiftNetworking.executeByMethod(method: .GET, url: url, params: params, header: header, complate: complate)
    }
    
    /// 不适用响应默认POST请求
    /// - Parameters:
    ///   - url: 请求地址
    ///   - params: 请求参数
    ///   - header: 请求头文件
    ///   - complate: 请求方式
    /// - Returns: 空
    public static func POST(url: String, params: Dictionary<String,Any>?, header: Dictionary<String,String>?,  _ complate: @escaping complateBlockType) -> Void {
        YKSwiftNetworking.executeByMethod(method: .POST, url: url, params: params, header: header, complate: complate)
    }
    
    
    /// 不适用响应默认上传
    /// - Parameters:
    ///   - url: 上传地址
    ///   - data: 上传数据
    ///   - filename: 上传文件名
    ///   - mimeType: 上传文件类型
    ///   - params: 上传参数
    ///   - header: 上传头文件
    ///   - progress: 上传进度
    ///   - complate: 上传回调
    /// - Returns: 空
    public static func UPLOAD(url: String,data: Data, filename: String, mimeType: String, formDataName: String,params: Dictionary<String,Any>?,header: Dictionary<String,String>?,progress: @escaping progressBlockType, complate: @escaping complateBlockType) -> Void {
        _ = YKSwiftNetworking.init().url(url).method(.POST).params([:]).uploadData(data: data, filename: filename, mimeType: mimeType, formDataName: formDataName).progress(progress).uploadDataSignal().mapWithRawData().subscribe(onNext: { result in
            complate(result,nil);
        }, onError: { error in
            complate(nil,error)
        })
    }
    
    
    /// 不适用响应默认下载
    /// - Parameters:
    ///   - url: 下载地址
    ///   - destPath: 下载缓存地址
    ///   - progress: 下载进度
    ///   - complate: 下载回调
    /// - Returns: 空
    public static func DOWNLOAD(url: String,destPath: String,progress: @escaping progressBlockType, complate: @escaping complateBlockType) -> Void {
        _ = YKSwiftNetworking.init().url(url).method(.POST).downloadDestPath(destPath).progress(progress).disableDynamicParams().disableDynamicHeader().disableHandleResponse().downloadDataSignal().mapWithRawData().subscribe(onNext: { result in
            complate(result,nil)
        }, onError: { error in
            complate(nil,error)
        })
    }
    
    
    
//    MARK:回调处理
    
    private func handleConfig(with request: YKSwiftNetworkRequest) -> Bool {
        if request.name == nil || request.name!.count == 0 {
            request.name = UUID.init().uuidString
        }
        
        let requestCopy = request.copy() as! YKSwiftNetworkRequest
        self.config(with: requestCopy)
        
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
                if !(self.inputHeaders.keys.contains(key)) {
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
                if !(self.inputParams.keys.contains(key)) {
                    request.params[key] = value
                }
            }
        }
        
        
        request.startTimeInterval = Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970
        
        self.requestDictionary.updateValue(request, forKey: request.name!)
        
        
        return true
    }
    
    private func config(with request: YKSwiftNetworkRequest) -> Void {
        //TODO:类似设置serialize
        let _:Alamofire.SessionManager = {
            let configuration = URLSessionConfiguration.default
            //请求超时时间15秒
            configuration.timeoutIntervalForRequest = YKSwiftNetworkingConfig.share.timeoutInterval
            return Alamofire.SessionManager(configuration: configuration)
        }()
        
    }
    
    
    public func cancelAllRequest() -> Void {
        for (_,value) in self.requestDictionary {
            if value.task != nil {
                value.task!.cancel()
            }else if value.downloadTask != nil {
                value.downloadTask!.cancel()
            }
        }
        self.requestDictionary.removeAll()
    }
    
    public func cancelRequest(with name:String) -> Void {
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
    
    private func saveTask(request: YKSwiftNetworkRequest, response: YKSwiftNetworkResponse, isException: Bool) -> Void {
        /// 集中统一
        if let cacheRequest = YKSwiftNetworkingConfig.share.cacheRequest {
            cacheRequest(response,request,isException)
        }
        
        /// 当前代理
        if let delegate = self.delegate {
            if delegate.cacheRequest?(request: request, response: response, isException: isException) == nil {}
        }
    }
    
    deinit {
        #if DEBUG
            print("deinit:YKSwiftNetworking")
        #endif
    }
}
