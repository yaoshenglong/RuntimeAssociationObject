//
//  YiCustomAlertView.m
//  RuntimeDemo
//
//  Created by 姚胜龙 on 16/10/18.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import "YiCustomAlertView.h"

#define kDefaultBackgroundColor [UIColor clearColor]
#define kAlertColor [UIColor whiteColor]
#define kCancelBtnTextColor [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
#define kSureBtnTextColor [UIColor colorWithRed:1.0 green:84/255.0 blue:84/255.0 alpha:1]
#define kDefaultImage [UIImage imageNamed:@"alert_popup_shadow"]
#define kAlertViewTag 1000000
#define kMargin 10.0
#define kAlertWidth 300.0
#define kAlertHeight 150.0
#define kScreenSize [UIScreen mainScreen].bounds.size

@interface YiCustomAlertView ()

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UILabel *msgLabel;

@end

@implementation YiCustomAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {

    UIWindow *kWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = kWindow.bounds;
    self.backgroundColor = [UIColor clearColor];
    [kWindow addSubview:self];

    //背景图片
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenSize.width - kAlertWidth)/2.0, (kScreenSize.height - kAlertHeight) / 2.0, kAlertWidth, kAlertHeight)];
    imgView.image = kDefaultImage;
    [self addSubview:imgView];

    //alert view
    CGFloat xOffset = imgView.frame.origin.x + kMargin;
    CGFloat yAlOffset = imgView.frame.origin.y + kMargin;
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, yAlOffset, (kAlertWidth - kMargin * 2), (kAlertHeight - kMargin * 2))];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 2.0;
    alertView.layer.masksToBounds = YES;
    [self addSubview:alertView];

    //meaasge label
    CGFloat labelW = alertView.frame.size.width - 8 * 2;
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, labelW, 74.0)];
    msgLabel.textColor = [UIColor blackColor];
    msgLabel.numberOfLines = 0;
    msgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.font = [UIFont systemFontOfSize:14];
    msgLabel.preferredMaxLayoutWidth = labelW;
    [alertView addSubview:msgLabel];
    self.msgLabel = msgLabel;
    //创建按钮
    CGFloat btnWidth = (kAlertWidth - kMargin * 6 - 1) / 2.0;
    CGFloat btnHeight = 22.0;
    CGFloat yOffset = alertView.frame.size.height - kMargin - btnHeight;
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(kMargin, yOffset, btnWidth, btnHeight);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
                    forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn = cancelBtn;
    [alertView addSubview:cancelBtn];

    //separator
    CGFloat separatorH = 17.0;
    CGFloat yoffset = cancelBtn.frame.origin.y + (btnHeight - separatorH) / 2.0;
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake((kMargin * 2 + btnWidth), yoffset, 1.0, separatorH)];
    separator.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [alertView addSubview:separator];

    //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(kMargin * 3 + btnWidth + 1, yOffset, btnWidth, btnHeight);
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [sureBtn setTitleColor:[UIColor redColor]
                  forState:UIControlStateNormal];
    [sureBtn addTarget:self
                action:@selector(sureAction:)
      forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn = sureBtn;
    [alertView addSubview:sureBtn];
    
}

- (void)showViewWithMessage:(NSString *)message
                cancelTitle:(NSString *)cancelTitle
                  sureTitle:(NSString *)sureTitle
                cancelBlock:(void(^)(UIButton *sender))cancelBlock
               confirmBlcok:(void(^)(UIButton *sender))sureBlock
{
    self.msgLabel.text = message;
    [self.cancelBtn setTitle:cancelTitle
                    forState:UIControlStateNormal];
    [self.sureBtn setTitle:sureTitle
                  forState:UIControlStateNormal];
    self.cancelBlock = cancelBlock;
    self.sureBlock = sureBlock;
}

#pragma mark - Action Button
- (void)cancelAction:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock(sender);
    }
    [self removeFromSuperview];
}

- (void)sureAction:(UIButton *)sender {
    if (self.sureBlock) {
        self.sureBlock(sender);
    }
    [self removeFromSuperview];
}

@end
