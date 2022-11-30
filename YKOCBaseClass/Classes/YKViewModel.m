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

/**本地缓存*/
@property (nonatomic, strong,readwrite) YKBaseDBManager *dbManager;

/**错误集合*/
@property (nonatomic, strong,readwrite) RACSubject<NSError *> *errorSubject;
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

- (RACSubject<NSError *> *)errorSubject
{
    if(!_errorSubject) {
        _errorSubject = [RACSubject subject];
    }
    return _errorSubject;
}

- (YKNetWorking *)netWorking
{
    if(!_netWorking)
    {
        _netWorking = [[YKNetWorking alloc]init];
        _netWorking.delegate = self;
        @weakify(self);
        _netWorking.dynamicParamsConfig = ^NSDictionary * _Nonnull(YKNetworkRequest * _Nonnull request) {
            @strongify(self);
            if (request.method != YKNetworkRequestMethodGET) return nil;
            return @{@"size":@(self.size).stringValue,@"page":@(self.page).stringValue};
        };
    }
    return _netWorking;
}

- (YKBaseDBManager *)dbManager
{
    if (!_dbManager) {
        _dbManager = [YKBaseDBManager sharedInstance];
    }
    return _dbManager;
}

- (void)cacheRequest:(YKNetworkRequest *)request resonse:(YKNetworkResponse *)resonse isException:(BOOL)isException
{
    
}

@end
