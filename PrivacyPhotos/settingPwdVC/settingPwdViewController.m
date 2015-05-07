//
//  settingPwdViewController.m
//  PrivacyPhotos
//
//  Created by lanou3g on 15/4/24.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "settingPwdViewController.h"

@interface settingPwdViewController ()<RESideMenuDelegate, UITextFieldDelegate>

@property (nonatomic, retain) UITextField *pwd;
@property (nonatomic, retain) UITextField *pwd2;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, assign) BOOL first;

@end

@implementation settingPwdViewController

- (instancetype)initWithFirst:(BOOL)first
{
    self = [super init];
    if (self) {
        self.first = first;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置普通密码";
    self.sideMenuViewController.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shezhichilun.png"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    // Do any additional setup after loading the view..
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH / 2 - HEIGHT / 16, HEIGHT / 8 + 10, HEIGHT / 8, HEIGHT / 8)];
    iconView.layer.cornerRadius = 10;
    iconView.clipsToBounds = YES;
    iconView.image = [UIImage imageNamed:@"icon@2x"];
    [self.view addSubview:iconView];
    
    self.pwd = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH / 4, HEIGHT / 4 + 20, WIDTH / 2, 30)];
    _pwd.secureTextEntry = YES;
    _pwd.delegate = self;
    [_pwd becomeFirstResponder];
    _pwd.textAlignment = NSTextAlignmentCenter;
    _pwd.borderStyle = UITextBorderStyleRoundedRect;
    _pwd.placeholder = @"请输入4位新密码";
    _pwd.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_pwd];
    
    self.pwd2 = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH / 4, HEIGHT / 4 + 60, WIDTH / 2, 30)];
    _pwd2.borderStyle = UITextBorderStyleRoundedRect;
    _pwd2.placeholder = @"再次输入新密码";
    _pwd2.secureTextEntry = YES;
    _pwd2.delegate = self;
    _pwd2.textAlignment = NSTextAlignmentCenter;
    _pwd2.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_pwd2];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(WIDTH / 4, HEIGHT / 4 + 100, WIDTH / 2, 30);
    [_button addTarget:self action:@selector(saveLockpwd:) forControlEvents:UIControlEventTouchUpInside];
    _button.tintColor = [UIColor whiteColor];
    _button.layer.cornerRadius = 5;
    _button.enabled = NO;
    _button.backgroundColor = [UIColor colorFromHexCode:@"#009ad6"];
    [_button setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:_button];
    
}

- (void)saveLockpwd:(UIBarButtonItem *)bar
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"普通密码设置成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    if (self.pwd.text.length == 0) {
        alert.title = @"密码不能为空";
    } else if ([self.pwd.text isEqualToString:self.pwd2.text]) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:self.pwd.text forKey:@"putongLock"];
        
        alert.title = @"普通密码设置成功";
        if (_first == NO) {
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[MainViewController standardMainViewController]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        } else {
            [user setBool:YES forKey:@"setPwd"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        alert.title = @"两次密码不一致";
        self.pwd2.text = @"";
    }
    [alert show];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    

    if (toBeString.length > 4) {
        return NO;
    }
    if (toBeString.length < 4) {
        _button.enabled = NO;
    } else {
        _button.enabled = YES;
    }

    return YES;
    
}

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    [UIView animateWithDuration:1 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    }];
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    [UIView animateWithDuration:1 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
