//
//  RootViewController.h
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCImageView.h"
#import "DetailControlViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <notify.h>

@interface RootViewController : UIViewController

//锁屏图片视图,用来绘制带歌词的image
@property (nonatomic, strong) UIImageView * lrcImageView;
@property (nonatomic, strong) DetailControlViewController *detailController;
@property (nonatomic, strong) SCImageView *currentPlaySongImage;
@property (nonatomic, strong) UIButton *playAndPauseButton;
@property (nonatomic, strong) UIButton *nextSongButton;
@property (nonatomic, strong) UISlider *songSlider;
@property (nonatomic, strong) UILabel *songName;
@property (nonatomic, strong) UILabel *singerName;

@property (nonatomic, strong) id playerTimeObserver;

@end
