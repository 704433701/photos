//
//  AppDelegate.h
//  PrivacyPhotos
//
//  Created by zhangjianhua on 15/4/18.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLockViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 手势解锁相关
@property (strong, nonatomic) LLockViewController* lockVc; // 添加解锁界面
- (void)showLLLockViewController:(LLLockViewType)type;
@end

