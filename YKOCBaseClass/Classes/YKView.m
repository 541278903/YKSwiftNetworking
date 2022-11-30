//
//  YYKView.m
//  YYKPodLib_Sec
//
//  Created by edward on 2020/5/26.
//  Copyright © 2020 edward. All rights reserved.
//

#import "YKView.h"
#import <YKOCBaseClass/YKViewModel.h>

@interface YKView ()

@end

@implementation YKView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self autoExecute];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIEdgeInsets safeArea = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        safeArea = self.safeAreaInsets;
    }
    [self didLayoutSubviews:safeArea];
}


/// 在viewdidload自动执行
- (void)autoExecute
{
    
}

/// UI构建
- (void)didSetupUI:(UIView *)view
{
    
}

/// 数据绑定
- (void)didBindData
{
    
}

/// UI稳定刷新
- (void)didLayoutSubviews:(UIEdgeInsets)safeArea
{
    
}

- (void)configDataWithViewModel:(YKViewModel *)viewModel {
    
}



@end
