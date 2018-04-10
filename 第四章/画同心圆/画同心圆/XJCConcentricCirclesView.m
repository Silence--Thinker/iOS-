//
//  XJCConcentricCirclesView.m
//  画同心圆
//
//  Created by 曹秀锦 on 2018/4/9.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "XJCConcentricCirclesView.h"

@implementation XJCConcentricCirclesView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)draw_a_circle:(CGRect)rect {
    CGFloat centerX = (rect.origin.x + rect.size.width) * 0.5;
    CGFloat centerY = (rect.origin.y + rect.size.height) * 0.5;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    [[UIColor lightGrayColor] set];
    path.lineWidth = 10.0f;
    
    [path stroke];
}

void draw_a_circle (CGRect rect) {
    
    CGFloat centerX = (rect.origin.x + rect.size.width) * 0.5;
    CGFloat centerY = (rect.origin.y + rect.size.height) * 0.5;
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.667, 0.667, 0.667, 1);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, centerX, centerY, radius, 0, M_PI * 2, YES);
    CGContextSetLineWidth(context, 10);
    
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
}

- (void)draw_concentric_circle:(CGRect)rect {
    CGFloat centerX = (rect.origin.x + rect.size.width) * 0.5;
    CGFloat centerY = (rect.origin.y + rect.size.height) * 0.5;

    CGPoint center = CGPointMake(centerX, centerY);
    
    CGFloat radius = hypot(rect.size.width, rect.size.height) * 0.5;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (CGFloat currentRadius = radius; currentRadius > 0; currentRadius -= 20) {
        [path moveToPoint:CGPointMake(centerX + currentRadius, centerY)];
        [path addArcWithCenter:center radius:currentRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    }
    
    [[UIColor lightGrayColor] set];
    path.lineWidth = 10.0f;
    
    [path stroke];
    
    UIImage *image = [UIImage imageNamed:@"logo"];
    CGRect imageRect = CGRectMake(50, 150, rect.size.width - 100, rect.size.height - 300);
    [image drawInRect:imageRect];
}

void draw_concentric_circle (CGRect rect) {
    CGFloat centerX = (rect.origin.x + rect.size.width) * 0.5;
    CGFloat centerY = (rect.origin.y + rect.size.height) * 0.5;
    CGFloat radius = hypot(rect.size.width, rect.size.height) * 0.5;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.667, 0.667, 0.667, 1);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
    for (CGFloat currentRadius = radius; currentRadius > 0; currentRadius -= 20) {
        CGPathMoveToPoint(path, NULL, centerX + currentRadius, centerY);
        CGPathAddArc(path, &transform, centerX, centerY, currentRadius, 0, M_PI * 2, NO); // 注意:最后一个参数如果是YES相当于 0π
//        CGContextSetLineWidth(context, 5);  这个跟下一行，下一行生效。。后设置有效
    }
    CGContextSetLineWidth(context, 10);
    
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
    UIImage *image = [UIImage imageNamed:@"logo"];
    CGRect imageRect = CGRectMake(50, 150, rect.size.width - 100, rect.size.height - 300);
    [image drawInRect:imageRect];
}

void draw_shadow (CGRect rect) {
//    draw_concentric_circle(rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    // CGContextSetShadow(CGContextRef cg_nullable c, CGSize offset, CGFloat blur)
    // offset 阴影偏移量  blur 模糊度
    CGContextSetShadow(context, CGSizeMake(0, 10), 5);
    
    // 这里绘制的图像会有阴影效果
    UIImage *image = [UIImage imageNamed:@"logo"];
    CGRect imageRect = CGRectMake(50, 150, rect.size.width - 100, rect.size.height - 300);
    [image drawInRect:imageRect];
    
    CGContextRestoreGState(context);
    // 这里绘制的图像没有阴影效果
}

void draw_color_space (CGRect rect) {
    CGFloat locations[4] = {0.0, 1.0};
    CGFloat components[8] = {1.0, 0.0, 0.0, 1.0, // 起始颜色 红色
                             1.0, 1.0, 0.0, 1.0};// 终止颜色 黄色
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGPoint startPoint = CGPointMake(50, 50);
    CGPoint endPoint = CGPointMake(rect.size.width - 50, rect.size.height - 50);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // kCGGradientDrawsBeforeStartLocation = (1 << 0), kCGGradientDrawsAfterEndLocation
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)drawRect:(CGRect)rect {
    // 画一个圆
//    [self draw_a_circle:rect];
//    draw_a_circle(rect);
    
    // 画同心圆
//    [self draw_concentric_circle:rect];
//    draw_concentric_circle(rect);
    
    // 画阴影 UIBezierPath不支持
//    draw_shadow(rect);
    
    // 画渐变色 只可以是线性渐变
    draw_color_space(rect);
}

@end
