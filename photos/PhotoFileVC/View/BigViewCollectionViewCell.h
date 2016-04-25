//
//  BigViewCollectionViewCell.h
//  PrivacyPhotos
//
//  Created by lanou3g on 15/4/22.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPhotoView.h"

@interface BigViewCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic, retain) NSString *imagePath;

@property (nonatomic, retain) VIPhotoView *photoView;
@end
