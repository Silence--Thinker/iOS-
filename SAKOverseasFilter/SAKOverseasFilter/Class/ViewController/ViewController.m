//
//  ViewController.m
//  SAKOverseasFilter
//
//  Created by 曹秀锦 on 2018/4/11.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "ViewController.h"

#import "OSSFilterBarView.h"
#import "OSSFilterContainView.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) OSSFilterBarView *filterBar;
@property (nonatomic, strong) OSSFilterContainView *containView;

@end

@implementation ViewController

- (void)loadView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.tableFooterView = [UIView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tableView addGestureRecognizer:tap];
    self.view = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titleArray = @[@"热门景点", @"可用时间", @"智能排序", @"筛选"];
    CGRect frame = CGRectMake(0, 100, SCREEN_WIDTH, 48);
    
    self.filterBar
    .itemTitleArray(titleArray)
    .barFrame(frame)
    .topLine(YES)
    .bottomLine(YES)
    .work();
    [self.view addSubview:self.filterBar];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 20)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    self.containView.controlView = self.filterBar;
    @weakify(self);
    self.filterBar.didSelectedBlock = ^(NSInteger index, BOOL selected) {
        @strongify(self);
        if (selected) {
            [self.containView showInView:self.view animation:YES];
        } else {
            [self.containView closeWithAnimation:YES];
        }
    };
    self.containView.didClickClose = ^{
        @strongify(self);
        [self.filterBar selected:NO index:self.filterBar.currentIndex];
    };
    
    
}

#pragma mark - UITableViewDataSource, UITabBarDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

#pragma mark - layz load

- (OSSFilterBarView *)filterBar {
    if (!_filterBar) {
        _filterBar = [OSSFilterBarView filterBarView];
        _filterBar.backgroundColor = [UIColor whiteColor];
    }
    return _filterBar;
}

- (OSSFilterContainView *)containView {
    if (!_containView) {
        _containView = [[OSSFilterContainView alloc] init];
    }
    return _containView;
}


- (void)tapGesture:(UITapGestureRecognizer *)tap {
    
    [[self signal:nil] subscribeNext:^(id x) {
      NSLog(@"%@", x);
    }];
}

- (RACSignal *)signal:(NSObject *)object
{
    RACSignal *s = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    
        void (^block)(NSArray *array, NSError *error) = ^(NSArray *array, NSError *error) {
            
        };
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            block(nil, nil);
            [subscriber sendNext:@"12313123"];
            
            [subscriber sendCompleted];
        });
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    return s;
}

@end
