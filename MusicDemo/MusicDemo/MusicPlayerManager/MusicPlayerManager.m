//
//  MusicPlayerManager.m
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "MusicPlayerManager.h"

@implementation MusicPlayerManager


static MusicPlayerManager *_sharedManager = nil;

+(MusicPlayerManager *)sharedManager {
    @synchronized( [MusicPlayerManager class] ){
        if(!_sharedManager)
            _sharedManager = [[self alloc] init];
        return _sharedManager;
    }
    return nil;
}


-(void) setPlayItem: (NSString *)songURL {
    //播放网络文件
//    NSURL * url  = [NSURL URLWithString:songURL];
//    _playItem = [[AVPlayerItem alloc] initWithURL:url];
    //播放本地文件
    NSURL *sourceMovieUrl = [[NSBundle mainBundle]  URLForResource:songURL withExtension:@"mp3"];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieUrl options:nil];
    _playItem = [AVPlayerItem playerItemWithAsset:movieAsset];
}

-(void) setPlay {
    _play = [[AVPlayer alloc] initWithPlayerItem:_playItem];
}

-(void) startPlay {
    [_play play];
}

-(void) stopPlay {
    [_play pause];
}

-(void) play: (NSString *)songURL {
    [self setPlayItem:songURL];
    [self setPlay];
    [self startPlay];
}


@end
