//
//  TableViewDelegate.m
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TableViewDelegate.h"

@implementation TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _model = MusicModel.sharedManager;
//    [_model setValue:@"http://zhangmenshiting.qianqian.com/data2/music/f36bbc7e97f3485dc56867cf16681e02/577326699/577326699.mp3?xcode=da0dc970f671ddf9554bf4edd997f8d2" forKey:@"playUrl"];
    [_model setValue:self.singerArr[indexPath.row] forKey:@"singer"];
    [_model setValue:self.musicNameArr[indexPath.row] forKey:@"playUrl"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


@end
