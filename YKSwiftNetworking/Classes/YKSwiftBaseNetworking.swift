//
//  YKSwiftBaseNetworking.swift
//  YKSwiftNetworking
//
//  Created by edward on 2021/9/1.
//

import UIKit
import Alamofire
import SwiftyJSON

internal class YKSwiftBaseNetworking: NSObject {
    
    static func request(request:YKSwiftNetworkRequest, progressCallBack:@escaping (_ progress:Double )->Void, successCallBack:@escaping (_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Void, failureCallBack:@escaping (_ request:YKSwiftNetworkRequest, _ isCache:Bool, _ responseObject:Any?, _ error:Error?)->Void) -> Request?
    {
        YKSwiftBaseNetworking.configWith(request: request)
        
        if request.mockData != nil {
            let ykresponse = YKSwiftNetworkResponse.init()
            ykresponse.rawData = YKSwiftBaseNetworking.resultToChang(data: request.mockData!)
            ykresponse.isCache = false
            ykresponse.code = 200
            successCallBack(ykresponse,request)
            return nil
        }
        
        var encoding:ParameterEncoding = URLEncoding.default
        if request.encoding == .JSONEncoding {
            encoding = JSONEncoding.default
        }
        let af = Alamofire.request(request.urlStr, method: request.methodStr, parameters: request.params, encoding: encoding, headers: request.header).downloadProgress { progress in
            progressCallBack(progress.fractionCompleted)
        }
        
        let task = af.response { [weak request] response in
            
            guard let req = request else { return }
            if response.error != nil {
                failureCallBack(req,false,nil,response.error)
            } else {
                let ykresponse = YKSwiftNetworkResponse.init()
                ykresponse.rawData = YKSwiftBaseNetworking.resultToChang(data: response.data)
                ykresponse.isCache = false
                ykresponse.code = response.response?.statusCode ?? 0
                
                successCallBack(ykresponse,req)
            }
            
        }.downloadProgress { progress in
            progressCallBack(progress.fractionCompleted)
        }
        
        
        
        task.resume()
        
        return task
    }
    
    static func upload(request:YKSwiftNetworkRequest, progressCallBack:@escaping (_ progress:Double )->Void, successCallBack:@escaping (_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Void, failureCallBack:@escaping (_ request:YKSwiftNetworkRequest, _ isCache:Bool, _ responseObject:Any?, _ error:Error?)->Void)
    {
        YKSwiftBaseNetworking.configWith(request: request)
        
        if request.mockData != nil {
            let ykresponse = YKSwiftNetworkResponse.init()
            ykresponse.rawData = YKSwiftBaseNetworking.resultToChang(data: request.mockData!)
            ykresponse.isCache = false
            ykresponse.code = 200
            successCallBack(ykresponse,request)
            return
        }
        
        Alamofire.upload(multipartFormData: { [weak request] multipartFormData in
            guard let req = request else { return }

            for (key,value) in req.params {
                let data = "\(value)".data(using: String.Encoding.utf8) ?? Data.init()
                multipartFormData.append(data, withName: key)
            }
            multipartFormData.append(req.uploadFileData!, withName: req.formDataName!, fileName: req.uploadName!, mimeType: req.uploadMimeType!)
        }, to: request.urlStr, method: request.methodStr, headers: request.header) { encodingResult in
            switch encodingResult{
                case .success(request: let upladtRequest, streamingFromDisk: _, streamFileURL: _):do {
                    
                    upladtRequest.uploadProgress { progress in
                        progressCallBack(progress.fractionCompleted)
                    }
                    
                    upladtRequest.response { response in
                        if response.error != nil {
                            failureCallBack(request,false,nil,response.error)
                        } else {
                            let ykresponse = YKSwiftNetworkResponse.init()
                            ykresponse.rawData = YKSwiftBaseNetworking.resultToChang(data: response.data)
                            ykresponse.isCache = false
                            ykresponse.code = response.response?.statusCode ?? 0
                            successCallBack(ykresponse,request)
                        }
                    }
                    break
                }
                case .failure(let error):do {
                    failureCallBack(request,false,nil,error)
                    break
                }
            }
        }
    }
    
    static func download(request:YKSwiftNetworkRequest, progressCallBack:@escaping (_ progress:Double )->Void, successCallBack:@escaping (_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Void, failureCallBack:@escaping (_ request:YKSwiftNetworkRequest, _ isCache:Bool, _ responseObject:Any?, _ error:Error?)->Void) -> Request?
    {
        YKSwiftBaseNetworking.configWith(request: request)
        
        if request.mockData != nil {
            let ykresponse = YKSwiftNetworkResponse.init()
            ykresponse.rawData = YKSwiftBaseNetworking.resultToChang(data: request.mockData!)
            ykresponse.isCache = false
            ykresponse.code = 200
            successCallBack(ykresponse,request)
            return nil
        }
            
        let destination: DownloadRequest.DownloadFileDestination = { [weak request] url, options in
            var documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]

            if let req = request {
                let urllastPathComponent = URL.init(string: req.urlStr)!.lastPathComponent
                
                if req.destPath.count > 0 {
                    if (req.destPath as NSString).substring(to: 1) == "/" {
                        documentsURL.appendPathComponent((req.destPath as NSString).substring(from: 1))
                    }else {
                        documentsURL.appendPathComponent(req.destPath)
                    }
                }
                var isDic: ObjCBool = ObjCBool(false)
                let exists: Bool = FileManager.default.fileExists(atPath: documentsURL.relativePath, isDirectory: &isDic)
                if exists && isDic.boolValue {
                    // Exists. Directory.
                    documentsURL.appendPathComponent("\(urllastPathComponent)")
                } else if exists {
                    // Exists.
                } else {
                    try? FileManager.default.createDirectory(atPath: documentsURL.relativePath, withIntermediateDirectories: true, attributes: nil)
                    documentsURL.appendPathComponent("\(urllastPathComponent)")

                }
            }
            
            return (documentsURL, [.removePreviousFile,.createIntermediateDirectories])
       }
        
        var encoding:ParameterEncoding = URLEncoding.default
        if request.encoding == .JSONEncoding {
            encoding = JSONEncoding.default
        }
        
        let af = Alamofire.download(request.urlStr, method: request.methodStr, parameters: request.params, encoding: encoding, headers: request.header, to: destination).downloadProgress { progress in
            progressCallBack(progress.fractionCompleted)
        }
        
        let task = af.response { response in
            
            if response.error != nil {
                failureCallBack(request, false, nil, response.error)
            } else {
                let ykresponse = YKSwiftNetworkResponse.init()
                ykresponse.rawData = ["url":response.destinationURL!.relativeString]
                ykresponse.isCache = false
                ykresponse.code = response.response?.statusCode ?? 0
                successCallBack(ykresponse, request)
            }
        }
        task.resume()
        return task
    }

    
}

private extension YKSwiftBaseNetworking {
    
    static func configWith(request:YKSwiftNetworkRequest) -> Void {
        
    }
    
    static func resultToChang(data:Any?)->Any?
    {
        if let jsonData = data as? Data,
           let json = try? JSON.init(data: jsonData)
        {
            if json.dictionary != nil {
                
                return json.dictionaryObject
            }else if json.array != nil {
                
                return json.arrayObject
            }else if json.string != nil {
                
                return json.stringValue
            }else if json.bool != nil {
                
                return json.boolValue
            }else if json.number != nil {
                
                return json.numberValue
            }else if json.error != nil {
                return json.error!
            }else{
                return json.object
            }
        }else {
            return data
        }
    }
}
