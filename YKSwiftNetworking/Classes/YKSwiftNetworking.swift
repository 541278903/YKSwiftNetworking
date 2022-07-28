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


@objc public protocol YKSwiftNetworkingDelegate {
    
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
                        _request!.header.updateValue(value, forKey: key)  //MARK:设置默认请求参数
                    }
                }
                if (!self.ignoreDefaultParams && self.defaultParams != nil) {
                    for (key,value) in self.defaultParams! {
                        _request!.params.updateValue(value, forKey: key) //MARK:设置默认请求参数
                    }
                }
                for (key,value) in self.commonHeader {
                    _request!.header.updateValue(value, forKey: key)
                }
                for (key,value) in self.commonParams {
                    _request!.params.updateValue(value, forKey: key)
                }
                
                if let configDefaultHeader = YKSwiftNetworkingConfig.share.defaultHeader {
                    for (key,value) in configDefaultHeader {
                        _request!.header.updateValue(value, forKey: key)
                    }
                }
                
                if let configDefaultParams = YKSwiftNetworkingConfig.share.defaultParams {
                    for (key,value) in configDefaultParams {
                        _request!.params.updateValue(value, forKey: key)
                    }
                }
                
            }
            return _request!
        }set{
            _request =  newValue
        }
    }
    
    private var requestDictionary:[String:YKSwiftNetworkRequest] = [:]
    
//    MARK:public
    open weak var delegate: YKSwiftNetworkingDelegate?
    
    /** 通用请求头 */
    open var commonHeader:[String:String] = [:]
    
    /** 公用头部 */
    private var defaultHeader:[String:String]? = nil
    
    /** 通用参数 */
    open var commonParams:[String:Any] = [:]
    
    /** 公用参数 */
    private var defaultParams:[String:Any]? = nil
    
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
    open var dynamicParamsConfig:((_ request: YKSwiftNetworkRequest) -> [String:Any])? = nil
    /**
     动态请求头的配置，每次执行请求都会加上这次的请求头
     */
    open var dynamicHeaderConfig:((_ request: YKSwiftNetworkRequest) -> [String:String])? = nil
    
    /// 根据需求处理正在加载的内容
    open var loadingHandle:((_ loading:Bool) -> Void)?
    
    /** 保存一下手动传入的Header，保证他是最高优先级 */
    private var inputHeaders:[String:String] = [:]
    
    /** 保存一下手动传入的参数，保证他是最高优先级 */
    private var inputParams:[String:Any] = [:]
    
    
    public override init() {
        super.init()
    }
    
    /// 构造
    /// - Parameters:
    ///   - defaultHeader: 默认头文件
    ///   - defaultParams: 默认菜蔬
    ///   - prefixUrl: 默认连接头
    ///   - handleResponse: 默认处理方式
    public convenience init(_ defaultHeader: [String:String]? = nil, _ defaultParams: [String:Any]? = nil, _ prefixUrl: String? = nil, _ handleResponse: ((_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Error?)? = nil ) {
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
    public func params(_ params: [String:Any]?) -> YKSwiftNetworking {
        if let par = params {
            self.inputParams = par
            for (key,value) in par {
                self.request.params.updateValue(value, forKey: key)
            }
        }
        
        return self
    }
    
    public func header(_ header: [String:String]?) -> YKSwiftNetworking {
        if let hea = header {
            self.inputHeaders = hea
            for (key,value) in hea {
                self.request.header.updateValue(value, forKey: key)
            }
        }
        return self
    }
    
    /// 本次请求的请求编码
    /// - Parameter method: 请求方式
    /// - Returns: networking
    public func encoding(_ encoding:YKSwiftNetworkRequestEncoding) -> YKSwiftNetworking {
        self.request.encoding = encoding
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
    
    public func mockData(_ data:Any) -> YKSwiftNetworking {
        self.request.mockData = data
        return self
    }
    
    public func httpBody(_ body:Data?) -> YKSwiftNetworking {
        self.request.httpBody = body
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
    
    
    
    
//    MARK:回调处理
    private func handleConfig(with request: YKSwiftNetworkRequest) -> Bool {
        if request.name == nil || request.name!.count == 0 {
            request.name = UUID.init().uuidString
        }
        
        let requestCopy = request.copy() as! YKSwiftNetworkRequest
        self.config(with: requestCopy)
        
        let config = YKSwiftNetworkingConfig.share
        
        if !request.disableDynamicHeader && ((self.dynamicHeaderConfig != nil) || config.dynamicHeaderConfig != nil) {
            var dynamicHeaderConfig:((_ request:YKSwiftNetworkRequest)->[String:String]?) = { request in
                return nil
            }
            
            if self.dynamicHeaderConfig != nil {
                dynamicHeaderConfig = self.dynamicHeaderConfig!
            }else if config.dynamicHeaderConfig != nil{
                dynamicHeaderConfig = config.dynamicHeaderConfig!
            }
            
            if let theHeader = dynamicHeaderConfig(requestCopy) {
                for (key,value) in theHeader {
                    if !(self.inputHeaders.keys.contains(key)) {
                        request.header.updateValue(value, forKey: key)
                    }
                }
            }
        }
        
        if !request.disableDynamicParams && ((self.dynamicParamsConfig != nil) || config.dynamicParamsConfig != nil)  {
            var dynamicParamsConfig:((_ request:YKSwiftNetworkRequest)->[String:Any]?) = { request in
                return nil
            }
            
            if self.dynamicParamsConfig != nil {
                dynamicParamsConfig = self.dynamicParamsConfig!
            }else if config.dynamicParamsConfig != nil{
                dynamicParamsConfig = config.dynamicParamsConfig!
            }
            
            if let theParams = dynamicParamsConfig(requestCopy) {
                for (key,value) in theParams {
                    if !(self.inputParams.keys.contains(key)) {
                        request.params.updateValue(value, forKey: key)
                    }
                }
            }
        }
        
        
        request.startTimeInterval = Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970
        
        self.requestDictionary.updateValue(request, forKey: request.name!)
        
        
        return true
    }
    
    private func config(with request: YKSwiftNetworkRequest) -> Void {
        //TODO:类似设置serialize
        
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
            delegate.cacheRequest?(request: request, response: response, isException: isException)
        }
    }
    
    deinit {
        #if DEBUG
            print("deinit:YKSwiftNetworking")
        #endif
    }
}

public extension YKSwiftNetworking
{
    //MARK: ====普通请求====
    /// 普通请求响应
    /// - Returns: 响应
    func execute() -> Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)> {
        
        let observable = Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)>.create { [weak self] observer in
            guard let weakSelf = self else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"self处理错误",
                    NSLocalizedFailureReasonErrorKey:"self处理错误",
                    NSLocalizedRecoverySuggestionErrorKey:"self处理错误",
                ]))
                observer.onCompleted()
                return Disposables.create() }
            
            
            guard let request = weakSelf.request.copy() as? YKSwiftNetworkRequest else { observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"初始化发生错误",
                    NSLocalizedFailureReasonErrorKey:"初始化发生错误",
                    NSLocalizedRecoverySuggestionErrorKey:"初始化发生错误",
                ]))
                observer.onCompleted()
                return Disposables.create() }
            
            let canContinue = weakSelf.handleConfig(with: request)
            if !canContinue {
                weakSelf._request = nil
                observer.onNext((request,YKSwiftNetworkResponse()))
                observer.onCompleted()
                return Disposables.create()
            }
            
            if request.isShowLoading {
                weakSelf.loadingHandle?(true)
            }
            
            request.task = YKSwiftBaseNetworking.request(request: request, progressCallBack: { progress in
                request.progressBlock?(progress)
            }, successCallBack: { [weak self] response, request in
                
                if let weakSelf = self {
                    
                    if request.isShowLoading {
                        weakSelf.loadingHandle?(false)
                    }
                    
                    var error:Error? = nil
                    if weakSelf.handleResponse != nil && !request.disableHandleResponse
                    {
                        error = weakSelf.handleResponse!(response,request)
                        if error != nil {
                            observer.onError(error!)
                        }else{
                            observer.onNext((request,response))
                        }
                    }else{
                        observer.onNext((request,response))
                    }
                    
                    weakSelf.saveTask(request: request, response: response, isException: error != nil)
                }else {
                    observer.onNext((request,response))
                }
                
                observer.onCompleted()
            }, failureCallBack: { [weak self] request, isCache, responseObject, error in
                
                if request.isShowLoading,
                   let weakSelf = self
                {
                    weakSelf.loadingHandle?(false)
                }
                
                if let err = error {
                    observer.onError(err)
                }else {
                    
                    let ykresponse = YKSwiftNetworkResponse()
                    ykresponse.rawData = responseObject
                    observer.onNext((request,ykresponse))
                    
                    if let weakSelf = self {
                        
                        weakSelf.saveTask(request: request, response: ykresponse, isException: true)
                    }
                }
                observer.onCompleted()
            })
            
            weakSelf._request = nil
            return Disposables.create()
            
        }
        
        return observable
    }
    
    //MARK: ====上传请求====
    /// 上传响应
    /// - warning: 请务必调用uploadData(data:Data, filename:String, mimeType:String)
    /// - Returns: 响应
    func uploadDataSignal() -> Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)> {
        
        
        let observable = Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)>.create { [ weak self] observer in
            
            guard let weakSelf = self else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"self处理错误",
                    NSLocalizedFailureReasonErrorKey:"self处理错误",
                    NSLocalizedRecoverySuggestionErrorKey:"self处理错误",
                ]))
                observer.onCompleted()
                return Disposables.create() }
            
            guard let request = weakSelf.request.copy() as? YKSwiftNetworkRequest else { observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"request初始化错误",
                    NSLocalizedFailureReasonErrorKey:"request初始化错误",
                    NSLocalizedRecoverySuggestionErrorKey:"request初始化错误",
                ]))
                observer.onCompleted()
                return Disposables.create() }
            
            request.header.updateValue("multipart/form-data", forKey: "content-type")
            let canContinue = weakSelf.handleConfig(with: request)
            if !canContinue {
                weakSelf._request = nil
                observer.onNext((request,YKSwiftNetworkResponse()))
                observer.onCompleted()
                return Disposables.create()
            }
            
            if request.isShowLoading {
                weakSelf.loadingHandle?(true)
            }
           
            if request.uploadFileData != nil && request.uploadName != nil && request.uploadMimeType != nil && request.formDataName != nil{
                
                
                request.task =  YKSwiftBaseNetworking.upload(request: request) { progress in
                    request.progressBlock?(progress)
                } successCallBack: { [weak self] response, request in
                    if let weakSelf = self {
                        
                        if request.isShowLoading {
                            weakSelf.loadingHandle?(false)
                        }
                        
                        var error:Error? = nil
                        if weakSelf.handleResponse != nil && !request.disableHandleResponse {
                            error = weakSelf.handleResponse!(response,request)
                            if error != nil {
                                observer.onError(error!)
                            }else{
                                observer.onNext((request,response))
                            }
                        }else {
                            observer.onNext((request,response))
                        }
                        weakSelf.saveTask(request: request, response: response, isException: error != nil)
                    }else {
                        observer.onNext((request,response))
                    }
                    observer.onCompleted()
                } failureCallBack: { [weak self] request, isCache, responseObject, error in
                    
                    if request.isShowLoading,
                       let weakSelf = self
                    {
                        weakSelf.loadingHandle?(false)
                    }
                    
                    if let err = error {
                        observer.onError(err)
                    }else {
                        let ykresponse = YKSwiftNetworkResponse.init()
                        observer.onNext((request,ykresponse))
                        if let weakSelf = self {
                            weakSelf.saveTask(request: request, response: ykresponse, isException: true)
                        }
                    }
                    observer.onCompleted()
                }
            }else{
                let error = NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [NSLocalizedDescriptionKey:"未设置数据:上传前请先调用uploadData()方法"])
                observer.onError(error)
                observer.onCompleted()
            }
            weakSelf._request = nil
            
            return Disposables.create()
        }
        return observable
    }
    
    //MARK: ====下载请求====
    /// 下载响应
    /// - warning: 请务必调用downloadDestPath
    /// - Returns: 响应
    func downloadDataSignal() -> Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)> {
        
        let observable = Observable<(request: YKSwiftNetworkRequest,response: YKSwiftNetworkResponse)>.create { [weak self] observer in
            
            guard let weakSelf = self else {
                observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                    NSLocalizedDescriptionKey:"self处理错误",
                    NSLocalizedFailureReasonErrorKey:"self处理错误",
                    NSLocalizedRecoverySuggestionErrorKey:"self处理错误",
                ]))
                observer.onCompleted()
                return Disposables.create() }
            
            guard let request = weakSelf.request.copy() as? YKSwiftNetworkRequest else { observer.onError(NSError.init(domain: "com.yk.swift.networking", code: -1, userInfo: [
                NSLocalizedDescriptionKey:"request初始化错误",
                NSLocalizedFailureReasonErrorKey:"request初始化错误",
                NSLocalizedRecoverySuggestionErrorKey:"request初始化错误",
            ]))
                observer.onCompleted()
                return Disposables.create() }
            
            let canContinue = weakSelf.handleConfig(with: request)
            if !canContinue {
                weakSelf._request = nil
                observer.onNext((request,YKSwiftNetworkResponse()))
                observer.onCompleted()
                return Disposables.create()
            }
            
            if request.isShowLoading {
                weakSelf.loadingHandle?(true)
            }
            
            request.task = YKSwiftBaseNetworking.download(request: request, progressCallBack: { progress in
                request.progressBlock?(progress)
            }, successCallBack: { [weak self] response, request in
                observer.onNext((request,response))
                if let weakSelf = self {
                    if request.isShowLoading {
                        weakSelf.loadingHandle?(false)
                    }
                    weakSelf.saveTask(request: request, response: response, isException: false)
                }
                observer.onCompleted()
            }, failureCallBack: { [weak self] request, isCache, responseObject, error in
                
                if request.isShowLoading,
                   let weakSelf = self
                {
                    weakSelf.loadingHandle?(false)
                }
                
                if let err = error {
                    observer.onError(err)
                }else {
                    let ykresponse = YKSwiftNetworkResponse.init()
                    observer.onNext((request,ykresponse))
                    if let weakSelf = self {
                        weakSelf.saveTask(request: request, response: ykresponse, isException: true)
                    }
                }
                observer.onCompleted()
            })
            weakSelf._request = nil
            return Disposables.create()
        }
        return observable
    }
    
}
