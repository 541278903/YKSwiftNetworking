//
//  YKNetWorking+RAC.h
//  YKNetWorking
//
//  Created by edward on 2022/9/30.
//


#import "YKNetWorking.h"
#import "RACSignal+networking.h"


NS_ASSUME_NONNULL_BEGIN




@interface YKNetWorking (RAC)



/// 执行信号返回一个RACTuple的信号量
/// @warning 返回的是一个元组（元组中包含 请求头 requesest(YKNetworkRequest)  响应报文response(YKNetworkResponse))
- (RACSignal<RACTuple *> *)executeSignal;



@end

NS_ASSUME_NONNULL_END
