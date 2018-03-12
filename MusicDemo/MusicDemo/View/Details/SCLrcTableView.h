//
//  SCLrcTableView.h
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLrcTableViewCell.h"
#import "LrcParser.h"

@interface SCLrcTableView : UITableViewController

@property (strong,nonatomic) LrcParser* lrcContent;
@property (nonatomic,assign) NSInteger currentRow;

-(void) SC_SetUpLrcTableViewFrame: (CGRect)frame;

//@property (nonatomic, assign) int Lrc_Index;
//@property (nonatomic, assign) SCLrcTableViewCell *currentCell;
//@property (nonatomic, assign) SCLrcTableViewCell *lrcOldCell;
//
////用来显示锁屏歌词
//@property (nonatomic, strong) UITableView * lockScreenTableView;
//@property (nonatomic, assign) SCLrcTableViewCell *lockCurrentCell;
//@property (nonatomic, assign) SCLrcTableViewCell *loackLrcOldCell;
//@property (nonatomic,assign)  NSInteger currentRow;
//@property (nonatomic, assign) BOOL isDragging;
//
//@property (nonatomic, assign) int old_Index;
//@property (nonatomic, assign) int mLineNumber;
//@property (nonatomic, assign) BOOL mIsLRCPrepared;
//
//-(instancetype)initWithStyle:(UITableViewStyle)style;
//-(void) SC_SetUpLrcTableViewFrame: (CGRect)frame;
//-(void) setLrc_Index: (int)lrc_index;
//-(void) AnalysisLRC: (NSString *)lrcPath;
//-(UIImage *)getBlurredImage:(UIImage *)image;




@end
