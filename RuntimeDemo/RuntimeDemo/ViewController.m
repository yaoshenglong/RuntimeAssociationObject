//
//  ViewController.m
//  RuntimeDemo
//
//  Created by 姚胜龙 on 16/9/12.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Person.h"
#import "TestTableViewController.h"
#import "YiCustomAlertView.h"

@interface ViewController ()

@end

static const char *GQKey = "GQKey";

@implementation ViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    Person *aPerson = [Person person];
    objc_msgSend(aPerson, @selector(changeMethods));
//    [aPerson changeMethods];
//    //消息机制
//    [aPerson setAge:15];
//    NSLog(@"age:%ld", aPerson.age);
//    // objc 实现
//    objc_msgSend(aPerson, @selector(setAge:), 20);
//    NSLog(@"age:--%ld", aPerson.age);

}

- (IBAction)alertShow:(id)sender {

    YiCustomAlertView *alertView = [[YiCustomAlertView alloc] init];
    [alertView showViewWithMessage:@"babababbababbab"
                       cancelTitle:@"取消"
                         sureTitle:@"觉续完"
                       cancelBlock:^(UIButton *sender) {
                           NSLog(@"____取消回调");
                       } confirmBlcok:^(UIButton *sender) {
                           NSLog(@"—----确认回调");
                       }];
}

- (IBAction)exchangeMethod:(id)sender {

    Person *person = [Person person];
    //交换了方法  再次调用run 其实是work方法
    [person replaceMethods];
    [person run];
}
- (IBAction)attributeList:(id)sender {

    NSMutableArray *array = [NSMutableArray array];
    Person *aPerson = [Person person];

    Class personClass = aPerson.class;
    unsigned int outCount = 0;//初始化为o
    //    如何遍历实例变量
    Ivar *ivar = class_copyIvarList(personClass, &outCount);
    for (int i = 0; i < outCount; i++) {
        NSLog(@"ivar : %s", ivar_getName(ivar[i]));
        [array addObject:[NSString stringWithFormat:@"变量：%s",ivar_getName(ivar[i])]];
    }
    free(ivar);

    //    动态遍历类中的属性
    objc_property_t *properPtr = class_copyPropertyList(personClass, &outCount);
    for (int i =0; i < outCount; i++) {
        objc_property_t propertySub = properPtr[i];
        NSLog(@"property:%s", property_getName(propertySub));
        [array addObject:[NSString stringWithFormat:@"属性：%s",property_getName(propertySub)]];
    }
    free(properPtr);

    //    遍历对象方法
    Method *methods = class_copyMethodList(personClass, &outCount);
    for (int i = 0; i <outCount; i++) {
        Method method = methods[i];

        SEL selecter = method_getName(method);
        NSLog(@"方法：%@", NSStringFromSelector(selecter));
        [array addObject:[NSString stringWithFormat:@"方法：%@", NSStringFromSelector(selecter)]];
    }
    free(methods);

    NSLog(@"Person：%@", array);
}

//动态的挂起
- (IBAction)guaqi:(id)sender {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂时挂起，延时调用" preferredStyle:UIAlertControllerStyleAlert];
    __block typeof(self) blockSelf = self;
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [blockSelf dismissViewControllerAnimated:YES completion:^{

        }];
    }];
    [alertVC addAction:confirm];

    Person *aPerson = [Person person];

    objc_setAssociatedObject(aPerson, GQKey, alertVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showLaterWith:aPerson];
    });
}

- (IBAction)showLater:(id)sender {
//    [self showLaterWith:<#(Person *)#>]
}

- (void)showLaterWith:(Person *)person {

    UIAlertController *alertVC = objc_getAssociatedObject(person, GQKey);
    [self presentViewController:alertVC animated:YES completion:^{
        NSLog(@"延时显示完成");
    }];
}

- (IBAction)addSomethingForClass:(id)sender {

    const char *className = "MyClass";
    Class myClass = objc_getClass(className);
    if (!myClass) {
        Class superClass = [NSObject class];
        myClass = objc_allocateClassPair(superClass, className, 0);
    }
    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = {"C", ""};
    objc_property_attribute_t backingIvar = {"V", "aProperty"};
    objc_property_attribute_t attribute[] = {type, ownership, backingIvar};
    class_addIvar(myClass, "aProperty", sizeof(NSString *), 0, "@");
    class_addProperty(myClass, "aProperty", attribute, 1);
    class_addMethod(myClass, @selector(aProperty), (IMP)aProperty, "@@:");
    class_addMethod(myClass, @selector(setAProperty:), (IMP)setAProperty, "v@:@");

    //添加变量
    class_addIvar(myClass, "aIvar", sizeof(NSString *), 0, "@");

    //添加一个方法
    class_addMethod(myClass, @selector(aMethod:), (IMP)aMethod, "v@:@");

    //_________________实例化————————————————————————————
    id myclass = [myClass new];
    Ivar ivar = class_getInstanceVariable(myClass, "aIvar");
    object_setIvar(myclass, ivar, @"秘密IM一一米");
    [myclass setAProperty:@"这是Set属性"];
    [myclass aMethod:1000];

}


/*********************添加属性************************/

//get
NSString *aProperty(id SELF, SEL _cmd) {
    Ivar ivar = class_getInstanceVariable([SELF class], "aProperty");
    return object_getIvar(SELF, ivar);
}

- (NSString *)aProperty{
    return @" ";
}

//set 方法
void setAProperty (id SELF, SEL _cmd, NSString *aProperty) {
    Ivar ivar = class_getInstanceVariable([SELF class], "aProperty");
    id oldName = object_getIvar(SELF, ivar);
    if (oldName != aProperty) {
        object_setIvar(SELF, ivar, [aProperty copy]);
    }
}

- (void)setAProperty:(NSString *)aProperty {

}

/*****************方法************************/

void aMethod(id SELF, SEL _cmd, int a) {

    NSLog(@"调用好了方法...\n传入的参数为:%d", a);

    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"传入值为%d", a] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}

- (void)aMethod:(int)a {

}


/********************方法的替换********************/
//NSString *description(id SELF, SEL _cmd) {
//    NSString *string1 = getClassAttribute[SELF class];
//
//}
- (IBAction)showTestView:(id)sender {
    
//    TestTableViewController *testVC  = [[TestTableViewController alloc] initWithNibName:@"TestTableViewController" bundle:nil];
//    testVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:testVC animated:YES];
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"测试测试" message:@"ceshiyixa" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"-------");
//        [self dismissViewControllerAnimated:NO completion:^{
//            NSLog(@"___");
            TestTableViewController *testVC  = [[TestTableViewController alloc] initWithNibName:@"TestTableViewController" bundle:nil];
            testVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:testVC animated:YES];
//        }];
    }];
    [alertVC addAction:alertAction];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:YES completion:^{

        }];
    });

}

- (IBAction)demo:(id)sender {
    
    TestTableViewController *testVC  = [[TestTableViewController alloc] initWithNibName:@"TestTableViewController" bundle:nil];
    testVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:testVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
