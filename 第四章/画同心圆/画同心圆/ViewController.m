//
//  ViewController.m
//  画同心圆
//
//  Created by 曹秀锦 on 2018/4/9.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "ViewController.h"

#import "XJCConcentricCirclesView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XJCConcentricCirclesView *circlesView = [[XJCConcentricCirclesView alloc] init];
    circlesView.frame = self.view.bounds;
    [self.view addSubview:circlesView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
