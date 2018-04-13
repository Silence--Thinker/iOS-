//
//  OSSFilterBarView.m
//  SAKOverseasFilter
//
//  Created by 曹秀锦 on 2018/4/11.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "OSSFilterBarView.h"

static CGFloat const kOSSButtonPadding = 4.0;

typedef NS_ENUM (NSInteger, OSSFilterBarShowType) {
    OSSFilterSelectedBarType1,
    OSSFilterSelectedBarType2
};

@interface __OSSFilterBarViewButton : UIButton

@end
@implementation __OSSFilterBarViewButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    CGSize imageSize = self.currentImage.size;
    CGSize titleSize = self.titleLabel.bounds.size;
    
    self.titleLabel.frame = CGRectMake((self.bounds.size.width - titleSize.width - kOSSButtonPadding - imageSize.width) * 0.5, (self.bounds.size.height - titleSize.height) * 0.5, titleSize.width, titleSize.height);
    self.imageView.frame = CGRectMake((self.bounds.size.width - imageSize.width) * 0.5 + (titleSize.width + kOSSButtonPadding) * 0.5, (self.bounds.size.height - imageSize.height) * 0.5, imageSize.width, imageSize.height);
}

@end

@interface OSSFilterBarView ()

@property (nonatomic, strong) NSMutableArray<__OSSFilterBarViewButton *> *selectedButtonArray;
@property (nonatomic, strong) NSMutableArray<UIView *> *lineViewArray;
@property (nonatomic, strong) NSMutableArray<UIView *> *borderViewArray;

@end

@implementation OSSFilterBarView
{
    NSInteger _count;
    
    UIColor *_lineColor;
    UIColor *_borderColor;
    UIColor *_itemBgColor;
    
    UIColor *_itemColor;
    UIColor *_itemSelectedColor;
    
    UIFont *_itemFont;
    
    UIImage *_itemImage;
    UIImage *_itemSelectedImage;
    
    BOOL _topLine;
    BOOL _bottomLine;
    NSArray *_itemTitleArray;
    __OSSFilterBarViewButton *_currentSelected;
    
    RACSignal *_selectedSignal;
}

#pragma mark - init

+ (instancetype)filterBarView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _selectedButtonArray = [NSMutableArray array];
        _lineViewArray = [NSMutableArray array];
        _borderViewArray = [NSMutableArray array];

        _itemFont = [UIFont systemFontOfSize:13];
        
        _lineColor = [UIColor colorWithRed:229.0 / 255.0 green:229.0 / 255.0 blue:229.0 / 255.0 alpha:1];
        _borderColor = [UIColor colorWithRed:233.0 / 255.0 green:237.0 / 255.0 blue:240.0 / 255.0 alpha:1];
        _itemBgColor = [UIColor whiteColor];
        
        _itemColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1];
        _itemSelectedColor = [UIColor colorWithRed:6.0 / 255.0 green:193.0 / 255.0 blue:174.0 / 255.0 alpha:1];
        
        _itemImage = [UIImage imageNamed:@"oss_filter_bar_btn_nomal"];
        _itemSelectedImage = [UIImage imageNamed:@"oss_filter_bar_btn_selected"];
    }
    return self;
}

#pragma mark - getter config

- (OSSFilterBarView *(^)(NSArray *itemTitleArray))itemTitleArray {
    return ^(NSArray *itemTitleArray) {
        _itemTitleArray = itemTitleArray;
        return self;
    };
}

- (OSSFilterBarView *(^)(UIColor *lineColor))lineColor {
    return ^(UIColor *lineColor) {
        _lineColor = lineColor;
        return self;
    };
}
- (OSSFilterBarView *(^)(UIColor *borderColor))borderColor {
    return ^(UIColor *borderColor) {
        _borderColor = borderColor;
        return self;
    };
}
- (OSSFilterBarView *(^)(UIColor *itemBgColor))itemBgColor {
    return ^(UIColor *itemBgColor) {
        _itemBgColor = itemBgColor;
        return self;
    };
}

- (OSSFilterBarView *(^)(UIColor *itemColor))itemColor {
    return ^(UIColor *itemColor) {
        _itemColor = itemColor;
        return self;
    };
}
- (OSSFilterBarView *(^)(UIColor *itemSelectedColor))itemSelectedColor {
    return ^(UIColor *itemSelectedColor) {
        _itemSelectedColor = itemSelectedColor;
        return self;
    };
}

- (OSSFilterBarView *(^)(UIFont *itemFont))itemFont {
    return ^(UIFont *itemFont) {
        _itemFont = itemFont;
        return self;
    };
}

- (OSSFilterBarView *(^)(UIImage *itemImage))itemImage {
    return ^(UIImage *itemImage) {
        _itemImage = itemImage;
        return self;
    };
}
- (OSSFilterBarView *(^)(UIImage *itemSelectedImage))itemSelectedImage {
    return ^(UIImage *itemSelectedImage) {
        _itemSelectedImage = itemSelectedImage;
        return self;
    };
}

- (OSSFilterBarView *(^)(CGRect frame))barFrame {
    return ^(CGRect frame){
        self.frame = frame;
        return self;
    };
}

- (OSSFilterBarView *(^)(BOOL topLine))topLine {
    return ^(BOOL topLine) {
        _topLine = topLine;
        return self;
    };
}
- (OSSFilterBarView *(^)(BOOL bottomLine))bottomLine {
    return ^(BOOL bottomLine) {
        _bottomLine = bottomLine;
        return self;
    };
}

- (OSSFilterBarView *(^)(void))work {
    return ^{
        
        NSInteger count = _itemTitleArray.count;
        NSInteger currentBtnCount = self.selectedButtonArray.count;
        NSInteger currentLineCount = self.lineViewArray.count;
        NSInteger borderCount = self.borderViewArray.count;
        
        for (NSInteger i = currentBtnCount ; i < count; i++) {
            __OSSFilterBarViewButton *button = [[__OSSFilterBarViewButton alloc] init];
            button.backgroundColor = _itemBgColor;
            [button setTitleColor:_itemColor forState:UIControlStateNormal];
            [button setTitleColor:_itemSelectedColor forState:UIControlStateSelected];
            [button setImage:_itemImage forState:UIControlStateNormal];
            [button setImage:_itemSelectedImage forState:UIControlStateSelected];
            button.titleLabel.font = _itemFont;
            [button setTitle:_itemTitleArray[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [self addSubview:button];
            [self.selectedButtonArray addObject:button];
        }
        
        for (NSInteger i = currentLineCount; i < count - 1; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = _lineColor;
            [self addSubview:view];
            [self.lineViewArray addObject:view];
        }
        
        for (NSInteger i = borderCount; i < 2; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = _lineColor;
            [self addSubview:view];
            [self.borderViewArray addObject:view];
        }
        
        [self updateSubViewLayout];
        
        return self;
    };
}

#pragma mark - layout

- (void)updateSubViewLayout {
    NSInteger count = self.selectedButtonArray.count;
    if (count <= 0) {
        return;
    }
    CGFloat width = self.bounds.size.width / self.selectedButtonArray.count;
    
    [self.selectedButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(idx * width, 0, width, self.bounds.size.height);
    }];
    [self.lineViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake((idx + 1) * width, 10, 1.0 / [UIScreen mainScreen].scale, self.bounds.size.height - 20);
    }];
    
    [self.borderViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(0, idx * (self.bounds.size.height - 1), self.bounds.size.width, 1.0 / [UIScreen mainScreen].scale);
    }];
    [self.borderViewArray[0] setHidden:!_topLine];
    [self.borderViewArray[1] setHidden:!_bottomLine];
}

#pragma mark - action

- (void)didClick:(__OSSFilterBarViewButton *)sender {
    if (sender == _currentSelected) {
        sender.selected = !sender.selected;
        [self creatSignalForSelected:sender.selected index:sender.tag];
        return;
    }
    sender.selected = YES;
    _currentSelected.selected = NO;
    _currentSelected = sender;
    [self creatSignalForSelected:sender.selected index:sender.tag];
}

- (void)creatSignalForSelected:(BOOL)selected index:(NSInteger)index {
    if (self.didSelectedBlock) {
        self.didSelectedBlock(index, selected);
    }
}

- (void)selected:(BOOL)selected index:(NSInteger)index {
    __OSSFilterBarViewButton *button = self.selectedButtonArray[index];
    [self didClick:button];
}

#pragma mark - layz load
- (NSInteger)currentIndex {
    return _currentSelected.tag;
}

@end
