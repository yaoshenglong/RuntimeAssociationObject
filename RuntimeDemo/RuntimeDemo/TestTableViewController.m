//
//  TestTableViewController.m
//  RuntimeDemo
//
//  Created by 姚胜龙 on 16/10/18.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import "TestTableViewController.h"
#import "TestCell.h"
#import <objc/runtime.h>

@interface TestTableViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *dataItems;

@end

static NSString *const kSourceKey = @"SourceKey";

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataItems = @[@"18301267512", @"18701311556", @"15845429832"];

    //register cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TestCell" bundle:nil] forCellReuseIdentifier:@"TestCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell"];
    NSString *phoneNumber = _dataItems[indexPath.row];
    cell.numberLabel.text = phoneNumber;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    cell.callBlack = ^(UIButton *button) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"拨打：" message:phoneNumber delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        //绑定
        objc_setAssociatedObject(alertView, &kSourceKey, phoneNumber, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [alertView show];
    };
#pragma clang diagnostic pop
    return cell;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    //取出
    NSString *numberStr = objc_getAssociatedObject(alertView, &kSourceKey);
    if (buttonIndex == 0) {
        NSString *callString = [NSString stringWithFormat:@"telprompt://%@", numberStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callString]];
    }
}

@end
