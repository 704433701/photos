//
//  PwdCollectionViewCell.m
//  PrivacyPhotos
//
//  Created by lanou3g on 15/4/23.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "PwdCollectionViewCell.h"

@implementation PwdCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.view = [[UIView alloc] init];
        self.view.layer.cornerRadius = 64.0 / 2.0f;
        self.view.layer.borderWidth = 1.0f;
        self.view.layer.masksToBounds = YES;
        self.view.layer.borderColor = [[UIColor redColor]CGColor];
        [self.contentView addSubview:_view];
        
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_numberLabel];
        
        self.zimuLabel = [[UILabel alloc] init];
        self.zimuLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_zimuLabel];
        
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    CGFloat width = layoutAttributes.frame.size.width;
    CGFloat height = layoutAttributes.frame.size.height;
    self.view.frame = CGRectMake(0, 0, width, height);
}
@end
