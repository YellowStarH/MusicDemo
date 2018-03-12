//
//  TableViewDataSource.h
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *musicNameArr;
@property (nonatomic,strong) NSMutableArray *singerArr;

@end
