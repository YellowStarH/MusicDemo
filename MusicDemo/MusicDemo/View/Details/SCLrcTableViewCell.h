//
//  SCLrcTableViewCell.h
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLrcTableViewCell : UITableViewCell

typedef enum SC_AnimationType {
    translation,
    scale,
    rotation,
    scaleAlways,
    scaleNormal,
}AnimationType;


+(SCLrcTableViewCell *) SC_CellForRowWithTableVieW: (UITableView *) tableView;
-(void)addAnimation: (AnimationType)animationType;

@end
