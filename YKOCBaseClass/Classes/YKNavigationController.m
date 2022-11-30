//
//  YKNavigationController.m
//  YYKPodLib_Sec
//
//  Created by edward on 2020/10/10.
//  Copyright © 2020 edward. All rights reserved.
//

#import "YKNavigationController.h"

@interface YKNavigationController ()<UINavigationControllerDelegate>


@property (nonatomic,strong) id popDelegate;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;
/** 返回按钮 */
@property (nonatomic, strong) UIBarButtonItem *backBtnItem;
/** 最后push的controller的类名 */
@property (nonatomic, copy) NSString *latestPushViewControllerName;
@end

@implementation YKNavigationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!viewController) return;
    if (self.childViewControllers.count > 0) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backImage = [UIImage new];
        if (@available(iOS 13.0, *)) {
            if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                backImage = [self bc_imageNamed:@"ic_bc_back_while"];
            }else
            {
                backImage = [self bc_imageNamed:@"ic_bc_back_black"];
            }
        } else {
            backImage = [self bc_imageNamed:@"ic_bc_back_black"];
        }
        backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [backBtn setImage:backImage forState:UIControlStateNormal];
        [backBtn setImage:backImage forState:UIControlStateHighlighted];
        if (self.backButtonColor) {
            [backBtn setTintColor:self.backButtonColor];
        } else {
            [backBtn setTintColor:UIColor.blackColor];
        }
        backBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        CGFloat ipad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2 : 1;
        CGRect frame = backBtn.frame;
        frame.size = CGSizeMake(44 * ipad, 44 * ipad);
        backBtn.frame = frame;
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        self.backBtn = backBtn;
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        self.backBtnItem = viewController.navigationItem.leftBarButtonItem;
        
        if (self.viewControllers.count == 1) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
    }else{
        viewController.hidesBottomBarWhenPushed = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

#pragma mark - setter & getter
- (void)setBackBtnTitle:(NSString *)backBtnTitle {
    _backBtnTitle = backBtnTitle;
    if (backBtnTitle) {
        [self.backBtn setTitle:backBtnTitle forState:UIControlStateNormal];
        [self.backBtn setTitleColor:[UIColor colorWithRed:236.0/255.0 green:89.0/255.0 blue:90.0/255.0 alpha:1] forState:UIControlStateNormal];
        CGFloat ipad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2 : 1;
        CGRect frame = self.backBtn.frame;
        frame.size = CGSizeMake(130 * ipad, 44 * ipad);
        self.backBtn.frame = frame;
        self.backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        self.backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    } else {
        [self.backBtn setTitle:backBtnTitle forState:UIControlStateNormal];
        CGFloat ipad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2 : 1;
        CGRect frame = self.backBtn.frame;
        frame.size = CGSizeMake(44 * ipad, 44 * ipad);
        self.backBtn.frame = frame;
        self.backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    
    /**  iOS13开始改用standard
     self.navigationBar.barTintColor = backgroundColor;
     self.navigationBar.backgroundColor = backgroundColor;
     */
    if (backgroundColor) {
        if (@available(iOS 15, *)) {
            
            
            UINavigationBarAppearance *standardAppearance = self.navigationBar.standardAppearance;
            
            if (!standardAppearance) {
                standardAppearance = [[UINavigationBarAppearance alloc] init];
            }
            standardAppearance.backgroundColor = backgroundColor;
            self.navigationBar.standardAppearance = standardAppearance;
            
            UINavigationBarAppearance *scrollEdgeAppearance = self.navigationBar.scrollEdgeAppearance;
            
            if (!scrollEdgeAppearance) {
                scrollEdgeAppearance = [[UINavigationBarAppearance alloc] init];
            }
            
            scrollEdgeAppearance.backgroundColor = backgroundColor;
            self.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance;
            
        } else {
            self.navigationBar.barTintColor = backgroundColor;
            self.navigationBar.backgroundColor = backgroundColor;
        }
    }
}

- (void)setTabbarBackgroundColor:(UIColor *)tabbarBackgroundColor
{
    _tabbarBackgroundColor = tabbarBackgroundColor;
    if (tabbarBackgroundColor) {
        if (@available(iOS 15, *)) {
            
            UITabBarAppearance *scrollAppearance = self.tabBarItem.scrollEdgeAppearance;
            
            if (!scrollAppearance) {
                scrollAppearance = [[UITabBarAppearance alloc] init];
            }
            scrollAppearance.backgroundColor = tabbarBackgroundColor;
            self.tabBarItem.scrollEdgeAppearance = scrollAppearance;
            
            UITabBarAppearance *standardAppearance = self.tabBarItem.standardAppearance;
            
            if (!standardAppearance) {
                standardAppearance = [[UITabBarAppearance alloc] init];
            }
            standardAppearance.backgroundColor = tabbarBackgroundColor;
            self.tabBarItem.standardAppearance = standardAppearance;
        } else {
            [[UITabBar appearance] setBarTintColor:tabbarBackgroundColor];
        }
    }
}

- (void)setTabbarNormalItemTextColor:(UIColor *)tabbarNormalItemTextColor
{
    _tabbarNormalItemTextColor = tabbarNormalItemTextColor;
    
    if (tabbarNormalItemTextColor) {
        if (@available(iOS 15, *)) {
            
            UITabBarAppearance *scrollAppearance = self.tabBarItem.scrollEdgeAppearance;
            
            if (!scrollAppearance) {
                scrollAppearance = [[UITabBarAppearance alloc] init];
            }
            
            NSMutableDictionary<NSAttributedStringKey, id> *scrollNormalAttributes = scrollAppearance.stackedLayoutAppearance.normal.titleTextAttributes.mutableCopy;
            [scrollNormalAttributes setValue:tabbarNormalItemTextColor forKey:NSForegroundColorAttributeName];
            scrollAppearance.stackedLayoutAppearance.normal.titleTextAttributes = scrollNormalAttributes.copy;
            self.tabBarItem.scrollEdgeAppearance = scrollAppearance;

            
            UITabBarAppearance *standardAppearance = self.tabBarItem.standardAppearance;
            
            if (!standardAppearance) {
                standardAppearance = [[UITabBarAppearance alloc] init];
            }
            
            NSMutableDictionary<NSAttributedStringKey, id> *standardNormalAttributes = standardAppearance.stackedLayoutAppearance.normal.titleTextAttributes.mutableCopy;
            [standardNormalAttributes setValue:tabbarNormalItemTextColor forKey:NSForegroundColorAttributeName];
            standardAppearance.stackedLayoutAppearance.normal.titleTextAttributes = standardNormalAttributes.copy;
            self.tabBarItem.standardAppearance = standardAppearance;
        } else {
            
            NSMutableDictionary<NSAttributedStringKey, id> *normalAttributes = [self.tabBarItem titleTextAttributesForState:UIControlStateNormal].mutableCopy;
            
            if (!normalAttributes) {
                normalAttributes = [NSMutableDictionary dictionary];
            }
            
            [normalAttributes setValue:tabbarNormalItemTextColor forKey:NSForegroundColorAttributeName];
            [self.tabBarItem setTitleTextAttributes:normalAttributes.copy forState:UIControlStateNormal];
            
        }
    }
}

- (void)setTabbarSelectItemTextColor:(UIColor *)tabbarSelectItemTextColor
{
    _tabbarSelectItemTextColor = tabbarSelectItemTextColor;
    if (tabbarSelectItemTextColor) {
        if (@available(iOS 15, *)) {
            UITabBarAppearance *scrollAppearance = self.tabBarItem.scrollEdgeAppearance;
            if (!scrollAppearance) {
                scrollAppearance = [[UITabBarAppearance alloc] init];
            }
            NSMutableDictionary<NSAttributedStringKey, id> *scrollSelectedAttributes = scrollAppearance.stackedLayoutAppearance.selected.titleTextAttributes.mutableCopy;
            [scrollSelectedAttributes setValue:tabbarSelectItemTextColor forKey:NSForegroundColorAttributeName];
            scrollAppearance.stackedLayoutAppearance.selected.titleTextAttributes = scrollSelectedAttributes.copy;
            self.tabBarItem.scrollEdgeAppearance = scrollAppearance;
            UITabBarAppearance *standardAppearance = self.tabBarItem.standardAppearance;
            if (!standardAppearance) {
                standardAppearance = [[UITabBarAppearance alloc] init];
            }
            NSMutableDictionary<NSAttributedStringKey, id> *standardSelectedAttributes = standardAppearance.stackedLayoutAppearance.selected.titleTextAttributes.mutableCopy;
            [standardSelectedAttributes setValue:tabbarSelectItemTextColor forKey:NSForegroundColorAttributeName];
            standardAppearance.stackedLayoutAppearance.selected.titleTextAttributes = standardSelectedAttributes.copy;
            self.tabBarItem.standardAppearance = standardAppearance;
        } else {
            NSMutableDictionary<NSAttributedStringKey, id> *selectedAttributes = [self.tabBarItem titleTextAttributesForState:UIControlStateSelected].mutableCopy;
            if (!selectedAttributes) {
                selectedAttributes = [NSMutableDictionary dictionary];
            }
            [selectedAttributes setValue:tabbarSelectItemTextColor forKey:NSForegroundColorAttributeName];
            [self.tabBarItem setTitleTextAttributes:selectedAttributes.copy forState:UIControlStateSelected];
        }
    }
}

- (void)setTabbarSelectedImage:(UIImage *)tabbarSelectedImage
{
    _tabbarSelectedImage = tabbarSelectedImage;
    self.tabBarItem.selectedImage = tabbarSelectedImage;
}

- (void)setTabbarNormalImage:(UIImage *)tabbarNormalImage
{
    _tabbarNormalImage = tabbarNormalImage;
    self.tabBarItem.image = tabbarNormalImage;
}

- (void)setTabbarTitle:(NSString *)tabbarTitle
{
    _tabbarTitle = tabbarTitle;
    self.tabBarItem.title = tabbarTitle;
}


- (void)setForegroundColor:(UIColor *)foregroundColor
{
    _foregroundColor = foregroundColor;
    NSMutableDictionary *barTitleDic = [NSMutableDictionary dictionary];
    barTitleDic[NSForegroundColorAttributeName] = foregroundColor;
    [[UINavigationBar appearance] setTitleTextAttributes:barTitleDic];
}

- (void)setShadowImage:(UIImage *)shadowImage
{
    _shadowImage = shadowImage;
    self.navigationBar.shadowImage = shadowImage;
}

- (nullable UIImage *)bc_imageNamed:(NSString *)name{
    if(name &&
       ![name isEqualToString:@""]){
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"YKBaseViewController")];
        NSURL *url = [bundle URLForResource:@"YKOCBaseClass" withExtension:@"bundle"];
        if(!url) return [UIImage imageNamed:name]?:[UIImage new];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        
        NSString *imageName = nil;
        CGFloat scale = [UIScreen mainScreen].scale;
        if (ABS(scale-3) <= 0.001){
            imageName = [NSString stringWithFormat:@"%@@3x",name];
        }else if(ABS(scale-2) <= 0.001){
            imageName = [NSString stringWithFormat:@"%@@2x",name];
        }else{
            imageName = name;
        }
        UIImage *image = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:imageName ofType:@"png"]];
        if (!image) {
            image = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:name ofType:@"png"]];
            if (!image) {
                image = [UIImage imageNamed:name];
            }
        }
        return image;
    }
    
    return nil;
}

@end



