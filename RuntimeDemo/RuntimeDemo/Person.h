//
//  Person.h
//  RuntimeDemo
//
//  Created by 姚胜龙 on 16/9/12.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Sex){
    Sex_Male,
    Sex_Famale
};

@interface Person : NSObject

@property (nonatomic, copy) NSString *personName;
@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) Sex sex;

+ (instancetype)person;

- (void)run;

- (void)replaceMethods;

- (void)changeMethods;

@end
