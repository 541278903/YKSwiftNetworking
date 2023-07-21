//
//  YKSwiftNetworkRequest.swift
//  YK_Swift_Networking
//
//  Created by edward on 2021/5/10.
//

import Foundation
import Alamofire

public enum YKNetworkResult {
    case success(YKSwiftNetworkRequest, YKSwiftNetworkResponse)
    case failure(YKSwiftNetworkRequest, YKSwiftNetworkError)
}

public enum YKSwiftNetworkRequestEncoding {
    case URLEncoding
    case JSONEncoding
}

internal enum YKSwiftNetworkRequestExecuteMode {
    case Normal
    case Upload
    case Download
}

public class YKSwiftNetworkRequest: NSObject, NSCopying
{
    public func copy(with zone: NSZone? = nil) -> Any {
        let request:YKSwiftNetworkRequest = YKSwiftNetworkRequest.init()
        request.name = self.name
        request.urlStr = self.urlStr
        request.params = self.params
        request.header = self.header
        request.method = self.method
        request.disableDynamicParams = self.disableDynamicParams
        request.disableDynamicHeader = self.disableDynamicHeader
        request.disableHandleResponse = self.disableHandleResponse
        request.progressBlock = self.progressBlock
        request.repeatRequestInterval = self.repeatRequestInterval
        request.destPath = self.destPath
        request.uploadFileData = self.uploadFileData
        request.uploadName = self.uploadName
        request.uploadMimeType = self.uploadMimeType
        request.startTimeInterval = self.startTimeInterval
        request.task = self.task
        request.downloadTask = self.downloadTask
        request.formDataName = self.formDataName
        request.isShowLoading = self.isShowLoading
        request.encoding = self.encoding
        request.mockData = self.mockData
        request.httpBody = self.httpBody
        request.executeModel = self.executeModel
        request.handleResponse = self.handleResponse
        request.timeoutInterval = self.timeoutInterval
        return request
    }
    
    public var name:String? = nil
    
    /** 请求地址 */
    public var urlStr:String = ""
    
    /** 请求参数 */    //MARK:rewrite
    public var params:[String:Any] = [:]
    
    /** 请求头 */   //MARK:rewrite
    public var header:[String:String] = [:]
    
    /** 请求方式 */
    public var method:YKNetworkRequestMethod = .GET
    
    /** 获取当前的请求方式(字符串) ***/
    public var methodStr:HTTPMethod{
        get{
            var method:HTTPMethod = .get
            switch self.method {
            case .GET:
                method = .get
            case .POST:
                method = .post
            case .DELETE:
                method = .delete
            case .PUT:
                method = .put
            case .PATCH:
                method = .patch
            default:
                method = .get
            }
            return method
        }
    }
    
    // 编码方式
    public var encoding:YKSwiftNetworkRequestEncoding = .URLEncoding
    
    // 本地数据
    public var mockData:Any? = nil
    
    // httpbody 数据
    public var httpBody: Data? = nil
    
    /** 禁止了动态参数 */  //MARK:rewrite
    public var disableDynamicParams:Bool = false
    
    /** 禁止了动态请求头 */
    public var disableDynamicHeader:Bool = false
    
    /** 是否禁用默认返回处理方式 */
    public var disableHandleResponse:Bool = false
    
    /** 上传/下载进度 */
    public var progressBlock:((_ progress:Double)->Void)?
    
    /** 最短重复请求时间 */   //MARK:rewrite
    public var repeatRequestInterval:Double = 300.00
    
    /** 下载路径 */   //MARK:rewrite
    public var destPath:String = ""
    
    /// 上传文件的二进制
    public var uploadFileData:Data?
    
    /// 上传文件名
    public var uploadName:String?
    
    /// formdata的名字
    public var formDataName:String?
    
    /// mimetype
    public var uploadMimeType:String?
    
    /** 起始时间 */
    public var startTimeInterval:TimeInterval?
    
    /** 请求Task 当启用假数据返回的时候为空 */
    public var task:Request? = nil
    
    /** 下载Task */
    public var downloadTask:URLSessionDownloadTask? = nil
    
    public var isShowLoading:Bool = false
    
    public var timeoutInterval:TimeInterval?
    
    internal var executeModel:YKSwiftNetworkRequestExecuteMode = .Normal
    
    internal var handleResponse:((_ response: YKSwiftNetworkResponse, _ request: YKSwiftNetworkRequest) -> Error?)? = nil
    
    public override init() {
        super.init()
        self.disableDynamicHeader = false
        self.disableDynamicParams = false
        self.disableHandleResponse = false
        self.executeModel = .Normal
    }
}
