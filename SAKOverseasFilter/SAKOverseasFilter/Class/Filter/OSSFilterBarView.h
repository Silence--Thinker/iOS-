//
//  OSSFilterBarView.h
//  SAKOverseasFilter
//
//  Created by 曹秀锦 on 2018/4/11.
//  Copyright © 2018年 silence. All rights reserved.
//

@import UIKit;

@class OSSFilterBarView;
__attribute__((objc_subclassing_restricted))
@interface OSSFilterBarView : UIView

+ (instancetype)filterBarView;

- (OSSFilterBarView *(^)(NSArray *itemTitleArray))itemTitleArray;

- (OSSFilterBarView *(^)(UIColor *lineColor))lineColor;
- (OSSFilterBarView *(^)(UIColor *borderColor))borderColor; // top bottom line color
- (OSSFilterBarView *(^)(UIColor *itemBgColor))itemBgColor;

- (OSSFilterBarView *(^)(UIColor *itemColor))itemColor;
- (OSSFilterBarView *(^)(UIColor *itemSelectedColor))itemSelectedColor;

- (OSSFilterBarView *(^)(UIFont *itemColor))itemFont;

- (OSSFilterBarView *(^)(UIImage *itemImage))itemImage;
- (OSSFilterBarView *(^)(UIImage *itemSelectedImage))itemSelectedImage;

- (OSSFilterBarView *(^)(CGRect frame))barFrame;

- (OSSFilterBarView *(^)(BOOL topLine))topLine;
- (OSSFilterBarView *(^)(BOOL bottomLine))bottomLine;

- (OSSFilterBarView *(^)(void))work;

@property (nonatomic, copy) void (^didSelectedBlock)(NSInteger index, BOOL selected);
@property (nonatomic, assign, readonly) NSInteger currentIndex;

- (void)selected:(BOOL)selected index:(NSInteger)index;

@end
