//
//  LrcParser.h
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcParser : NSObject

+(LrcParser *)sharedManager;

//时间
@property (nonatomic,strong) NSMutableArray *timerArray;
//歌词
@property (nonatomic,strong) NSMutableArray *wordArray;


//解析歌词
-(void) parseLrc;
//解析歌词
-(void) parseLrc:(NSString*)lrc;

@end
