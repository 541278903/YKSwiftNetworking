//
//  YKNetworkingConfig.m
//  MMCNetworkingDemo
//
//  Created by Arclin on 2018/4/28.
//

#import "YKNetworkingConfig.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface YKNetworkingConfig ()

/// 网络状态
@property(nonatomic,assign,readwrite) YKNetworkingOnlineStatus status;
/// 网络状态
@property(nonatomic,assign,readwrite) AFNetworkReachabilityStatus afStatus;

@end

@implementation YKNetworkingConfig

static YKNetworkingConfig *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(changeStatus:) name:@"toConfig" object:nil];
    });
    return _instance;
}

+ (instancetype)defaultConfig {
    if (!_instance) {
        _instance = [[self alloc] init];
        _instance.distinguishError = YES;
        _instance.timeoutInterval = 30;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[AFNetworkReachabilityManager sharedManager] startMonitoring];
            [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                [[NSNotificationCenter defaultCenter] postNotificationName:yk_networking_NetworkStatus object:nil userInfo:@{@"status":@(status)}];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"toConfig" object:nil userInfo:@{@"status":@(status)}];
            }];
        });
    }
    return _instance;
}

- (void)changeStatus:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    self.afStatus = [dic[@"status"]?:@"0" integerValue];
    if (self.afStatus == AFNetworkReachabilityStatusUnknown) {
        self.status = YKNetworkingOnlineStatusUnknown;
    }else if (self.afStatus == AFNetworkReachabilityStatusNotReachable) {
        self.status = YKNetworkingOnlineStatusNotReachable;
    }else if (self.afStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        self.status = YKNetworkingOnlineStatusReachableViaWWAN;
    }else if (self.afStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        self.status = YKNetworkingOnlineStatusReachableViaWiFi;
    }
}

- (void)setParams:(NSDictionary *)params responseObj:(id)responseObj forUrl:(NSString *)url {
    
}

@end
