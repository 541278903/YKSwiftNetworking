//
//  YKCollectionViewCell.m
//  YKOCBaseClass
//
//  Created by edward on 2021/8/25.
//

#import "YKCollectionViewCell.h"

@implementation YKCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

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

/// UI构建
- (void)didSetupUI:(UIView *)view
{
    
}

- (void)didBindData
{
    
}

- (void)configDataWithViewModel:(YKViewModel *)viewModel indexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource
{
    
}


@end
