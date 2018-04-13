//
//  OSSFilterContainBottomView.m
//  SAKOverseasFilter
//
//  Created by 曹秀锦 on 2018/4/13.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "OSSFilterContainBottomView.h"

CGFloat const kOSSContainBottomViewHeight = 47.0;

@interface OSSFilterContainBottomView ()

@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *sureButton;

@end

@implementation OSSFilterContainBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildingSubViews];
    }
    return self;
}

- (void)buildingSubViews {
    self.backgroundColor = [UIColor colorWithRed:250.0 / 255.0 green:250.0 / 255.0 blue:250.0 / 255.0 alpha:1];
    
    _resetButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.layer.borderColor = [UIColor colorWithRed:201.0 / 255.0 green:201.0 / 255.0 blue:201.0 / 255.0 alpha:1].CGColor;
        button.layer.cornerRadius = 3.0f;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.masksToBounds = YES;
        [button setTitleColor:[UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitle:@"重置" forState:UIControlStateNormal];
        [self addSubview:button];
        button;
    });
    
    _sureButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.layer.cornerRadius = 3.0f;
        button.backgroundColor = [UIColor colorWithRed:6.0 / 255.0 green:193.0 / 255.0 blue:174.0 / 255.0 alpha:1];
        button.layer.masksToBounds = YES;
        [button setTitleColor:[UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:button];
        button;
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat bottomHeight = CGRectGetHeight(self.bounds);
    CGFloat bottomWidth = CGRectGetWidth(self.bounds);
    self.resetButton.frame = CGRectMake(12, bottomHeight - 30, 67, 30);
    self.sureButton.frame = CGRectMake(bottomWidth - 30 - 67, bottomHeight - 30, 67, 30);
}

+ (CGFloat)viewHeight {
    return kOSSContainBottomViewHeight;
}

@end
