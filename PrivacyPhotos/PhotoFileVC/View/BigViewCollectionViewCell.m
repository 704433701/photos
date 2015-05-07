//
//  BigViewCollectionViewCell.m
//  PrivacyPhotos
//
//  Created by lanou3g on 15/4/22.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "BigViewCollectionViewCell.h"

@implementation BigViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)setImagePath:(NSString *)imagePath
{
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage imageWithData:data];
    if (_photoView != nil) {
        [_photoView removeFromSuperview];
    }
    self.photoView = [[VIPhotoView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_photoView];
    _photoView.imageView.image = image;
    [_photoView size];
    
}

@end
