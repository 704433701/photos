//
//  AppDelegate.h
//  photos
//
//  Created by 张健华-迈动 on 16/4/25.
//  Copyright © 2016年 张健华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLockViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 手势解锁相关
@property (strong, nonatomic) LLockViewController* lockVc; // 添加解锁界面
- (void)showLLLockViewController:(LLLockViewType)type;
@end

