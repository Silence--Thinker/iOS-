//
//  OSSFilterContainView.h
//  SAKOverseasFilter
//
//  Created by 曹秀锦 on 2018/4/11.
//  Copyright © 2018年 silence. All rights reserved.
//

@import UIKit;

@interface OSSFilterContainView : UIView
{
//    BOOL _showBottomBar;
    BOOL _defaultSelectedIsAll;
    BOOL _isShowing;
}

@property (nonatomic, assign, readonly) BOOL isShowing;
@property (nonatomic, assign) BOOL showBottomBar;

@property (nonatomic, strong) UIView *controlView;
@property (nonatomic, strong) NSArray *dataList;

- (void)showInView:(UIView *)view animation:(BOOL)animation;
- (void)closeWithAnimation:(BOOL)animation;

@property (nonatomic, copy) void (^didClickClose)(void);

@end
