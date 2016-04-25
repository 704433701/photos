//
//  OnOffTableViewCell.m
//  PrivacyPhotos
//
//  Created by lanou3g on 15/4/23.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "OnOffTableViewCell.h"


@implementation OnOffTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] init];
        self.backgroundColor = [UIColor clearColor];
        self.mySwitch = [[UISwitch alloc] init];
        [self.contentView addSubview:_mySwitch];
        self.label = [[UILabel alloc] init];
        _label.textColor= [UIColor whiteColor];
        _label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat height = self.contentView.frame.size.height;
    CGFloat width = self.contentView.frame.size.width;
    self.mySwitch.frame = CGRectMake(width * 3 / 4, height / 4, width / 2, height / 2);
    self.label.frame = CGRectMake(15, 0, width, height);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
