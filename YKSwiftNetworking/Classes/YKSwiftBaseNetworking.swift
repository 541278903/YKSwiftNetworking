//
//  YKSwiftBaseNetworking.swift
//  YKSwiftNetworking
//
//  Created by linghit on 2021/9/1.
//

import UIKit
import Alamofire
import SwiftyJSON

internal class YKSwiftBaseNetworking: NSObject {
    
    public static func request(request:YKSwiftNetworkRequest, progressCallBack:@escaping (_ progress:Double )->Void, successCallBack:@escaping (_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Void, failureCallBack:@escaping (_ request:YKSwiftNetworkRequest, _ isCache:Bool, _ responseObject:Any?, _ error:Error?)->Void)->Request
    {
        configWith(request: request)
        
        let task = Alamofire.request(request.urlStr, method: request.methodStr, parameters: request.params, encoding: URLEncoding.default, headers: request.header).response { [weak request] response in
            
            if response.error != nil {
                failureCallBack(request!,false,nil,response.error)
            } else {
                let ykresponse = YKSwiftNetworkResponse.init()
                ykresponse.rawData = self.resultToChang(data: response.data)
                ykresponse.isCache = false
                ykresponse.code = response.response?.statusCode ?? 0
                
                successCallBack(ykresponse,request!)
            }
            
        }.downloadProgress { progress in
            progressCallBack(progress.fractionCompleted)
        }
        
        
        
        task.resume()
        if request.isShowLoading {
            
        }
        return task
    }
    
    public static func upload(request:YKSwiftNetworkRequest, progressCallBack:@escaping (_ progress:Double )->Void, successCallBack:@escaping (_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Void, failureCallBack:@escaping (_ request:YKSwiftNetworkRequest, _ isCache:Bool, _ responseObject:Any?, _ error:Error?)->Void)
    {
        configWith(request: request)
        
        Alamofire.upload(multipartFormData: { [weak request] multipartFormData in
            multipartFormData.append(request!.uploadFileData!, withName: request!.formDataName!, fileName: request!.uploadName!, mimeType: request!.uploadMimeType!)
        }, to: request.urlStr) { [weak request] encodingResult in
            switch encodingResult{
                case .success(request: let upladtRequest, streamingFromDisk: _, streamFileURL: _):do {
                    request!.task = upladtRequest
                    upladtRequest.uploadProgress { progress in
                        progressCallBack(progress.fractionCompleted)
                    }
                    upladtRequest.response { response in
                        if response.error != nil {
                            failureCallBack(request!,false,nil,response.error)
                        } else {
                            let ykresponse = YKSwiftNetworkResponse.init()
                            ykresponse.rawData = self.resultToChang(data: response.data)
                            ykresponse.isCache = false
                            ykresponse.code = response.response?.statusCode ?? 0
                            successCallBack(ykresponse,request!)
                        }
                    }
                    break
                }
                case .failure(let error):do {
                    failureCallBack(request!,false,nil,error)
                    break
                }
            }
        }
    }
    
    public static func download(request:YKSwiftNetworkRequest, progressCallBack:@escaping (_ progress:Double )->Void, successCallBack:@escaping (_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Void, failureCallBack:@escaping (_ request:YKSwiftNetworkRequest, _ isCache:Bool, _ responseObject:Any?, _ error:Error?)->Void)->Request
    {
        configWith(request: request)
            
        let destination: DownloadRequest.DownloadFileDestination = { [weak request] url, options in
            var documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]

            let urllastPathComponent = URL.init(string: request!.urlStr)!.lastPathComponent
            
            if request!.destPath.count > 0 {
                documentsURL.appendPathComponent(request!.destPath)
            }
            var isDic: ObjCBool = ObjCBool(false)
            let exists: Bool = FileManager.default.fileExists(atPath: documentsURL.relativeString, isDirectory: &isDic)
            if exists && isDic.boolValue {
                // Exists. Directory.
                documentsURL.appendPathComponent("\(urllastPathComponent)")
            } else if exists {
                // Exists.
            } else {
                try? FileManager.default.createDirectory(atPath: documentsURL.relativeString, withIntermediateDirectories: true, attributes: nil)
                documentsURL.appendPathComponent("\(urllastPathComponent)")

            }
            return (documentsURL, [.createIntermediateDirectories])
       }
        
        let task = Alamofire.download(request.urlStr, method: request.methodStr, parameters: request.params, encoding: URLEncoding.default, headers: request.header, to: destination).downloadProgress { progress in
            progressCallBack(progress.fractionCompleted)
        }.response { [weak request] response in
            
            if response.error != nil {
                failureCallBack(request!,false,nil,response.error)
            } else {
                let ykresponse = YKSwiftNetworkResponse.init()
                ykresponse.rawData = response.destinationURL!.relativeString
                ykresponse.isCache = false
                ykresponse.code = response.response?.statusCode ?? 0
                successCallBack(ykresponse,request!)
            }
        }
        task.resume()
        return task
    }

    private static func configWith(request:YKSwiftNetworkRequest) -> Void {
        
    }
    
    private static func resultToChang(data:Any?)->Any?
    {
        if data is Data && data != nil {
            let json = try? JSON.init(data: data as! Data)
            if json != nil {
                if json!.dictionary != nil {
                    
                    return json!.dictionaryObject
                }else if json!.array != nil {
                    
                    return json!.arrayObject
                }else if json!.string != nil {
                    
                    return json!.stringValue
                }else if json!.bool != nil {
                    
                    return json!.boolValue
                }else if json!.number != nil {
                    
                    return json!.numberValue
                }else if json!.error != nil {
                    return json!.error!
                }else{
                    return json!.object
                }
            }
        }
        return data
    }
}
