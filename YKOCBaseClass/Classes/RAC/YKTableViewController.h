//
//  YKTableViewController.h
//  YKOCBaseClass
//
//  Created by edward on 2021/8/25.
//

#import "YKBaseViewController.h"

@class YKViewModel,RACCommand,MJRefreshHeader,MJRefreshBackNormalFooter,RACSubject;

NS_ASSUME_NONNULL_BEGIN

@interface YKTableViewController : YKBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *tableView;
///
@property (nonatomic, strong, readwrite) YKViewModel *viewModel;

@property (nonatomic, strong, readwrite) NSMutableArray *dataSource;

@property (nonatomic, strong, readwrite) RACCommand *refreshCommand;
///
@property (nonatomic, strong, readwrite) MJRefreshHeader *header;
///
@property (nonatomic, strong, readwrite) MJRefreshBackNormalFooter *footer;
///
@property (nonatomic, strong, readonly) RACSubject *errorSubject;
 
- (void)registerWithClass:(Class)clazz identifier:(NSString *)identifier;

- (void)registerWithNib:(UINib *)nib identifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
