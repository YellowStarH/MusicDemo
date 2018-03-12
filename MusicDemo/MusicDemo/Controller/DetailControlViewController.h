//
//  DetailControlViewController.h
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopView.h"
#import "MidView.h"
#import "SCIconView.h"
#import "BottomView.h"
#import "LrcParser.h"


@interface DetailControlViewController : UIViewController

@property(nonatomic, strong) TopView *topView;              // SongListView的topView
@property(nonatomic, strong) MidView *midView;
@property(nonatomic, strong) BottomView *bottomView;
@property(nonatomic, strong) UIImageView *backgroundImageView;

-(void) setBackgroundImage: (UIImage *)image;
-(void) playStateRecover;

- (void)updateSong:(CGFloat)currentTime;
//歌词
@property (strong,nonatomic) LrcParser* lrcContent;

@end
