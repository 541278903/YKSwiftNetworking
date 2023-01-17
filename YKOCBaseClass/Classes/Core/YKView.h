//
//  YYKView.h
//  YYKPodLib_Sec
//
//  Created by edward on 2020/5/26.
//  Copyright © 2020 edward. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YKViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface YKView : UIView

/**点击响应*/
@property(nonatomic,copy) void(^handleBlock)(NSString * _Nonnull eventName,NSDictionary * _Nullable dictionary);

/// 在init(Frame:)自动执行
- (void)autoExecute;

/// UI构建
- (void)didSetupUI:(UIView *)view;

/// 数据绑定
- (void)didBindData;

/// UI稳定刷新
- (void)didLayoutSubviews:(UIEdgeInsets)safeArea;

- (void)configDataWithViewModel:(YKViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
