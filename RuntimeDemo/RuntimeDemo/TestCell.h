//
//  TestCell.h
//  RuntimeDemo
//
//  Created by 姚胜龙 on 16/10/18.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlack)(UIButton *button);

@interface TestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@property (nonatomic, copy) CallBackBlack callBlack;

@end
