//
//  TestCell.m
//  RuntimeDemo
//
//  Created by 姚胜龙 on 16/10/18.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)buttonAction:(id)sender {

    UIButton *button = (UIButton *)sender;
    if (self.callBlack) {
        self.callBlack(button);
    }
}

@end
