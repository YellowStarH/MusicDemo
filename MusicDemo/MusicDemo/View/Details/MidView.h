//
//  MidView.h
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCIconView.h"
#import "SCLrcTableView.h"

@interface MidView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) SCIconView* midIconView;
@property (nonatomic, strong) SCLrcTableView *midLrcView;


@end
