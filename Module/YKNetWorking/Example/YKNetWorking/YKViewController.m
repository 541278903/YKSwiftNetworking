//
//  YKViewController.m
//  YKNetWorking
//
//  Created by edwardyyk on 09/30/2022.
//  Copyright (c) 2022 edwardyyk. All rights reserved.
//

#import "YKViewController.h"
#import <YKNetWorking/YKNetWorking.h>


@interface YKNetworkingTestModel : NSObject
///
@property (nonatomic, copy, readwrite) NSString *name;
///
@property (nonatomic, copy, readwrite) void(^todo)(void);
@end

@implementation YKNetworkingTestModel

- (instancetype)initWithName:(NSString *)name todoCallBack:(void(^)(void))todoCallback
{
    self = [super init];
    if (self) {
        self.name = name;
        self.todo = todoCallback;
    }
    return self;
}

+ (YKNetworkingTestModel *)createModel:(NSString *)name todoCallBack:(void(^)(void))todoCallback
{
    return [[YKNetworkingTestModel alloc] initWithName:name todoCallBack:todoCallback];
}

@end

@interface YKViewController ()<UITableViewDelegate,UITableViewDataSource>
///
@property (nonatomic, strong, readwrite) UITableView *tableView;
///
@property (nonatomic, strong, readwrite) NSMutableArray<YKNetworkingTestModel *> *dataSource;
@end

@implementation YKViewController

- (void)demo_execute_get
{
    YKNetWorking *networking = [[YKNetWorking alloc] init];
    
    networking.handleRequest = ^YKNetworkRequest * _Nonnull(YKNetworkRequest * _Nonnull request) {
        
        
        //对请求的头部进行修改，可自行修改自己调整的内容
        request.urlStr = @"https://www.baidu.com";
        
        /**
         @warning  慎重对请求头的修改，可能会影响请求
         @return   返回nil将中止本次请求
         */
        
        
        return request;
    };
    
    networking.handleResponse = ^NSError * _Nonnull(YKNetworkResponse * _Nonnull response, YKNetworkRequest * _Nonnull request) {
        //对回调的数据预处理
        
        
        //将想要的数据重新组合放入到rawData里
        response.rawData = @{@"hello":@"123"};
        
        
        //如果数据中某部分内容不符合预期可以直接返回error 内部将以接口报错的形式将此处的错误返回到外部
        if (NO) {
            return [NSError errorWithDomain:@"yk.networking" code:-1 userInfo:@{
                NSLocalizedFailureReasonErrorKey:@"内容不符合预期，报错"
            }];
        }
       
        return nil;
    };
    
    if (YES) {
        networking = networking.get(@"https://cctalk.hjapi.com/basic/v1.1/appconfig/list");
    }else {
        // 此处上下为等价公式↑ ↓
        networking = networking.method(YKNetworkRequestMethodGET).url(@"https://cctalk.hjapi.com/basic/v1.1/appconfig/list");
    }
    
    //设置本次请求的参数
    networking = networking.params(@{});
    
    //设置本次请求的头部信息
    networking = networking.headers(@{});
    
    //设置本次请求的返回格式（默认JSON）
    networking = networking.responseType(YKNetworkResponseTypeJSON);
    
    //开始请求
    [networking executeRequest:^(YKNetworkResponse * _Nonnull response, YKNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        //此处的结果会先处理刚刚的预处理行为后的内容
        NSLog(@"%@",response.rawData);
    }];
}

- (void)demo_execute_post
{
    YKNetWorking *networking = [[YKNetWorking alloc] init];
    
    networking.handleRequest = ^YKNetworkRequest * _Nonnull(YKNetworkRequest * _Nonnull request) {
        
        
        //对请求的头部进行修改，可自行修改自己调整的内容
        request.urlStr = @"https://www.baidu.com";
        
        /**
         @warning  慎重对请求头的修改，可能会影响请求
         @return   返回nil将中止本次请求
         */
        
        
        return request;
    };
    
    networking.handleResponse = ^NSError * _Nonnull(YKNetworkResponse * _Nonnull response, YKNetworkRequest * _Nonnull request) {
        //对回调的数据预处理
        
        
        //将想要的数据重新组合放入到rawData里
//        response.rawData = @{@"hello":@"123"};
        
        
        //如果数据中某部分内容不符合预期可以直接返回error 内部将以接口报错的形式将此处的错误返回到外部
        if (NO) {
            return [NSError errorWithDomain:@"yk.networking" code:-1 userInfo:@{
                NSLocalizedFailureReasonErrorKey:@"内容不符合预期，报错"
            }];
        }
       
        return nil;
    };
    
    if (YES) {
        networking = networking.post(@"http://japi.juhe.cn/charconvert/change.from");
    }else {
        // 此处上下为等价公式↑ ↓
        networking = networking.method(YKNetworkRequestMethodPOST).url(@"http://japi.juhe.cn/charconvert/change.from");
    }
    
    //设置本次请求的参数
    networking = networking.params(@{@"text":@"我是谁",@"type":@"2",@"key":@"0e27c575047e83b407ff9e517cde9c76"});
    
    //设置本次请求的头部信息
    networking = networking.headers(@{});
    
    //设置本次请求的返回格式（默认JSON）
    networking = networking.responseType(YKNetworkResponseTypeHTTP);
    
    //开始请求
    [networking executeRequest:^(YKNetworkResponse * _Nonnull response, YKNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        //此处的结果会先处理刚刚的预处理行为后的内容
        NSString *datajsonstr = [[NSString alloc] initWithData:((NSData *)response.rawData) encoding:NSUTF8StringEncoding];
        NSLog(@"%@",datajsonstr);
    }];
}

- (void)demo_execute_upload
{
    YKNetWorking *networking = [[YKNetWorking alloc] init];
    
    networking = networking.post(@"");
    
    NSData *imagedata = UIImageJPEGRepresentation([UIImage imageNamed:@"test.jpg"], 0.1);
    //基础已省略

    //产生上传报文
    //参数一 data 上传时使用的data数据
    //参数二 fileName  上传时给与后端的文件名
    //参数三 mimeType 上传的mimetype
    //参数四 fileFieldName 上传后后端使用的字段名
    /**
     @warning  调用并设置上传属性本次请求将调整为上传模式
     */
    networking = networking.uploadData(imagedata,@"test.jpg",@"image/jpeg",@"file");
    
    
    networking = networking.progress(^(float pro){
        NSLog(@"%@",@(pro).stringValue);
    });
    
    [networking executeRequest:^(YKNetworkResponse * _Nonnull response, YKNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        NSLog(@"%@",response.rawData);
    }];
}

- (void)demo_execute_download
{
    YKNetWorking *networking = [[YKNetWorking alloc] init];
    
    networking = networking.get(@"http://106.55.12.108:30081/images/1667358562287.jpg");
    
    //基础已省略

    //产生上传报文
    //参数一 destPath 设置本次下载文件保存的沙盒路劲 把url可下载内容下载到沙盒路劲中
    /**
     @warning  调用并设置下载路径属性本次请求将调整为下载模式
     */
    networking = networking.downloadDestPath(@"/test");
    
    networking = networking.progress(^(float pro){
        NSLog(@"%@",@(pro).stringValue);
    })
    
    [networking executeRequest:^(YKNetworkResponse * _Nonnull response, YKNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        NSLog(@"%@",response.rawData);
    }];
}

- (void)demo_rx_execute_get
{
#if __has_include("YKNetWorking/YKNetWorking+RAC.h")
    YKNetWorking *networking = [[YKNetWorking alloc] init];
    
    networking.handleRequest = ^YKNetworkRequest * _Nonnull(YKNetworkRequest * _Nonnull request) {
        //对请求的头部进行修改，可自行修改自己调整的内容
        request.urlStr = @"https://www.baidu.com";
        
        //返回nil将中止本次请求
        if (NO) {
            return nil;
        }
        
        return request;
    };
    
    networking.handleResponse = ^NSError * _Nonnull(YKNetworkResponse * _Nonnull response, YKNetworkRequest * _Nonnull request) {
        //对回调的数据预处理
        
        
        //将想要的数据重新组合放入到rawData里
        response.rawData = @{@"hello":@"123"};
        
        
        //如果数据中某部分内容不符合预期可以直接返回error 内部将以接口报错的形式将此处的错误返回到外部
        if (YES) {
            return [NSError errorWithDomain:@"yk.networking" code:-1 userInfo:@{
                NSLocalizedFailureReasonErrorKey:@"内容不符合预期，报错"
            }];
        }
       
        return nil;
    };
    
    if (YES) {
        networking = networking.get(@"https://cctalk.hjapi.com/basic/v1.1/appconfig/list");
    }else {
        // 此处上下为等价公式↑ ↓
        networking = networking.method(YKNetworkRequestMethodGET).url(@"https://cctalk.hjapi.com/basic/v1.1/appconfig/list");
    }
    
    //设置本次请求的参数
    networking = networking.params(@{});
    
    //设置本次请求的头部信息
    networking = networking.headers(@{});
    
    //设置本次请求的返回格式（默认JSON）
    networking = networking.responseType(YKNetworkResponseTypeHTTP);
    
    //产生请求报文
    RACSignal *signal = networking.executeSignal;
    
    //可以吧报文只获取 response中rawdata的内容
    //是使用rac中map方法把有用内容提取出来
    signal = signal.mapWithRawData;
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@",error.localizedDescription);
    } completed:^{
        
    }];
#else
    NSLog(@"请pod 加入 pod 'YKNetWorking/RAC' 以使用RAC拓展");
#endif
}

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    [self.dataSource addObject:[YKNetworkingTestModel createModel:@"请求GET" todoCallBack:^{
        [weakSelf demo_execute_get];
    }]];
    
    [self.dataSource addObject:[YKNetworkingTestModel createModel:@"请求POST" todoCallBack:^{
        [weakSelf demo_execute_post];
    }]];
    
    [self.dataSource addObject:[YKNetworkingTestModel createModel:@"请求上传" todoCallBack:^{
        [weakSelf demo_execute_upload];
    }]];
    
    [self.dataSource addObject:[YKNetworkingTestModel createModel:@"请求下载" todoCallBack:^{
        [weakSelf demo_execute_download];
    }]];
    
    [self.dataSource addObject:[YKNetworkingTestModel createModel:@"RAC请求GET" todoCallBack:^{
        [weakSelf demo_rx_execute_get];
    }]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self reloadDataSource];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    YKNetworkingTestModel *model = self.dataSource[indexPath.row];
    tableViewCell.textLabel.text = model.name;
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YKNetworkingTestModel *model = self.dataSource[indexPath.row];
    model.todo();
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
        self.tableView.frame = CGRectMake(0, safeAreaInsets.top, self.view.bounds.size.width, self.view.bounds.size.height - safeAreaInsets.top - safeAreaInsets.bottom);
    } else {
        // Fallback on earlier versions
        CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.frame = CGRectMake(0, height, self.view.bounds.size.width, self.view.bounds.size.height - height);
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

- (NSMutableArray<YKNetworkingTestModel *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
