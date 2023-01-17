//
//  YKCollectionViewHeaderFooterView.m
//  YKOCBaseClass
//
//  Created by linghit on 2021/8/27.
//

#import "YKCollectionViewHeaderFooterView.h"

@implementation YKCollectionViewHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self autoExecute];
    }
    return self;
}
/// 在viewdidload自动执行
- (void)autoExecute
{
    
}

- (void)configDataWithViewModel:(YKViewModel *)viewModel indexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource
{
    
}


@end
