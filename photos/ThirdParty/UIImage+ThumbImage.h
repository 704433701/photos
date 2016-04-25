//
//  UIImage+ThumbImage.h
//  PrivacyPhotos
//
//  Created by zhangjianhua on 15/4/20.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ThumbImage)


// 自动缩放到指定大小
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;

// 保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
@end
