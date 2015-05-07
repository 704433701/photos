//
//  AppDelegate.m
//  PrivacyPhotos
//
//  Created by zhangjianhua on 15/4/18.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LeftMenuViewController.h"
#import "NumLockViewController.h"
#import "LocalAuthentication/LAContext.h"
#import "settingPwdViewController.h"


@interface AppDelegate ()<RESideMenuDelegate>

@property (nonatomic, retain) MainViewController *mainVC;
@property (nonatomic, retain) NSUserDefaults *user;
@property (nonatomic, retain) NumLockViewController *numLockVC;
@property (nonatomic, retain) RESideMenu *sideMenuViewController;

@property (nonatomic, assign) BOOL flag;
@property (nonatomic, assign) BOOL touchSuccess;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _user = [NSUserDefaults standardUserDefaults];
 //   [NSThread sleepForTimeInterval:100];
    [_user setBool:YES forKey:@"first"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.mainVC = [MainViewController standardMainViewController];
    UINavigationController *mainNA = [[UINavigationController alloc] initWithRootViewController:_mainVC];
  //  mainNA.navigationBar.barTintColor = [UIColor colorFromHexCode:@"#fffef9"];
    
    LeftMenuViewController *leftMenuViewController = [[LeftMenuViewController alloc] init];
    self.sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:mainNA
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
    _sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    _sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    _sideMenuViewController.delegate = self;
    _sideMenuViewController.contentViewShadowColor = [UIColor clearColor];
    _sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    _sideMenuViewController.contentViewShadowOpacity = 0.6;
    _sideMenuViewController.contentViewShadowRadius = 12;
    _sideMenuViewController.contentViewShadowEnabled = YES;
    
     self.window.rootViewController = _sideMenuViewController;
    
    if (![_user boolForKey:@"setPwd"]) {
        settingPwdViewController *settingVC = [[settingPwdViewController alloc] initWithFirst:YES];
        settingVC.view.backgroundColor = [UIColor whiteColor];
        [_mainVC presentViewController:settingVC animated:YES completion:^{
        }];
    }
    [self showInPwd];
    
    return YES;
}

#pragma mark - 弹出手势解锁密码输入框
- (void)showLLLockViewController:(LLLockViewType)type
{
  //  if(self.window.rootViewController.presentingViewController == nil){
        
        LLLog(@"root = %@", self.window.rootViewController.class);
        LLLog(@"lockVc isBeingPresented = %d", [self.lockVc isBeingPresented]);
        
        self.lockVc = [[LLockViewController alloc] init];
        self.lockVc.nLockViewType = type;
        
        self.lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
        [_mainVC presentViewController:self.lockVc animated:YES completion:^{
        }];
        LLLog(@"创建了一个pop=%@", self.lockVc);
  //  }
}

- (void)showInPwd
{
    if ([_user boolForKey:@"1"]) {
        self.numLockVC = [[NumLockViewController alloc] init];
        [_mainVC presentViewController:_numLockVC animated:YES completion:^{
        }];
    }
    if ([_user boolForKey:@"2"]) {
        [self showLLLockViewController:LLLockViewTypeCheck];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.touchSuccess = NO;
    [self showInPwd];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   // NSLog(@"活动");
//    [self showInPwd];
    if ([_user boolForKey:@"3"] && !self.touchSuccess) {
        //指纹
        NSLog(@"指纹");
        [self touch];
    }
}

- (void)touch
{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"请输入指纹以解锁";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    // User authenticated successfully, take appropriate action
                                    if ([_user boolForKey:@"1"]) {
                                       [_numLockVC dismissViewControllerAnimated:YES completion:nil];
                                    }
                                    if ([_user boolForKey:@"2"]) {
                                        [_lockVc dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }
                                } else {
                                    // User did not authenticate successfully, look at error and take appropriate action
                                    NSLog(@"失败");
                                }
                                self.touchSuccess = YES;
                            }];
    } else {
        // Could not evaluate policy; look at authError and present an appropriate message to user
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
