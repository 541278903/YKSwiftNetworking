//
//  YKBaseViewController.h
//  YYKPodLib_Sec
//
//  Created by edward on 2020/10/16.
//  Copyright © 2020 edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKBaseViewController : UIViewController

/**
 Notification:
 Debug:
 kShowBaseDeviceInfoNotification --通知设备号
 ✨ ✨Lookin_3D     --构建3D图像  需要配合  LokinService     Podfile中添加     pod 'LookinServer', :configurations => ['Debug']✨✨
 */

/// 隐藏导航栏（避免从有导航栏的界面侧滑返回到无导航栏的界面时，出现导航栏闪动的问题，请使用这个方法隐藏导航栏）
@property (nonatomic, assign) BOOL yk_hideNavigationBar;

/// 禁止侧滑返回
@property (nonatomic, assign) BOOL yk_disablePopGesture;

/// 禁止默认摇一摇
@property (nonatomic, assign) BOOL yk_disableDEBUGShake;

/// 返回按钮的字体（但没有实时刷新）
@property (nonatomic, copy) NSString *backItemTitle;

///
@property (nonatomic,assign,readonly) BOOL isiPad;

///
@property (nonatomic,assign,readonly) UIUserInterfaceStyle userInterfaceStyle API_AVAILABLE(ios(12.0));
///
@property (nonatomic,assign,readonly) UIDeviceOrientation orientation API_UNAVAILABLE(tvos);

/// 在viewdidload自动执行
- (void)autoExecute;

/// UI构建
- (void)didSetupUI:(UIView *)view;

/// 数据绑定
- (void)didBindData;

/// UI稳定刷新
- (void)didLayoutSubviews:(UIEdgeInsets)safeArea;

/// debug模式摇一摇action
- (NSMutableArray<UIAlertAction *> *)debugShakeActions;

- (void)changeUserInterfaceStyle:(UIUserInterfaceStyle)style API_AVAILABLE(ios(12.0));

@end

NS_ASSUME_NONNULL_END
