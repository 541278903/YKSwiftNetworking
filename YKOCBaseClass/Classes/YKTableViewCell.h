//
//  YKBaseTableViewCell.h
//  YYKPodLib_Sec
//
//  Created by edward on 2020/11/23.
//  Copyright © 2020 edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YKOCBaseClass/YKViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKTableViewCell : UITableViewCell

/**点击响应*/
@property(nonatomic,copy) void(^handleBlock)(NSString * _Nonnull eventName, NSDictionary * _Nonnull userInfo);

/// 在init(Style:)自动执行
- (void)autoExecute;

/// UI构建
- (void)didSetupUI:(UIView *)view;

- (void)didBindData;

- (void)configDataWithViewModel:(YKViewModel *)viewModel indexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource;


@end

NS_ASSUME_NONNULL_END
