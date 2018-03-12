//
//  SCIconView.h
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCImageView.h"

@interface SCIconView : UIView

@property(nonatomic, strong) SCImageView *imageView;

- (instancetype)initWithFrame:(CGRect)frame;
-(void) setAlbumImage: (UIImage *)image;

@end
