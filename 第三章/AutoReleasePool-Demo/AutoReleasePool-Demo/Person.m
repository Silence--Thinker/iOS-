//
//  Person.m
//  AutoReleasePool-Demo
//
//  Created by 曹秀锦 on 2018/4/8.
//  Copyright © 2018年 silence. All rights reserved.
//  MRC的情况

#import "Person.h"

@implementation Person

- (void)dealloc {
    [super dealloc];
    NSLog(@"%s", __func__);
}

+ (instancetype)person {
    Person *person = [[[self alloc] init] autorelease];
    return person;
}
@end
