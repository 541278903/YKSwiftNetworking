# YKSwiftNetworking
[![CI Status](https://img.shields.io/travis/534272374@qq.com/YKSwiftNetworking.svg?style=flat)](https://travis-ci.org/534272374@qq.com/YKSwiftNetworking)
[![Version](https://img.shields.io/cocoapods/v/YKSwiftNetworking.svg?style=flat)](https://cocoapods.org/pods/YKSwiftNetworking)
[![License](https://img.shields.io/cocoapods/l/YKSwiftNetworking.svg?style=flat)](https://cocoapods.org/pods/YKSwiftNetworking)
[![Platform](https://img.shields.io/cocoapods/p/YKSwiftNetworking.svg?style=flat)](https://cocoapods.org/pods/YKSwiftNetworking)
## 介绍

* 基于Alamofire的二次封装
* 链式编程
* 添加对RxSwift的拓展

## 引入 YKSwiftNetworking

```
pod 'YKSwiftNetWorking'
```

### 开始使用

#### 初始化

###### 默认初始化

```
var normalnetwork = YKSwiftNetworking.init()
```

###### 复杂初始化

```
var normalnetwork = YKSwiftNetworking.init(["header":"header"],["param":"param"]) { request, response in
    return nil
}
```

###### 参数

| 参数           | 类型                                                         | 名称                       | 备注                                                         |
| -------------- | ------------------------------------------------------------ | -------------------------- | ------------------------------------------------------------ |
| defaultHeader  | [String:String]                                              | 默认头部                   | 本对象所发起的所有请求均加入本次的默认头部                   |
| defaultParams  | [String:Any]                                                 | 默认参数                   | 本对象所发起的所有请求均加入本次的默认参数                   |
| prefixUrl      | String                                                       | 默认请求url前缀            | 本对象所发起的所有请求均已此为前缀后续所发起的所有请求均只需要设置路由即可 |
| handleResponse | (_ response:YKSwiftNetworkResponse, _ request:YKSwiftNetworkRequest)->Error? | 默认请求成功执行的回调信息 | 本对象所发起的所有请求均使用本次设置的回调响应Block，即每次请求响应成功后即会执行本回调，即能及时对请求数据进行预处理 |

##### 选择模式及设置地址

###### 详细设置

```
GET模式
normalnetwork = normalnetwork.method(.GET).url("https://ios.tipsoon.com")
POST模式
normalnetwork = normalnetwork.method(.POST).url("https://ios.tipsoon.com")
```

###### 快捷设置

```
GET模式
normalnetwork = normalnetwork.get("https://ios.tipsoon.com")
POST模式
normalnetwork = normalnetwork.post("https://ios.tipsoon.com")
```

| 参数   | 类型   | 名称 | 备注                       |
| ------ | ------ | ---- | -------------------------- |
| method | String | 模式 | 本对象的本次发起的请求模式 |
| url    | String | 地址 |                            |

###### 添加动态参数

```
normalnetwork = normalnetwork.params(["paramKey":"paramValue"])
```

| 参数   | 类型         | 名称     | 备注                                   |
| ------ | ------------ | -------- | -------------------------------------- |
| params | [String:Any] | 动态参数 | 本对象的本次发起的请求所添加的动态参数 |

###### 添加请求头

```
normalnetwork = normalnetwork.header(["headerKey":"headerValue"])
```

| 参数   | 类型            | 名称       | 备注                                     |
| ------ | --------------- | ---------- | ---------------------------------------- |
| header | [String:String] | 动态请求头 | 本对象的本次发起的请求所添加的动态请求头 |

###### 设置请求进度回调

```
normalnetwork = normalnetwork.progress({ progress in
        //progress 进度的百分比
})
```

| 参数     | 类型                      | 名称         | 备注                             |
| -------- | ------------------------- | ------------ | -------------------------------- |
| progress | (_ progress:Double)->Void | 请求进度回调 | 本对象的本次发起的请求的请求进度 |

###### 设置请求实现的协议

```
normalnetwork = normalnetwork.encoding(.URLEncoding)
```

| 参数     | 类型                          | 名称     | 备注                         |
| -------- | ----------------------------- | -------- | ---------------------------- |
| encoding | YKSwiftNetworkRequestEncoding | 请求协议 | 本对象的本次发起的请求的协议 |

###### 设置请求模拟数据

```
normalnetwork = normalnetwork.mockData(Any)
```

| 参数     | 类型 | 名称         | 备注                         |
| -------- | ---- | ------------ | ---------------------------- |
| mockData | Any  | 请求模拟数据 | 本对象的本次请求模拟回调内容 |

###### 设置请求往body中添加内容

```
normalnetwork = normalnetwork.httpBody(Data.init(base64Encoded: "{\"test\":\"1\"}"))
```

| 参数     | 类型  | 名称             | 备注                                 |
| -------- | ----- | ---------------- | ------------------------------------ |
| httpBody | Data? | 请求body加入内容 | 本对象的本次发起的请求加入body的内容 |

###### 设置请求为上传请求

```
let data = UIImageJPEGRepresentation(UIImage.init(named: "test.jpg")!, 0.1)!
normalnetwork = normalnetwork.uploadData(data: data, filename: "text.jpeg", mimeType: "image/jpeg", formDataName: "file")
```

| 参数         | 类型   | 名称               | 备注                       |
| ------------ | ------ | ------------------ | -------------------------- |
| data         | Data   | 上传的二进制数据   |                            |
| filename     | String | 文件名             | 如：text.jpeg              |
| mimeType     | String | 文件分类名         | 如：image/jpeg             |
| formDataName | String | 当前数据的参数名称 | 后端根据此字段获取响应数据 |

###### 设置请求为下载请求

```
normalnetwork = normalnetwork.downloadDestPath("download/jpeg")
```

| 参数             | 类型   | 名称     | 备注                                                |
| ---------------- | ------ | -------- | --------------------------------------------------- |
| downloadDestPath | String | 路径path | 最终完整的下载路径为cache+'设置的path'+‘下载文件名' |

## 引入RxSwift

```
pod 'YKSwiftNetWorking/RxSwift'
```

## 开始

```
//唯一跟普通的区别在执行的内容
var normalnetwork = YKSwiftNetworking.init()

//产生请求报文
let single = normalnetwork.rx.request()

//申请请求
single.subscribe(onNext: { data in

}).dispose()
```





