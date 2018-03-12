//
//  MusicModel.h
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

+(MusicModel *)sharedManager;

@property (nonatomic,strong) NSString *playUrl;
@property (nonatomic,strong) NSString *singer;

-(NSString *)intToString: (int)needTransformInteger;

-(int) stringToInt: (NSString *)timeString;

@end
