//
//  OSSFilterContainCommonCell.m
//  SAKOverseasFilter
//
//  Created by 曹秀锦 on 2018/4/11.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "OSSFilterContainCommonCell.h"

@interface OSSFilterContainCommonCell ()

@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation OSSFilterContainCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self buildingSubViews];
    }
    return self;
}

- (void)buildingSubViews {
    _pictureView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"oss_filter_contain_cell_nomal"];
        [self.contentView addSubview:imageView];
        imageView;
    });
    
    _titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        label;
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat centerY = self.contentView.bounds.size.height * 0.5;
    [self.pictureView sizeToFit];
    self.pictureView.center = CGPointMake(10 + self.pictureView.bounds.size.width * 0.5, centerY);
    
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.pictureView.bounds.size.width + 10 + 10 + self.titleLabel.bounds.size.width * 0.5, centerY);
}

- (void)setTitle:(NSString *)title selected:(BOOL)selected {
    self.titleLabel.text = title;
    NSString *imageName = nil;
    if (selected) {
        imageName = @"oss_filter_contain_cell_selected";
    } else {
        imageName = @"oss_filter_contain_cell_nomal";
    }
    self.pictureView.image = [UIImage imageNamed:imageName];
}

@end
