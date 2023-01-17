//
//  YKTableViewHeaderFooterView.h
//  YYKPodLib_Sec
//
//  Created by edward on 2020/11/23.
//  Copyright © 2020 edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YKOCBaseClass/YKViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKTableViewHeaderFooterView : UITableViewHeaderFooterView


/**点击响应*/
@property(nonatomic,copy) void(^handleBlock)(NSString * _Nonnull eventName,NSInteger section, NSDictionary * _Nonnull userInfo);

/// 在init(Frame:)自动执行
- (void)autoExecute;

/// UI构建
- (void)didSetupUI:(UIView *)view;

- (void)configDataWithViewModel:(YKViewModel *)viewModel atSection:(NSInteger)section;

/// 绑定viewModel
/// @param viewModel viewmodel
- (void)configDataWithViewModel:(YKViewModel *)viewModel;


@end

NS_ASSUME_NONNULL_END
