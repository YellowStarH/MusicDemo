//
//  MusicModel.m
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

static MusicModel *_sharedManager = nil;

+(MusicModel *)sharedManager {
    @synchronized( [MusicModel class] ){
        if(!_sharedManager)
            _sharedManager = [[self alloc] init];
        return _sharedManager;
    }
    return nil;
}


#pragma mark - int转NSString
-(NSString *)intToString: (int)needTransformInteger {
    
    //实现00：00这种格式播放时间
    int wholeTime = needTransformInteger;
    
    int min  = wholeTime / 60;
    
    int sec = wholeTime % 60;
    
    NSString *str = [NSString stringWithFormat:@"%02d:%02d", min , sec];
    
    return str;
}

#pragma mark - NSString转int
-(int) stringToInt: (NSString *)timeString {
    
    NSArray *strTemp = [timeString componentsSeparatedByString:@":"];
    
    int time = [strTemp.firstObject intValue] * 60 + [strTemp.lastObject intValue];
    
    return time;
    
}



@end
