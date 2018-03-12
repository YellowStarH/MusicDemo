//
//  DetailControlViewController.m
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "DetailControlViewController.h"
#import "MusicPlayerManager.h"


@interface DetailControlViewController (){
    MusicPlayerManager *musicPlayer;
}


@property (nonatomic,assign) NSInteger currentRow;

@end

@implementation DetailControlViewController

-(instancetype) init {
    self = [super init];
    if (self) {
        // 初始化SubView
        [self configSubView];
    }
    
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    [self playStateRecover];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.lrcContent= [LrcParser sharedManager];
//    [self.lrcContent parseLrc:@""];
}


#pragma mark - 状态恢复
-(void) playStateRecover {
    
    [_midView.midIconView.imageView startRotating];
    
    if (musicPlayer.play.rate == 1) {
        NSLog(@"播放！");
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
        [_midView.midIconView.imageView stopRotating];
        
       
        
    } else {
        NSLog(@"暂停");
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_midView.midIconView.imageView resumeRotate];
    }
    
}

-(void) backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) configSubView {
    // 初始化musicPlayer和songInfo
    musicPlayer = MusicPlayerManager.sharedManager;
    
    // top view初始化
    _topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 5)];
    [_topView.backBtn addTarget:self action:@selector(backAction) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_topView];
    
    // mid view 初始化
    _midView = [[MidView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 5, self.view.frame.size.width, self.view.frame.size.height / 5 * 3)];
    [self.view addSubview:_midView];
    
    // bottom view 初始化
    _bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 5 * 4, self.view.frame.size.width, self.view.frame.size.height / 5)];
    [self.view addSubview:_bottomView];
    
    // SongListView初始化
//    _songListView                 = [[SongListView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.618)];
//    _songListView.backgroundColor = [UIColor whiteColor];
    
    // 添加playOrPauseButton响应事件
    [_bottomView.playOrPauseButton addTarget:self action:@selector(playOrPauseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加nextSongButton响应事件
    [_bottomView.nextSongButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加preButton响应事件
    [_bottomView.preSongButtton addTarget:self action:@selector(preButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加shuffleAndRepeat响应事件
    [_bottomView.playModeButton addTarget:self action:@selector(shuffleAndRepeat) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加songListButton响应事件
    [_bottomView.songListButton addTarget:self action:@selector(songListButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 播放进度条添加响应事件
    [_bottomView.songSlider addTarget:self //事件委托对象
                               action:@selector(playbackSliderValueChanged) //处理事件的方法
                     forControlEvents:UIControlEventValueChanged//具体事件
     ];
    [_bottomView.songSlider addTarget:self //事件委托对象
                               action:@selector(playbackSliderValueChangedFinish) //处理事件的方法
                     forControlEvents:UIControlEventTouchUpInside//具体事件
     ];
    
    // 设置背景图片
    [self setBackgroundImage:[UIImage imageNamed:@"backgroundImage3"]];
}


#pragma - mark 播放或暂停
-(void) playOrPauseButtonAction {
    
    if (musicPlayer.play.rate == 0) {
        NSLog(@"播放！");
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
        [_midView.midIconView.imageView resumeRotate];
        [musicPlayer startPlay];
        
    } else {
        NSLog(@"暂停");
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_midView.midIconView.imageView stopRotating];
        [musicPlayer stopPlay];
    }
    
}

#pragma - mark 下一曲
-(void) nextButtonAction {
    
}


#pragma - mark 上一曲
-(void) preButtonAction {
    
}

#pragma - mark 播放模式按键action
-(void) shuffleAndRepeat {
    
}

#pragma - mark 歌曲列表
-(void) songListButtonAction {
    NSLog(@"你按下了songList按键！");
    
}

#pragma - mark 进度条改变值结束时触发
-(void) playbackSliderValueChangedFinish {
    // 更新播放时间
    [self updateTime];
    
    //如果当前时暂停状态，则自动播放
    if (musicPlayer.play.rate == 0) {
        
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_midView.midIconView.imageView resumeRotate];
        [musicPlayer startPlay];
        
    }
}

#pragma - mark 进度条改变值时触发
//拖动进度条改变值时触发
-(void) playbackSliderValueChanged {
    
    // 更新播放时间
    [self updateTime];
    
    //如果当前时暂停状态，则自动播放
    if (musicPlayer.play.rate == 0) {
        
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_midView.midIconView.imageView resumeRotate];
        [musicPlayer startPlay];
    }
}

#pragma mark - 更新播放时间
-(void) updateTime {
    
    CMTime duration = musicPlayer.play.currentItem.asset.duration;
    
    // 歌曲总时间和当前时间
    Float64 completeTime = CMTimeGetSeconds(duration);
    Float64 currentTime = (Float64)(_bottomView.songSlider.value) * completeTime;
    
    
    //播放器定位到对应的位置
    CMTime targetTime = CMTimeMake((int64_t)(currentTime), 1);
    [musicPlayer.play seekToTime:targetTime];
    
    NSLog(@"%d:%d",(int)currentTime / 60, (int)currentTime % 60);
    [self updateSong:currentTime];
}


#pragma - mark 更新歌词进度


- (void)updateSong:(CGFloat)currentTime{
    for (int i=0; i<self.lrcContent.timerArray.count; i++) {
        NSArray *timeArray=[self.lrcContent.timerArray[i] componentsSeparatedByString:@":"];
        float lrcTime=[timeArray[0] intValue]*60+[timeArray[1] floatValue];
        if(currentTime>lrcTime){
            _currentRow=i;
        }else
            break;
    }
    _midView.midLrcView.currentRow = _currentRow;
    _midView.midLrcView.lrcContent = self.lrcContent;
    [_midView.midLrcView.tableView reloadData];
    [_midView.midLrcView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


#pragma - mark 设置detail控制界面背景图片
-(void) setBackgroundImage: (UIImage *)image {
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-UIScreen.mainScreen.bounds.size.width / 2, -UIScreen.mainScreen.bounds.size.height / 2, UIScreen.mainScreen.bounds.size.width * 2, UIScreen.mainScreen.bounds.size.height * 2)];
    _backgroundImageView.image = image;
    _backgroundImageView.clipsToBounds = true;
    [self.view addSubview:_backgroundImageView];
    [self.view sendSubviewToBack:_backgroundImageView];
    
    // 毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualView.alpha = 1.0;
    visualView.frame = CGRectMake(-UIScreen.mainScreen.bounds.size.width / 2, -UIScreen.mainScreen.bounds.size.height / 2, UIScreen.mainScreen.bounds.size.width * 2, UIScreen.mainScreen.bounds.size.height * 2);
    visualView.clipsToBounds = true;
    [_backgroundImageView addSubview:visualView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
