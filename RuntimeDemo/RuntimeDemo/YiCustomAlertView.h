//
//  YiCustomAlertView.h
//  RuntimeDemo
//
//  Created by 姚胜龙 on 16/10/18.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelBlock)(UIButton *button);
typedef void(^SureBlock)(UIButton *button);

@interface YiCustomAlertView : UIView

// 背景颜色
@property (nonatomic, strong) UIColor *backGroundColor;

//弹出框的颜色
@property (nonatomic, strong) UIColor *alertColor;

//确定按钮字体颜色
@property (nonatomic, strong) UIColor *sureBtnColor;

//取消按钮字体颜色
@property (nonatomic, strong) UIColor *cancelBtnColor;

//是否显示按钮分割线
@property (nonatomic, assign) BOOL isShowLine;

//背景图片
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) CancelBlock cancelBlock;
@property (nonatomic, copy) SureBlock sureBlock;

//- (void)showView;
- (void)showViewWithMessage:(NSString *)message
                cancelTitle:(NSString *)cancelTitle
                  sureTitle:(NSString *)sureTitle
                cancelBlock:(void(^)(UIButton *sender))cancelBlock
               confirmBlcok:(void(^)(UIButton *sender))sureBlock;

@end
