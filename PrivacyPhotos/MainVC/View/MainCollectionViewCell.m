//
//  MainCollectionViewCell.m
//  PrivacyPhotos
//
//  Created by zhangjianhua on 15/4/18.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MainCollectionViewCell.h"


@implementation MainCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"bgimage"];
        _imageView.userInteractionEnabled = YES;
        //_imageView.transform = CGAffineTransformMakeRotation(1.2);
        [self.contentView addSubview:_imageView];
        
        self.photo = [[UIImageView alloc] init];
        _photo.layer.cornerRadius = 3;
        _photo.clipsToBounds = YES;
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        
        self.photo.backgroundColor = [UIColor whiteColor];
        [self.imageView addSubview:_photo];
        
        self.label = [[UILabel alloc] init];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button setBackgroundImage:[UIImage imageNamed:@"delete-circular.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
        
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    CGFloat width = layoutAttributes.frame.size.width;
    CGFloat height = layoutAttributes.frame.size.height;
    _imageView.frame = CGRectMake(0, 0, width, height - 30);
    _photo.frame = CGRectMake(10, 10, _imageView.frame.size.width * 11 / 15, _imageView.frame.size.height * 11 / 15);
    _photo.center = _imageView.center;
    _label.frame = CGRectMake(0, height - 30, width, 30);
    _button.frame = CGRectMake(width - 30, 0, 30, 30);    
}
@end
