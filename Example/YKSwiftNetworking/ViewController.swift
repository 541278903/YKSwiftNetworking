//
//  ViewController.swift
//  YKSwiftNetworking
//
//  Created by 534272374@qq.com on 06/12/2021.
//  Copyright (c) 2021 534272374@qq.com. All rights reserved.
//

import UIKit
import YKSwiftNetworking
import RxSwift

private class TableModel:NSObject {
    
    var name = ""
    
    var callBack:()->Void = {
        
    }
    
    private override init() {
        super.init()
    }
    
    static func model(_ name:String,callBack:@escaping ()->Void) -> TableModel {
        let model = TableModel.init()
        model.name = name
        model.callBack = callBack
        return model
    }
    
}

class ViewController: UIViewController {
    
    private var dataSource:[TableModel] = []
    
    private let disposeBag = DisposeBag()
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: self.view.bounds, style: UITableView.Style.grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        
        return tableView
    }()
    
    private lazy var networking:YKSwiftNetworking = {
        let networking = YKSwiftNetworking.init()
        
        //本次网络请求的统一回调处理
        networking.handleResponse = { response,request in
            // response 为回调体
            // request 为请求头
            
            // 例子
            //  if true {
            //      return NSError.init(domain: "com.yk.network", code: -1)
            //  }
            
            // 进阶  response中的rawData可以替换成需要的数据
            // 例子
            if let data = response.rawData as? Data {
                response.rawData = String.init(data: data, encoding: String.Encoding.utf8)
            }else {
                response.rawData = "测试回调数据"
            }
            // 修改完后，那么请求回调的数据里面就是此处设置的数据
            
            // 返回如果无错误则返回nil，如果回调内容不符合需求可组织Error 然后返回出去
            if true {
                return nil
            }else {
                return NSError.init(domain: "com.yk.network", code: -1)
            }
        }
        
        return networking
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI(self.view)
        bindData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

private extension ViewController {
    
    private func setupUI(_ view:UIView) {
        view.addSubview(self.tableView)
    }
    
    private func bindData() {
        
        self.dataSource.removeAll()
        
        self.dataSource.append(TableModel.model("测试普通请求", callBack: { [weak self] in
            guard let weakself = self else { return }
            weakself.testNormalRequest()
        }))
        
        self.dataSource.append(TableModel.model("测试上传请求", callBack: { [weak self] in
            guard let weakself = self else { return }
            weakself.testUploadRequest()
        }))
        
        self.dataSource.append(TableModel.model("测试下载请求", callBack: { [weak self] in
            guard let weakself = self else { return }
            weakself.testDownloadRequest()
        }))
        
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        model.callBack()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.selectionStyle = .none
        
        let model = self.dataSource[indexPath.row]
        cell.textLabel?.text = model.name
        
        return cell
    }
    
    
}

extension ViewController {
    
    func testNormalRequest() {
        
        var normalnetwork = self.networking.method(.GET).url("https://www.baidu.com")
        
        //添加参数
        normalnetwork = normalnetwork.params(["paramKey":"paramValue"])
        //添加请求头
        normalnetwork = normalnetwork.header(["headerKey":"headerValue"])
        //添加请求进度
        normalnetwork = normalnetwork.progress({ progress in
            //progress 进度的百分比
        })
        // 本次请求中实现的协议，暂时仅支持 URLencoding和JSONEncoding
        normalnetwork = normalnetwork.encoding(.URLEncoding)
        // 本次请求往body中添加内容
        normalnetwork = normalnetwork.httpBody(Data.init(base64Encoded: "{\"test\":\"1\"}"))
        // 本次请求忽略动态头文件
        normalnetwork = normalnetwork.disableDynamicHeader()
        // 本次请求忽略动态参数
        normalnetwork = normalnetwork.disableDynamicParams()
        // 本次请求默认不适用统一处理方式  统一处理方式指 当前networking定义的 handleResponse
        normalnetwork = normalnetwork.disableHandleResponse()
        // 本次请求将不进行网络数据传输，直接返回设定的mock数据
        normalnetwork = normalnetwork.mockData(["123","321"])
        //
        
        //产生请求报文
        let single = normalnetwork.execute()
        
        //申请请求
        single.subscribe(onNext: { (request: YKSwiftNetworkRequest, response: YKSwiftNetworkResponse) in
            //请求成功将返回元组，元组包含 request,response
            //request:此次请求的请求头
            //response:此次请求返回的回调信息
            
        }, onError: { error in
            
        }, onCompleted: {
            
        }, onDisposed: nil).disposed(by: self.disposeBag)
        
        //若想单纯返回请求数据 则添加 mapWithRawData
        single.mapWithRawData().subscribe(onNext: { responseData in
            //请求成功将返回可选值数据
            //responseData:此次请求给到的回调内容
            
        }, onError: { erro in
            
        }, onCompleted: {
            
        }, onDisposed: nil).disposed(by: self.disposeBag)
        
        
        
        // 最后成熟的请求方式
        
        self.networking.get("https://www.baidu.com").params(["paramsKey":"paramsValue"]).header(["headerKey":"headerValue"]).mockData("ceshi".data(using: .utf8) as Any).progress({ progress in
            
        }).execute().mapWithRawData().subscribe(onNext: { responseData in
            print("responseData:\(String(describing: responseData))")
        }, onError: { error in
            
        }, onCompleted: {
            
        }, onDisposed: nil).disposed(by: self.disposeBag)
    }
    
    func testUploadRequest() -> Void {
        
        var normalnetwork = self.networking.method(.POST).url("https://www.baidu.com")
        
        //添加参数
        normalnetwork = normalnetwork.params(["paramKey":"paramValue"])
        //添加请求头
        normalnetwork = normalnetwork.header(["headerKey":"headerValue"])
        //添加上传进度
        normalnetwork = normalnetwork.progress({ progress in
            //progress 进度的百分比
        })
        // 本次请求忽略动态头文件
        normalnetwork = normalnetwork.disableDynamicHeader()
        // 本次请求忽略动态参数
        normalnetwork = normalnetwork.disableDynamicParams()
        // 本次请求默认不适用统一处理方式  统一处理方式指 当前networking定义的 handleResponse
        normalnetwork = normalnetwork.disableHandleResponse()
        
        
        let data = Data.init()
        // 预处理上传数据
        // data:上传的二进制数据
        // filename:文件名
        // mimetype:文件分类名
        // formDataName:当前数据的参数名称（后端根据此字段获取响应数据)
        normalnetwork = normalnetwork.uploadData(data: data, filename: "text.jpeg", mimeType: "image/jpeg", formDataName: "file")
        
        // 本次请求为上传请求
        let single = normalnetwork.uploadDataSignal()
        
        // 本次请求使用统一处理方式
        let singleResponse = single.mapWithRawData()
        
        // 开始执行上传回调
        singleResponse.subscribe(onNext: { responseData in
            
        }, onError: { error in
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
    }
    
    func testDownloadRequest() {
        
        var normalnetwork = self.networking.method(.GET).url("https://www.baidu.com")
        
        //添加参数
        normalnetwork = normalnetwork.params(["paramKey":"paramValue"])
        //添加请求头
        normalnetwork = normalnetwork.header(["headerKey":"headerValue"])
        //添加上传进度
        normalnetwork = normalnetwork.progress({ progress in
            //progress 进度的百分比
        })
        // 本次请求忽略动态头文件
        normalnetwork = normalnetwork.disableDynamicHeader()
        // 本次请求忽略动态参数
        normalnetwork = normalnetwork.disableDynamicParams()
        // 本次请求默认不适用统一处理方式  统一处理方式指 当前networking定义的 handleResponse
        normalnetwork = normalnetwork.disableHandleResponse()
        // 本次下载请求的保存路径，仅需要针对获取路径的文件夹名即可，我将自动保存在cache沙盒中，并自动使用服务器下载的文件名
        normalnetwork = normalnetwork.downloadDestPath("download/jpeg")
        
        let single = normalnetwork.downloadDataSignal()
        
        let singleResponse = single.mapWithRawData()
        
        singleResponse.subscribe(onNext: { responseData in
            
        }, onError: { error in
            
        }, onCompleted: {
            
        }, onDisposed: nil).disposed(by: self.disposeBag)
    }
}
