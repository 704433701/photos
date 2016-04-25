//
//  PhotoCollectionViewCell.m
//  PrivacyPhotos
//
//  Created by zhangjianhua on 15/4/18.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        //_imageView.transform = CGAffineTransformMakeRotation(1.2);
        [self.contentView addSubview:_imageView];
        
//        self.deleteView = [[UIImageView alloc] init];
//        _deleteView.image = [UIImage imageNamed:@"delete.png"];
//        [self.contentView addSubview:_deleteView];
        
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    CGFloat width = layoutAttributes.frame.size.width;
    CGFloat height = layoutAttributes.frame.size.height;
    _imageView.frame = CGRectMake(0, 0, width, height);
   // _deleteView.frame = CGRectMake(0, 0, width, height);
    _button.frame = CGRectMake(width - 30, 0, 30, 30); 
}
@end
