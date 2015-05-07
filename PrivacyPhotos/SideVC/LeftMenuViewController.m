//
//  MenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//
#import "LeftMenuViewController.h"
#import "OnOffTableViewCell.h"
#import "MainViewController.h"
#import "settingPwdViewController.h"
#import "LocalAuthentication/LAContext.h"
#import "MoreViewController.h"

@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) NSUserDefaults *user;
// 手势解锁相关
@property (strong, nonatomic) LLockViewController* lockVc; // 添加解锁界面

@property (nonatomic, assign) BOOL switchOn; // 开关
@property (nonatomic, assign) BOOL normalPwd; // 普通密码
@property (nonatomic, assign) BOOL drawPwd; // 图形密码
@property (nonatomic, assign) BOOL touchPwd; // 指纹密码
@property (nonatomic, assign) BOOL changePwd; // 修改密码

@property (nonatomic, retain) MainViewController *mainVC;
@property (nonatomic, retain) settingPwdViewController *settingVC;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 6) / 2.0f, WIDTH * 2 / 3, 54 * 7) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT - 40, WIDTH, 30)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:16];
    _label.text = @"开发者:Angel,为了您的隐私倾情打造!!!";
    [self.view addSubview:_label];
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    _label.userInteractionEnabled = YES;
    tap.numberOfTapsRequired = 10;
    [_label addGestureRecognizer:tap];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH / 4, (HEIGHT - 54 * 6) / 4, (HEIGHT - 54 * 6) / 4, (HEIGHT - 54 * 6) / 4)];
    iconView.layer.cornerRadius = 10;
    iconView.clipsToBounds = YES;
    iconView.alpha = 0.7;
    iconView.image = [UIImage imageNamed:@"icon@2x"];
    [self.view addSubview:iconView];
    
}

// 彩蛋
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    _label.text = @"开发者:张健华,为了您的隐私倾情打造!!!";
    _label.textColor = [UIColor colorFromHexCode:@"#2585a6"];
}

#pragma mark - 弹出手势解锁密码输入框
- (void)showLLLockViewController:(LLLockViewType)type
{
   
        self.lockVc = [[LLockViewController alloc] init];
        self.lockVc.nLockViewType = type;
        
        self.lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:_lockVc]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            self.mainVC = [MainViewController standardMainViewController];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:_mainVC]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
            break;
        case 4:
        {
            self.settingVC = [[settingPwdViewController alloc] init];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:_settingVC]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        }
        case 5:
        {
            [self showLLLockViewController:LLLockViewTypeCreate];
            break;
        }
        case 6:
        {
            MoreViewController *moreVC = [[MoreViewController alloc] init];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:moreVC]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        }
        default:
            break;
    }
}

- (void)on_off
{
    
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.user = [NSUserDefaults standardUserDefaults];
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titles = @[@"首页", @"普通密码", @"图形密码", @"指纹密码", @"设置普通密码", @"设置图形密码",@"更多"];
   // NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconEmpty"];
    if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = titles[indexPath.row];
     //   cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
        return cell;
    }
    OnOffTableViewCell *cell = [[OnOffTableViewCell alloc] init];
    cell.label.text = titles[indexPath.row];
    [cell.mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    NSString *key = [NSString stringWithFormat:@"%ld", indexPath.row];
    [cell.mySwitch setOn:[_user boolForKey:key] animated:YES];
    if (indexPath.row == 3 && ![_user boolForKey:@"1"] && ![_user boolForKey:@"2"]) {
        cell.mySwitch.enabled = NO;
    }
    cell.mySwitch.tag = indexPath.row + 200;
    return cell;
}

- (void)switchAction:(UISwitch *)switc
{
    NSInteger index = switc.tag - 200;
    NSString *key = [NSString stringWithFormat:@"%ld", index];
    UISwitch *swit = (UISwitch *) [self.view viewWithTag:203];
    [_user setBool:switc.on forKey:key];
    if (index == 1) {
        UISwitch *swit = (UISwitch *) [self.view viewWithTag:202];
        [_user setBool:NO forKey:@"2"];
        [swit setOn:NO animated:YES];
    }
    if (index == 2) {
        if ([_user objectForKey:@"lock"] == nil) {
            [self showLLLockViewController:LLLockViewTypeCreate];
        }
        UISwitch *swit = (UISwitch *) [self.view viewWithTag:201];
        [_user setBool:NO forKey:@"1"];
        [swit setOn:NO animated:YES];
    }
    if (![_user boolForKey:@"1"] && ![_user boolForKey:@"2"]) {
        [_user setBool:NO forKey:@"3"];
        [swit setOn:NO animated:YES];
        swit.enabled = NO;
        
    } else {
        swit.enabled = YES;
    }
    if (index == 3 && ![self touch]) {
        [_user setBool:NO forKey:key];
        [switc setOn:NO animated:YES];
    }
}

- (BOOL)touch
{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        NSLog(@"aaaaaa");
        return YES;
    } else {
        // Could not evaluate policy; look at authError and present an appropriate message to user
        [[[UIAlertView alloc] initWithTitle:@"抱歉" message:@"您的设备不支持指纹识别\n 或者您还没有添加指纹" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return NO;
    }
}

@end
