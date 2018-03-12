//
//  BottomView.h
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomView : UIView

@property (nonatomic, strong) UIButton *preSongButtton;
@property (nonatomic, strong) UIButton *nextSongButton;
@property (nonatomic, strong) UIButton *playOrPauseButton;
@property (nonatomic, strong) UIButton *playModeButton;
@property (nonatomic, strong) UIButton *songListButton;
@property (nonatomic, strong) UISlider *songSlider;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *durationTimeLabel;

@end
