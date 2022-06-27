//
//  YKSwiftNetworkingConfig.swift
//  YK_Swift_Networking
//
//  Created by edward on 2021/6/12.
//

import Foundation


public class YKSwiftNetworkingConfig: NSObject
{
    public static let share:YKSwiftNetworkingConfig = YKSwiftNetworkingConfig.init()
    
    /** 超时时间 默认30秒 */
    public var timeoutInterval:Double = 30.0
    
    /** 公用头部 */
    public var defaultHeader:[String:String]?
    
    /** 公用参数 */
    public var defaultParams:[String:Any]?

    /** 公用url前缀 */
    public var defaultPrefixUrl:String?
    
    /**
     区分业务错误（200情况下执行handleResponse）和 网络链接错误（400+、500+类下执行handleError）
     若为false时 400+、500+类错误下 handleResponse 和 handleError 将会同时执行
     默认为true
     */
    public var distinguishError:Bool = true
    
    /** 动态添加参数，每次执行网络请求前都会访问一遍 修改的值优先级最低 */
    public var dynamicParamsConfig:((_ request:YKSwiftNetworkRequest)->[String:Any]?)?
    
    /** 动态添加请求头，每次执行网络请求前都会访问一遍 修改的值优先级最低 */
    public var dynamicHeaderConfig:((_ request:YKSwiftNetworkRequest)->[String:String]?)?
    
    
    /** 正在加载 */
    private var loadingHandle:((_ loading:Bool) -> Void)?
    
    /// 设置加载回调
    /// - Parameter loadingCallBack: 加载回调
    public func toSetLoadingHandle(loadingCallBack:@escaping (_ loading:Bool) -> Void) {
        self.loadingHandle = loadingCallBack
    }
    
    /** 根据需求设置缓存内容 */
    public var cacheRequest:((_ response:YKSwiftNetworkResponse,_ request:YKSwiftNetworkRequest, _ isException:Bool)->Void)?
    
    
    /**
     ❌暂不支持此方法
     设置特定的参数和响应体, 一般是用来做假数据用，需要在请求链中使用MMCCacheStrategyCacheOnly，使用其他缓存机制有可能会被网络数据覆盖

     @param params 参数
     @param responseObj 响应体
     @param url 接口地址
     */
    
    @available (*,deprecated)
    public func setParams(params:[String:Any], responseObj:Any, forUrl:String)->Void{
//        String.flatMap("")
    }
    
    private override init() {
        super.init()
    }
    
}
