//
//  YKBaseViewModel.m
//  YYKPodLib_Sec
//
//  Created by edward on 2020/5/26.
//  Copyright © 2020 edward. All rights reserved.
//

#import "YKViewModel.h"

@interface YKViewModel ()
/**网络请求*/
@property (nonatomic, strong,readwrite) YKNetWorking *netWorking;

@end

@implementation YKViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        self.size = 20;
    }
    return self;
}

- (void)handlePageData:(NSMutableArray *)datas newDatas:(NSArray *)newData
{
    NSAssert(datas,@"datas should not be nil");
    if (self.page == 1) {
        [datas removeAllObjects];
    }
    [datas addObjectsFromArray:newData];
}


- (YKNetWorking *)netWorking
{
    if(!_netWorking)
    {
        _netWorking = [[YKNetWorking alloc]init];
        __weak typeof(self) weakSelf = self;
        _netWorking.dynamicParamsConfig = ^NSDictionary * _Nonnull(YKNetworkRequest * _Nonnull request) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (request.method != YKNetworkRequestMethodGET) return nil;
            return @{@"size":@(strongSelf.size).stringValue,@"page":@(strongSelf.page).stringValue};
        };
    }
    return _netWorking;
}




@end
