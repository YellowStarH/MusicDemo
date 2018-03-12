//
//  LrcParser.m
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "LrcParser.h"

@interface LrcParser ()

-(void) parseLrc:(NSString *)word;

@end


@implementation LrcParser

static LrcParser *_sharedManager = nil;

+(LrcParser *)sharedManager {
    @synchronized( [LrcParser class] ){
        if(!_sharedManager)
            _sharedManager = [[self alloc] init];
        return _sharedManager;
    }
    return nil;
}

-(instancetype) init{
    self=[super init];
    if(self!=nil){
        self.timerArray=[[NSMutableArray alloc] init];
        self.wordArray=[[NSMutableArray alloc] init];
    }
    return  self;
}



-(NSString *)getLrcFile:(NSString *)lrc{
    NSString* filePath=[[NSBundle mainBundle] pathForResource:lrc ofType:@"lrc"];
    return  [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}
//测试示例
-(void)parseLrc{
    [self parseLrc:[self getLrcFile:@"董小姐"]];
}


-(void)parseLrc:(NSString *)lrc{
    NSLog(@"%@",lrc);
    [self.timerArray removeAllObjects];
    [self.wordArray removeAllObjects];
    
    if(![lrc isEqual:nil]){
        NSArray *sepArray=[[self getLrcFile:lrc] componentsSeparatedByString:@"["];
        NSArray *lineArray=[[NSArray alloc] init];
        for(int i=0;i<sepArray.count;i++){
            if([sepArray[i] length]>0){
                lineArray=[sepArray[i] componentsSeparatedByString:@"]"];
                if(![lineArray[0] isEqualToString:@"\n"]){
                    [self.timerArray addObject:lineArray[0]];
                    
                    [self.wordArray addObject:lineArray.count>1?lineArray[1]:@""];
                }
            }
        }
    }
}

@end
