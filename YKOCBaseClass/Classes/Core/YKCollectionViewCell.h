//
//  YKCollectionViewCell.h
//  YKOCBaseClass
//
//  Created by edward on 2021/8/25.
//

#import <UIKit/UIKit.h>
#import <YKOCBaseClass/YKViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKCollectionViewCell : UICollectionViewCell

/**点击响应*/
@property(nonatomic,copy) void(^handleBlock)(NSString * _Nonnull eventName, NSDictionary * _Nonnull userInfo);

/// 在init(Frame:)自动执行
- (void)autoExecute;


- (void)configDataWithViewModel:(YKViewModel *)viewModel indexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource;
@end

NS_ASSUME_NONNULL_END
