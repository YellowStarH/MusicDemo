//
//  CustomTableViewCell.m
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "CustomTableViewCell.h"

#define HScreen [[UIScreen mainScreen] bounds].size.height
#define WScreen [[UIScreen mainScreen] bounds].size.width

@implementation CustomTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 50, 50)];
        _img.image = [UIImage imageNamed:@"邓紫棋1"];
        [self.contentView addSubview:_img];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_img.frame) + 10, 5, WScreen, 20)];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
        
        _singerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_img.frame) + 10, CGRectGetMaxY(_titleLabel.frame) + 5, 200, 20)];
        [self.contentView addSubview:_singerLabel];
        _singerLabel.text = @"周杰伦";
        _singerLabel.textColor = [UIColor purpleColor];
        _singerLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
