//
//  YKBaseTableViewCell.m
//  YYKPodLib_Sec
//
//  Created by edward on 2020/11/23.
//  Copyright © 2020 edward. All rights reserved.
//

#import "YKTableViewCell.h"

@implementation YKTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.whiteColor;
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (@available(iOS 13.0, *)) {
            self.backgroundColor = UIColor.systemBackgroundColor;
        } else {
            self.backgroundColor = UIColor.whiteColor;
        }
        self.contentView.backgroundColor = UIColor.clearColor;
        
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
