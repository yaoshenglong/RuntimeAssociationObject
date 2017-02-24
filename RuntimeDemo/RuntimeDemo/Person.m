//
//  Person.m
//  RuntimeDemo
//
//  Created by 姚胜龙 on 16/9/12.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person

+ (instancetype)person {
    
    Person *person = [[self alloc] init];
    return person;
}
//跑
- (void)run {
    NSLog(@"I am running");
}

void work (id SELF, SEL _cmd)  {
    NSLog(@"I am on work");
}

- (void)replaceMethods {

    NSLog(@"方法已经发生交换,请调用试试看。。。");
    class_replaceMethod([Person class], @selector(run), (IMP)work, NULL);
}

- (void)changeMethods {
    class_addMethod([Person class], @selector(replaceMethods), (IMP)goToWork, NULL);
}

void goToWork(id SELF, SEL _cmd) {
    NSLog(@"go to work");
}

@end
