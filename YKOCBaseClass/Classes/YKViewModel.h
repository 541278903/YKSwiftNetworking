//
//  YKBaseViewModel.h
//  YYKPodLib_Sec
//
//  Created by edward on 2020/5/26.
//  Copyright © 2020 edward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <YKNetWorking/YKNetWorking.h>
#import <YKDB/YKDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKViewModel : NSObject<YKNetWorkingDelegate>
 
/**网络请求*/
@property (nonatomic, strong,readonly) YKNetWorking *netWorking;

/**本地缓存*/
@property (nonatomic, strong,readonly) YKBaseDBManager *dbManager;

/**错误集合*/
@property (nonatomic, strong,readonly) RACSubject<NSError *> *errorSubject;


@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) NSInteger page;

- (void)handlePageData:(NSMutableArray *)datas newDatas:(NSArray *)newData;

@end

NS_ASSUME_NONNULL_END
