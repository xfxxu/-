//
//  ViewController.m
//  短信验证
//
//  Created by mac on 2018/7/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"

#import <SMS_SDK/SMSSDK.h>
@interface ViewController ()

@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *yanzmTextField;
//1、添加依赖库：
//libz.dylib
//libicucore.dylib
//MessageUI.framework
//JavaScriptCore.framework
//libstdc++.dylib
//注意：在XCode7上面运行报错的话，还需要增加这几个依赖库
//SystemConfiguration.framework
//CoreTelephony.framework
//AdSupport.framework
//2、在项目中的info.plist文件中添加键值对，
//键分别为 MOBAppKey 和 MOBAppSecret ，
//值为步骤一申请的appkey和appSecret
//3、导入头文件
//#import <SMS_SDK/SMSSDK.h>
//4、请求方法
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
}

- (void)createUI{
    _phoneNumTextField = [[UITextField alloc] init];
    _phoneNumTextField.frame = CGRectMake(10, 40+88, self.view.frame.size.width-20, 40);
    _phoneNumTextField.layer.borderWidth = 0.5;
    _phoneNumTextField.placeholder = @"手机号";
    _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    _yanzmTextField = [[UITextField alloc] init];
    _yanzmTextField.frame = CGRectMake(10, 100+88, self.view.frame.size.width-120, 40);
    _yanzmTextField.layer.borderWidth = 0.5;
    _yanzmTextField.placeholder = @"验证码";

    UIButton *fasong = [UIButton buttonWithType:UIButtonTypeCustom];
    fasong.frame = CGRectMake(self.view.frame.size.width-110, 100+88, 100, 40);
    [fasong setBackgroundColor:[UIColor blueColor]];
    [fasong setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fasong setTitle:@"验证码" forState:UIControlStateNormal];
    [fasong addTarget:self action:@selector(huoqu) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 200+88, self.view.frame.size.width-20, 40);
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"注册" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickToRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_phoneNumTextField];
    [self.view addSubview:_yanzmTextField];
    [self.view addSubview:fasong];

    [self.view addSubview:button];
}

- (void)huoqu{
    if ([_phoneNumTextField.text isEqualToString:@""]||_phoneNumTextField.text.length!=11) {
        [self createMessage:@"手机号填写不正确"];
    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneNumTextField.text zone:@"86"  result:^(NSError *error) {
        if (!error)
        {
            // 请求成功
            NSLog(@"请求成功");
            [self createMessage:@"消息已发送"];
        }
        else
        {
            // error
            NSLog(@"%@",error);
            [self createMessage:@"手机号格式出错"];
        }
    }];
}
- (void)clickToRegister{
    if ([_yanzmTextField.text isEqualToString:@""] || [_phoneNumTextField.text isEqualToString:@""]) {
        [self createMessage:@"手机号或验证码不能为空"];
    }
    else{
        [SMSSDK commitVerificationCode:_yanzmTextField.text phoneNumber:_phoneNumTextField.text zone:@"86" result:^(NSError *error) {
            if (!error)
            {
                // 验证成功
                MainViewController *mainvc = [[MainViewController alloc] init];
                [self.navigationController pushViewController:mainvc animated:YES];
            }
            else
            {
                // error
                NSLog(@"%@",error);
                [self createMessage:@"手机号和验证码不匹配"];
            }
        }];
    }
}

- (void)createMessage:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
