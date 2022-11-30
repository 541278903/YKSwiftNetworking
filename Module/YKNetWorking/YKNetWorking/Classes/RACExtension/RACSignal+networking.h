//
//  RACSignal+networking.h
//  YK_BaseMediator
//
//  Created by edward on 2020/11/10.
//  Copyright © 2020 Edward. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "YKBlockTrampoline.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACSignal (networking)
/**
 把RawData映射出来

 @return 信号
 */
- (RACSignal *)mapWithRawData;

/**
 映射出RawData中的某个键中的值 必须是rawdata为字典
 */
- (RACSignal *(^)(NSString *))mapWithSomething;

@end

NS_ASSUME_NONNULL_END
