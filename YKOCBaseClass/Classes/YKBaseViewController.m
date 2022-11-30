//
//  YKBaseViewController.m
//  YYKPodLib_Sec
//
//  Created by edward on 2020/10/16.
//  Copyright © 2020 edward. All rights reserved.
//

#import "YKBaseViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface YKBaseViewController ()
///
@property (nonatomic,assign) BOOL isiPad;
///
@property (nonatomic,assign) UIUserInterfaceStyle userInterfaceStyle API_AVAILABLE(ios(12.0));

@end

@implementation YKBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backItemTitle = @"返回";
        self.yk_hideNavigationBar = NO;
        self.yk_disablePopGesture = NO;
        self.yk_disableDEBUGShake = NO;

        if (@available(iOS 13.0, *)) {
            self.userInterfaceStyle = [UITraitCollection currentTraitCollection].userInterfaceStyle;
        }
    }
    return self;
}

- (BOOL)isiPad
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
#ifdef DEBUG
    NSLog(@"viewDidAppear:%@",NSStringFromClass(self.class));
#endif
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
#ifdef DEBUG
    NSLog(@"viewDidDisappear:%@",NSStringFromClass(self.class));
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
    [self autoExecute];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIEdgeInsets safeArea = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        safeArea = self.view.safeAreaInsets;
    }
    [self didLayoutSubviews:safeArea];
}

/// 在viewdidload自动执行
- (void)autoExecute
{
    
}

- (void)didSetupUI:(UIView *)view
{
    
}

- (void)didBindData
{
    
}

- (void)didLayoutSubviews:(UIEdgeInsets)safeArea
{
    
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    /**
     
     如果需要根据当前模式的变化来修改界面，可以重写traitCollectionDidChange:方法进行更新
     
     然而并不是每次系统调用traitCollectionDidChange:方法时，模式都有变化，也有可能是设备进行了旋转也会调用traitCollectionDidChange:方法，所以此时需要判断系统主题模式是否发生了改变
     
     */
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle userInterfaceStyle = previousTraitCollection.userInterfaceStyle;
        self.userInterfaceStyle = userInterfaceStyle;
        [self changeUserInterfaceStyle:userInterfaceStyle];
    }
}

- (void)changeUserInterfaceStyle:(UIUserInterfaceStyle)style
{
    
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
#ifdef DEBUG
    if (motion == UIEventSubtypeMotionShake) {
        if (!self.yk_disableDEBUGShake) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            NSMutableArray<UIAlertAction *> *actions = [self debugShakeActions];
            [actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [alertController addAction:obj];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancel];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
#endif
}


- (NSMutableArray<UIAlertAction *> *)debugShakeActions
{
    NSMutableArray *array = [NSMutableArray array];
    UIAlertAction *baseInfoAction = [UIAlertAction actionWithTitle:@"查看设备/账号信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowBaseDeviceInfoNotification" object:nil];
    }];
    [array addObject:baseInfoAction];
    UIAlertAction *uiAction = [UIAlertAction actionWithTitle:@"查看UI结构" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
    }];
    [array addObject:uiAction];
    UIAlertAction *networkAction = [UIAlertAction actionWithTitle:@"查看网络记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowBaseNetworkingInfoNotification" object:nil];
    }];
    [array addObject:networkAction];
    return array;
}

- (void)setBackItemTitle:(NSString *)backItemTitle
{
    _backItemTitle = [backItemTitle copy];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = [NSString stringWithFormat:@"%@",backItemTitle];
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)setYk_hideNavigationBar:(BOOL)yk_hideNavigationBar
{
    _yk_hideNavigationBar = yk_hideNavigationBar;
    self.fd_prefersNavigationBarHidden = yk_hideNavigationBar;
}

- (void)setYk_disablePopGesture:(BOOL)yk_disablePopGesture
{
    _yk_disablePopGesture = yk_disablePopGesture;
    self.fd_interactivePopDisabled = yk_disablePopGesture;
}

- (void)setYk_disableDEBUGShake:(BOOL)yk_disableDEBUGShake
{
    _yk_disableDEBUGShake = yk_disableDEBUGShake;
}

- (UIDeviceOrientation)orientation
{
    return [[UIDevice currentDevice] orientation];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#ifdef DEBUG
        NSLog(@"deallocVC:%@",NSStringFromClass(self.class));
#endif
}


@end
