//
//  MusicPlayerManager.h
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicPlayerManager : NSObject

typedef enum : NSUInteger {
    RepeatPlayMode,
    RepeatOnlyOnePlayMode,
    ShufflePlayMode,
} ShuffleAndRepeatState;

@property (nonatomic,strong) AVPlayer *play;
@property (nonatomic,strong) AVPlayerItem *playItem;
@property (nonatomic,assign) ShuffleAndRepeatState shuffleAndRepeatState;
@property (nonatomic,assign) NSInteger playingIndex;

+ (MusicPlayerManager *)sharedManager;
-(void) setPlayItem: (NSString *)songURL;
-(void) setPlay;
-(void) startPlay;
-(void) stopPlay;
-(void) play: (NSString *)songURL;

@end
