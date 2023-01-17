//
//  YKNavigationController.h
//  YYKPodLib_Sec
//
//  Created by edward on 2020/10/10.
//  Copyright © 2020 edward. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKNavigationController : UINavigationController


@property (nonatomic, strong) UIColor *foregroundColor;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIImage *shadowImage;
///
@property (nonatomic, strong) UIColor *tabbarBackgroundColor;
///
@property (nonatomic, strong) UIColor *tabbarNormalItemTextColor;
///
@property (nonatomic, strong) UIColor *tabbarSelectItemTextColor;
///
@property (nonatomic, strong) UIImage *tabbarSelectedImage;
///
@property (nonatomic, strong) UIImage *tabbarNormalImage;
///
@property (nonatomic, copy) NSString *tabbarTitle;

/** 返回按钮 */
@property (nonatomic, strong, readonly) UIButton *backBtn;

/** 返回按钮颜色 */
@property (nonatomic, strong) UIColor *backButtonColor;

/** 返回按钮显示文字 */
@property (nonatomic, copy) NSString *backBtnTitle;

/** 最后push的controller的类名 */
@property (nonatomic, copy, readonly) NSString *latestPushViewControllerName;

@property (nonatomic, strong) id transition;

@end

NS_ASSUME_NONNULL_END
