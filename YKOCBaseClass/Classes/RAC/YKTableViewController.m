//
//  YKTableViewController.m
//  YKOCBaseClass
//
//  Created by edward on 2021/8/25.
//

#import "YKTableViewController.h"
#import <YKOCBaseClass/YKViewModel.h>
#import <YKOCBaseClass/YKTableViewCell.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <MJRefresh/MJRefresh.h>

@interface YKTableViewController ()

@property (nonatomic, strong) UITableView *tableView;
///
@property (nonatomic,copy) NSString *identifier;
///
@property (nonatomic, strong, readwrite) RACSubject *errorSubject;

@end

@implementation YKTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)autoExecute
{
    [super autoExecute];
    [self didSetupUI:self.view];
    [self didBindData];
}

- (void)didSetupUI:(UIView *)view
{
    [super didSetupUI:view];
    view.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didBindData
{
    [super didBindData];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataSource.count > 0) {
        if ([self.dataSource.firstObject isKindOfClass:[NSArray class]]) {
            return self.dataSource.count;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count > 0) {
        if ([self.dataSource.firstObject isKindOfClass:[NSArray class]]) {
            return ((NSArray *)self.dataSource[section]).count;
        }
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    if ([cell respondsToSelector:@selector(configDataWithViewModel:indexPath:dataSource:)]) {
        [cell configDataWithViewModel:self.viewModel indexPath:indexPath dataSource:self.dataSource];
    }
    return cell;
}

- (void)registerWithNib:(UINib *)nib identifier:(NSString *)identifier
{
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
    self.identifier = identifier;
}

- (void)registerWithClass:(__unsafe_unretained Class)clazz identifier:(NSString *)identifier
{
    [self.tableView registerClass:clazz forCellReuseIdentifier:identifier];
    self.identifier = identifier;
}

#pragma mark - setter & getter

- (MJRefreshHeader *)header
{
    if (!_header) {
        @weakify(self);
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.page = 1;
            [self.refreshCommand execute:nil];
        }];
    }
    return _header;
}

- (MJRefreshBackNormalFooter *)footer
{
    if (!_footer) {
        @weakify(self);
        _footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.page += 1;
            [self.refreshCommand execute:nil];
        }];
    }
    return _footer;
}

- (YKViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[YKViewModel alloc] init];
    }
    return _viewModel;
}

- (void)setRefreshCommand:(RACCommand *)refreshCommand
{
    _refreshCommand = refreshCommand;
    @weakify(self);
    [refreshCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.header endRefreshing];
        if ([x integerValue] < self.viewModel.size) {
            [self.footer endRefreshingWithNoMoreData];
        } else {
            [self.footer endRefreshing];
        }
        [self.tableView reloadData];
    }];
    [refreshCommand.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.errorSubject sendNext:x];
    }];
    self.tableView.mj_header = self.header;
    
    CGFloat insetsBottom = 0;
    if (@available(iOS 11.0, *)) {
        insetsBottom = self.view.safeAreaInsets.bottom;
    }else{
        insetsBottom = 0;
    }
    self.footer.ignoredScrollViewContentInsetBottom = insetsBottom;
    self.tableView.mj_footer = self.footer;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (RACSubject *)errorSubject
{
    if (!_errorSubject) {
        _errorSubject = [RACSubject subject];
    }
    return _errorSubject;
}

@end
