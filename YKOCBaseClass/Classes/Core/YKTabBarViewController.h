//
//  YKTabBarViewController.h
//  YKOCBaseClass
//
//  Created by edward on 2021/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKTabBarViewController : UITabBarController

/// 在viewdidload自动执行
- (void)autoExecute;

/// UI构建
- (void)didSetupUI:(UIView *)view;

- (void)didBindData;

@end

NS_ASSUME_NONNULL_END
