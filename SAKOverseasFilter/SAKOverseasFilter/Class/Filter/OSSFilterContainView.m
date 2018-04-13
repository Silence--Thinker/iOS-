//
//  OSSFilterContainView.m
//  SAKOverseasFilter
//
//  Created by 曹秀锦 on 2018/4/11.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "OSSFilterContainView.h"

// subView
#import "OSSFilterContainCommonCell.h"
#import "OSSFilterContainBottomView.h"

#define OSSContainViewWidth [UIScreen mainScreen].bounds.size.width
#define animationDuration(height) ((height) / [UIScreen mainScreen].bounds.size.height * 0.4)

static NSString * const kOSSFilterContainCommonCell = @"OSSFilterContainCommonCell";
static dispatch_once_t onceToken;

@interface OSSFilterContainView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) OSSFilterContainBottomView *bottomBarView;

@property (nonatomic, strong) UIView *containBgView;

@end

@implementation OSSFilterContainView
{
    UIView *_showInView;
    
    CGFloat _viewHeight;
    CGFloat _containViewHeight; // tableview height + bottom view height
    CGFloat _containViewMaxHeight;
    CGFloat _tableViewHeight;
    CGFloat _bottomViewHeight;
    
    CGFloat _offsetY; // to window
    
    CGFloat _cellHeight;
    
    UIImage *_selectedImage;
    UIImage *_nomalImage;
    
    NSArray *_cellDataList;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _containView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            view.clipsToBounds = YES;
            [self addSubview:view];
            view;
        });
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _cellHeight = 44;
        _containViewMaxHeight = CGFLOAT_MAX;
        _cellDataList = @[@{@"title" : @"不限", @"selected": @(YES)},
                          @{@"title" : @"富士山山中湖温泉", @"selected": @(NO)},
                          @{@"title" : @"忍野八海、河口湖", @"selected": @(NO)},
                          @{@"title" : @"日本环球影城", @"selected": @(NO)},
                          @{@"title" : @"梅田蓝天大厦空中楼", @"selected": @(NO)},
                          @{@"title" : @"大阪海游馆", @"selected": @(NO)}];
        
        _controlView = [[UIView alloc] initWithFrame:CGRectZero];
        [RACObserve(self, controlView.frame) subscribeNext:^(NSValue *x) {
            NSLog(@"%@", NSStringFromCGRect([x CGRectValue]));
        }];
    }
    return self;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellDataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OSSFilterContainCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:kOSSFilterContainCommonCell];
    
    NSDictionary *dict = _cellDataList[indexPath.row];
    [cell setTitle:dict[@"title"] selected:[dict[@"selected"] boolValue]];
    return cell;
}

#pragma mark - layout

- (void)updataContainViewLayout {
    
    CGFloat width = OSSContainViewWidth;
    
    // to window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect windowRect = [self.controlView.superview convertRect:self.controlView.frame toView:window];
    CGFloat offsetY = windowRect.size.height + windowRect.origin.y;
    if (offsetY == _offsetY) {
        return;
    }
    
    // view height
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height - offsetY;
    
    // tableView height
    CGFloat tableViewHeight = _cellDataList.count * _cellHeight;
    
    // bottom height
    CGFloat bottomHeight = 0;
    if (self.showBottomBar) {
        bottomHeight = [OSSFilterContainBottomView viewHeight];
    }
    
    // contain height
    CGFloat containViewHeight = (tableViewHeight + bottomHeight);
    containViewHeight = MIN(containViewHeight, _containViewMaxHeight);
    containViewHeight = MIN(viewHeight, containViewHeight);
    
    // updata tableView height
    tableViewHeight = containViewHeight - bottomHeight;
    
    // to window
    CGRect newViewRect = CGRectMake(0, offsetY, width, viewHeight);
    
    // to showView
    CGRect viewFrame = [window convertRect:newViewRect toView:_showInView];
    
    // updata frame
    self.frame = viewFrame;
    self.containBgView.frame = CGRectMake(0, 0, width, viewHeight);
    self.containView.frame = CGRectMake(0, 0, width, containViewHeight);
    self.tableView.frame = CGRectMake(0, 0, width, tableViewHeight);
    if (self.showBottomBar) {
        self.bottomBarView.frame = CGRectMake(0, 0, width, bottomHeight);
    }
    
    // updata layou var
    _viewHeight = viewHeight;
    _offsetY = offsetY;
    _tableViewHeight = tableViewHeight;
    _bottomViewHeight = bottomHeight;
    _containViewHeight = containViewHeight;
}

#pragma mark - show

- (void)showInView:(UIView *)view animation:(BOOL)animation {
    _showInView = view;
    
    [self updataContainViewLayout];
    
    [view addSubview:self];
    [self.tableView reloadData];
    
    _isShowing = YES;
    CGFloat height = _containViewHeight;
    CGFloat width = OSSContainViewWidth;
    if (!animation) {
        self.containView.frame = CGRectMake(0, 0, width, height);
        return;
    }
    
    CGRect beginFrame = CGRectMake(0, 0, width, 0);
    self.containView.frame = beginFrame;
    self.containBgView.alpha = 0;
    [UIView animateWithDuration:animationDuration(height) animations:^{
        self.containView.frame = CGRectMake(0, 0, width, height);
        self.containBgView.alpha = 1;
    } completion:nil];
}

- (void)closeWithAnimation:(BOOL)animation {
    
    _isShowing = NO;
    CGFloat width = self.frame.size.width;
    CGFloat height = _containViewHeight;
    
    if (!animation) {
        [self removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:animationDuration(height) animations:^{
        self.containView.frame = CGRectMake(0, 0, width, 0);
        self.containBgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)clickContainBgView:(UITapGestureRecognizer *)tap {
    if (self.didClickClose) {
        self.didClickClose();
    }
}

#pragma mark - set config

#pragma mark - layz load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorColor = [UIColor colorWithRed:223.0 / 255.0 green:223.0 / 255.0 blue:223.0 / 255.0 alpha:1];
            tableView.allowsMultipleSelection = YES;
            [tableView registerClass:[OSSFilterContainCommonCell class] forCellReuseIdentifier:kOSSFilterContainCommonCell];
            [self.containView addSubview:tableView];
            tableView;
        });
    }
    return _tableView;
}

- (OSSFilterContainBottomView *)bottomBarView {
    if (!_bottomBarView) {
        _bottomBarView = ({
            OSSFilterContainBottomView *bottomView = [[OSSFilterContainBottomView alloc] init];
            [self.containView addSubview:bottomView];
            bottomView;
        });
    }
    return _bottomBarView;
}

- (UIView *)containBgView {
    if (!_containBgView) {
        _containBgView = ({
            UIView *view = [[UIView alloc] init];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContainBgView:)];
            [view addGestureRecognizer:tap];
            view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            [self insertSubview:view atIndex:0];
            view;
        });
    }
    return _containBgView;
}

- (BOOL)isShowing {
    return _isShowing;
}

@end
