//
//  YKNetWorkingConst.h
//  YKNetWorking
//
//  Created by edward on 2021/8/2.
//

#ifndef YKNetWorkingConst_h
#define YKNetWorkingConst_h


#define get(urlStr) url(urlStr).method(YKNetworkRequestMethodGET)
#define post(urlStr) url(urlStr).method(YKNetworkRequestMethodPOST)
#define put(urlStr) url(urlStr).method(YKNetworkRequestMethodPUT)
#define patch(urlStr) url(urlStr).method(YKNetworkRequestMethodPATCH)
#define delete(urlStr) url(urlStr).method(YKNetworkRequestMethodDELETE)

#define GET(urlStr,...)       url(urlStr).method(YKNetworkRequestMethodGET).params(NSDictionaryOfVariableBindings(__VA_ARGS__))
#define POST(urlStr,...)      url(urlStr).method(YKNetworkRequestMethodPOST).params(NSDictionaryOfVariableBindings(__VA_ARGS__))
#define PUT(urlStr,...)       url(urlStr).method(YKNetworkRequestMethodPUT).params(NSDictionaryOfVariableBindings(__VA_ARGS__))
#define DELETE(urlStr,...)    url(urlStr).method(YKNetworkRequestMethodPATCH).params(NSDictionaryOfVariableBindings(__VA_ARGS__))
#define PATCH(urlStr,...)     url(urlStr).method(YKNetworkRequestMethodDELETE).params(NSDictionaryOfVariableBindings(__VA_ARGS__))

#define kNoCacheErrorCode -10992

/// 监听网络状态的通知
#define yk_networking_NetworkStatus @"yk_networking_NetworkStatus"


/**
 参数传输类型

 - YKNetworkRequestParamsTypeDictionary: 二进制
 - YKNetworkRequestParamsTypeJSON: JSON
 */
typedef NS_ENUM(NSInteger, YKNetworkRequestParamsType) {
    YKNetworkRequestParamsTypeDictionary        = 0,
    YKNetworkRequestParamsTypeJSON
};

typedef NS_ENUM(NSInteger, YKNetworkRequestMethod) {
    YKNetworkRequestMethodGET                  = 0,
    YKNetworkRequestMethodPOST,
    YKNetworkRequestMethodPUT,
    YKNetworkRequestMethodPATCH,
    YKNetworkRequestMethodDELETE,
};

typedef NS_ENUM(NSInteger, YKNetworkResponseType) {
    YKNetworkResponseTypeJSON = 0,
    YKNetworkResponseTypeHTTP,
    YKNetworkResponseTypeXML,
    YKNetworkResponseTypeImage,
    YKNetworkResponseTypePlist,
    YKNetworkResponseTypeAnyThing,
};

#endif /* YKNetWorkingConst_h */
