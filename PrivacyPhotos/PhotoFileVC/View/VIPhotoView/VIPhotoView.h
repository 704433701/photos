//
//  VIPhotoView.h
//  VIPhotoViewDemo
//
//  Created by Vito on 1/7/15.
//  Copyright (c) 2015 vito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPhotoView : UIScrollView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *containerView;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)size;
- (void)setMaxMinZoomScale;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com