//
//  main.m
//  AutoReleasePool-Demo
//
//  Created by 曹秀锦 on 2018/4/8.
//  Copyright © 2018年 silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"
#import "Father.h"

/* person 和 main 是MRC编译环境
   compiler file 中增加了 -fno-objc-arc 描述
 */

Person * autorelaese_demo_01 () {
    Person *p1 = nil;
    Person *p2 = nil;
    
    /* 可以不用release因为类方法创建时用的是autorelease方式，把对象的所有权交给了对象最近的autoreleasePool，
       当autoreleasePool执行完之后，会统一的给收集的对象发送release消息。
     */
    @autoreleasepool {
        p1 = [Person person];
        p2 = p1;              // 不可以给person对象添加拥有者，创建出来之后拥有者就是autorelease
    }
    NSLog(@"autorelaese_demo_01 == %@", p2);
    return p2;
    /*
     结果在 NSLog(@"autorelaese_demo_01 == %@", p2); 处崩溃
     创建出来之后拥有者是autorelease，过了@autoreleasepool就释放了，没发将拥有权给到p2
     */
}

Person * autorelaese_demo_01_01 () {
    Person *p1 = nil;
    Person *p2 = nil;
    p1 = [Person person];
    p2 = p1;
    NSLog(@"autorelaese_demo_01 == %@", p2);
    return p2;
    /*
     结果在 NSLog(@"out main @autoreleasepool  %@", p1); 处 “偶尔” 崩溃，相当于野指针
     person所给到最近 autoreleasepool 因该是main函数的pool，也就是说main函数的pool结束了，就会给p2发送一次release，所以有了野指针
     */
}

Person * autorelaese_demo_02 () {
    Person *p1 = nil;
    Person *p2 = nil;
    
    p1 = [[Person alloc] init];
    p2 = [p1 retain];              // 这里是可以给person添加一个拥有者的
    [p1 release];                  // 必须release 不然有内存泄露，通过alloc创建的对象
    
//    NSLog(@"autorelaese_demo_02 == %@", p1);   // 已经release会有野指针
    NSLog(@"autorelaese_demo_02 == %@", p2);
    return p2;
    /*
     p2没有被释放，因为全程少了一次release
     */
}

int main(int argc, const char * argv[]) {
    
    Person *p1;
    @autoreleasepool {
//        p1 = autorelaese_demo_01();
        p1 = autorelaese_demo_01_01();
        
//        p1 = autorelaese_demo_02();
        NSLog(@"in main @autoreleasepool %@", p1);
    }
    NSLog(@"out main @autoreleasepool  %@", p1);
    
    return 0;
}
