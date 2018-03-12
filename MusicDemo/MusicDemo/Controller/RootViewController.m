//
//  RootViewController.m
//  MusicDemo
//
//  Created by 黄杨洋 on 2018/3/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "TableViewDelegate.h"
#import "TableViewDataSource.h"
#import "MusicPlayerManager.h"
#import "MusicModel.h"
#import "LrcParser.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HScreen [[UIScreen mainScreen] bounds].size.height
#define WScreen [[UIScreen mainScreen] bounds].size.width

@interface RootViewController (){
    TableViewDataSource *tableViewDataSource;
    TableViewDelegate *tableViewDelegate;
    
}

@property (nonatomic,strong) UITableView *tableView;
//底部播放视图
@property (nonatomic, strong) UIView *playView;

@property (nonatomic,strong) MusicPlayerManager *musicPlayer;

@property (nonatomic,strong) MusicModel *model;

//
@property (nonatomic,strong) NSMutableArray *musicNameArr;
//
@property (nonatomic,strong) NSMutableArray *singerArr;

@end

@implementation RootViewController


- (NSMutableArray *)musicNameArr{
    if (!_musicNameArr) {
        _musicNameArr = [[NSMutableArray alloc]initWithObjects:@"心碎了无痕",@"瓦解",@"一千年以后",@"最佳损友",@"传奇",@"简单爱",@"I want it that way",@"泡沫",@"小苹果",@"董小姐",@"月半小夜曲", nil];
    }
    return _musicNameArr;
}

-(NSMutableArray *)singerArr{
    if (!_singerArr) {
        _singerArr = [[NSMutableArray alloc]initWithObjects:@"张学友",@"南拳妈妈",@"林俊杰",@"陳奕迅",@"王菲",@"周杰伦",@"Backstreet Boys",@"邓紫棋",@"筷子兄弟",@"宋冬野",@"李克勤", nil];
    }
    return _singerArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _musicPlayer = MusicPlayerManager.sharedManager;
    
    
    
    self.title = @"播放列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createRemoteCommandCenter];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WScreen, HScreen - 64 - 60) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    tableViewDataSource = [[TableViewDataSource alloc] init];
    tableViewDelegate = [[TableViewDelegate alloc] init];
    tableViewDelegate.musicNameArr = self.musicNameArr;
    tableViewDataSource.musicNameArr = self.musicNameArr;
    tableViewDelegate.singerArr = self.singerArr;
    tableViewDataSource.singerArr = self.singerArr;
    self.tableView.dataSource = tableViewDataSource;
    self.tableView.delegate = tableViewDelegate;
    
    
    _model = MusicModel.sharedManager;
    [_model addObserver:self forKeyPath:@"playUrl" options:NSKeyValueObservingOptionNew context:nil];
    
    [self setUpSubview];
    
    // 播放遇到中断，比如电话进来
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
    
}


#pragma mark - 锁屏界面开启和监控远程控制事件
//锁屏界面开启和监控远程控制事件
- (void)createRemoteCommandCenter{
    
    // 远程控制命令中心 iOS 7.1 之后  详情看官方文档：https://developer.apple.com/documentation/mediaplayer/mpremotecommandcenter
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // MPFeedbackCommand对象反映了当前App所播放的反馈状态. MPRemoteCommandCenter对象提供feedback对象用于对媒体文件进行喜欢, 不喜欢, 标记的操作. 效果类似于网易云音乐锁屏时的效果
    
    //添加喜欢按钮
    MPFeedbackCommand *likeCommand = commandCenter.likeCommand;
    likeCommand.enabled = YES;
    likeCommand.localizedTitle = @"喜欢";
    [likeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"喜欢");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //添加不喜欢按钮，这里用作“下一首”
    MPFeedbackCommand *dislikeCommand = commandCenter.dislikeCommand;
    dislikeCommand.enabled = YES;
    dislikeCommand.localizedTitle = @"下一首";
    [dislikeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"下一首");
        [self nextButtonAction:nil];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //标记
    MPFeedbackCommand *bookmarkCommand = commandCenter.bookmarkCommand;
    bookmarkCommand.enabled = YES;
    bookmarkCommand.localizedTitle = @"标记";
    [bookmarkCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"标记");
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 远程控制播放
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [_musicPlayer.play pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 远程控制暂停
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [_musicPlayer.play play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 远程控制上一曲
    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"上一曲");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 远程控制下一曲
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"下一曲");
        [self nextButtonAction:nil];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    
    //快进
    MPSkipIntervalCommand *skipBackwardIntervalCommand = commandCenter.skipForwardCommand;
    skipBackwardIntervalCommand.preferredIntervals = @[@(54)];
    skipBackwardIntervalCommand.enabled = YES;
    [skipBackwardIntervalCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        NSLog(@"你按了快进按键！");
        
        // 歌曲总时间
        CMTime duration = _musicPlayer.play.currentItem.asset.duration;
        Float64 completeTime = CMTimeGetSeconds(duration);
        
        // 快进10秒
        _songSlider.value = _songSlider.value + 10 / completeTime;
        
        // 计算快进后当前播放时间
        Float64 currentTime = (Float64)(_songSlider.value) * completeTime;
        
        // 播放器定位到对应的位置
        CMTime targetTime = CMTimeMake((int64_t)(currentTime), 1);
        [_musicPlayer.play seekToTime:targetTime];
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //在控制台拖动进度条调节进度（仿QQ音乐的效果）
    [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        CMTime totlaTime = _musicPlayer.play.currentItem.duration;
        MPChangePlaybackPositionCommandEvent * playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
        [_musicPlayer.play seekToTime:CMTimeMake(totlaTime.value*playbackPositionEvent.positionTime/CMTimeGetSeconds(totlaTime), totlaTime.timescale) completionHandler:^(BOOL finished) {
        }];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    
}

- (void)setUpSubview{
    // 初始化detailController
    _detailController = [[DetailControlViewController alloc] init];
    
    _playView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.view.frame) * 0.08 - CGRectGetHeight(self.navigationController.navigationBar.frame) - 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) * 0.08)];
    _playView.backgroundColor = UIColorFromRGB(0xff0000);
    _playView.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:_playView];
    [self.view addSubview:_playView];
    
    // 专辑图片
    _currentPlaySongImage = [[SCImageView alloc] initWithFrame:CGRectMake(_playView.frame.size.height * 0.1, -_playView.frame.size.height * 0.2 , _playView.frame.size.height * 1.1 , _playView.frame.size.height * 1.1)];
    _currentPlaySongImage.image = [UIImage imageNamed:@"cm2_simple_defaut_album_image"];
    _currentPlaySongImage.clipsToBounds = true;
    _currentPlaySongImage.layer.cornerRadius = _playView.frame.size.height * 0.55;
    [_playView addSubview:_currentPlaySongImage];
    _currentPlaySongImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToDeitalController)];
    [_currentPlaySongImage addGestureRecognizer:tag];
    
    //播放控制
    _playAndPauseButton = [[UIButton alloc] initWithFrame:CGRectMake(_playView.frame.size.width * 0.75 , _playView.frame.size.height * 0.25 , _playView.frame.size.height * 0.65 , _playView.frame.size.height* 0.65)];
    [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
    [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
    [_playAndPauseButton addTarget:self action:@selector(playAndPauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playView addSubview:_playAndPauseButton];
    
    
    _nextSongButton = [[UIButton alloc] initWithFrame:CGRectMake(_playView.frame.size.width * 0.88 , _playView.frame.size.height * 0.25 , _playView.frame.size.height * 0.65 , _playView.frame.size.height* 0.65)];
    [_nextSongButton setImage:[UIImage imageNamed:@"cm2_fm_btn_next"] forState:UIControlStateNormal];
    [_nextSongButton setImage:[UIImage imageNamed:@"cm2_fm_btn_next_prs"] forState:UIControlStateHighlighted];
    [_nextSongButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playView addSubview:_nextSongButton];
    
    // 歌曲进度条
    _songSlider = [[UISlider alloc] initWithFrame:CGRectMake(_playView.frame.size.height * 1.3 , 0 , _playView.frame.size.width - _playView.frame.size.height * 1.3 , _playView.frame.size.height* 0.3)];
    [_songSlider setThumbImage:[UIImage imageNamed:@"cm2_simple_knob_trough_prs"] forState:UIControlStateNormal];
    [_songSlider setThumbImage:[UIImage imageNamed:@"cm2_simple_knob_trough_prs"] forState:UIControlStateHighlighted];
    _songSlider.tintColor = UIColorFromRGB(0xffffff);
    
    //设置slider响应事件
    [_songSlider addTarget:self //事件委托对象
                    action:@selector(playbackSliderValueChanged) //处理事件的方法
          forControlEvents:UIControlEventValueChanged//具体事件
     ];
    [_songSlider addTarget:self //事件委托对象
                    action:@selector(playbackSliderValueChangedFinish) //处理事件的方法
          forControlEvents:UIControlEventTouchUpInside//具体事件
     ];
    [_playView addSubview:_songSlider];
    
    // 歌名和歌手名
    _songName = [[UILabel alloc] initWithFrame:CGRectMake(_playView.frame.size.height * 1.3,  _playView.frame.size.height* 0.3 , _playView.frame.size.width * 0.5 , _playView.frame.size.height* 0.3)];
    //    songName.backgroundColor = [UIColor blackColor];
    _songName.text = @"Unkown";
    _songName.textColor = [UIColor whiteColor];
    _songName.font = [UIFont systemFontOfSize:16.0];
    [_playView addSubview:_songName];
    
    _singerName = [[UILabel alloc] initWithFrame:CGRectMake(_playView.frame.size.height * 1.3,  _playView.frame.size.height* 0.7 , _playView.frame.size.width * 0.5 , _playView.frame.size.height* 0.2)];
    //    singerName.backgroundColor = [UIColor blackColor];
    _singerName.text = @"Unkown";
    _singerName.textColor = [UIColorFromRGB(0xfafafa) colorWithAlphaComponent:0.95];
    _singerName.font = [UIFont systemFontOfSize:13.0];
    [_playView addSubview:_singerName];
    [self.view addSubview:_playView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - 点击专辑图片
-(void) jumpToDeitalController {
    [self presentViewController:_detailController animated:YES completion:nil];
}

#pragma mark - 音乐被中断处理
- (void) onAudioSessionEvent: (NSNotification *) notification
{
    //Check the type of notification, especially if you are sending multiple AVAudioSession events here
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        NSLog(@"Interruption notification received!");
        
        //Check to see if it was a Begin interruption
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            NSLog(@"Interruption began!");
            [_musicPlayer stopPlay];
        } else {
            NSLog(@"Interruption ended!");
            //Resume your audio
            [_musicPlayer startPlay];
        }
    }
}


#pragma mark - 进度条改变值时触发
//拖动进度条改变值时触发
-(void) playbackSliderValueChanged {
    
    // 更新播放时间
    [self updateTime];
    
    //如果当前时暂停状态，则自动播放
    if (_musicPlayer.play.rate == 0) {
        
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
        [_currentPlaySongImage resumeRotate];
        [_musicPlayer startPlay];
        
    }
}


#pragma mark - 进度条改变值结束时触发
-(void) playbackSliderValueChangedFinish {
    // 更新播放时间
    [self updateTime];
    
    //如果当前时暂停状态，则自动播放
    if (_musicPlayer.play.rate == 0) {
        
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
        [_currentPlaySongImage resumeRotate];
        [_musicPlayer startPlay];
        
    }
}

#pragma mark - 下一曲
-(void) nextButtonAction: (UIButton *)sender {
    
    NSLog(@"下一曲");
}


#pragma mark - 播放或暂停
-(void)playAndPauseButtonAction: (UIButton *)sender {
    
//    NSLog(@"当前播放曲目：%@", songInfo.title);
    
    if (_musicPlayer.play.rate == 0) {//暂停播放
        
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
        [_currentPlaySongImage resumeRotate];
        [_musicPlayer startPlay];
        
    } else {//正在播放
        
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        
        [_currentPlaySongImage stopRotating];
        [_musicPlayer stopPlay];
    }
}


#pragma mark - 更新播放时间
-(void) updateTime {
    
    CMTime duration = _musicPlayer.play.currentItem.asset.duration;
    
    // 歌曲总时间和当前时间
    Float64 completeTime = CMTimeGetSeconds(duration);
    Float64 currentTime = (Float64)(_songSlider.value) * completeTime;
    
    //播放器定位到对应的位置
    CMTime targetTime = CMTimeMake((int64_t)(currentTime), 1);
    [_musicPlayer.play seekToTime:targetTime];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"playUrl"]) {
        [self playSongSetting];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }  
}


#pragma mark - 播放音乐调用
-(void) playSongSetting {
    
    if (_playerTimeObserver != nil) {
        
        [_musicPlayer.play removeTimeObserver:_playerTimeObserver];
        _playerTimeObserver = nil;
        
        [_musicPlayer.play.currentItem cancelPendingSeeks];
        [_musicPlayer.play.currentItem.asset cancelLoading];
        
    }
    [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
    [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
    // 主页面控制界面信息设置
    _songName.text = _model.playUrl;
    _singerName.text = _model.singer;;
    _currentPlaySongImage.image = [UIImage imageNamed:@"邓紫棋1"];
    [_currentPlaySongImage resumeRotate];
    
    // detail页面控制界面信息设置
    _detailController.topView.songTitleLabel.text = _model.playUrl;
    _detailController.topView.singerNameLabel.text = _model.singer;
    [_detailController.midView.midIconView setAlbumImage:[UIImage imageNamed:@"邓紫棋1"]];
    //歌词
    _detailController.lrcContent = [LrcParser sharedManager];
    [_detailController.lrcContent parseLrc:_model.playUrl];
//    [_detailController.midView.midLrcView AnalysisLRC:@""];
    
    
    // 播放设置
    [_musicPlayer setPlayItem:_model.playUrl];
    [_musicPlayer setPlay];
    [_musicPlayer startPlay];
    
    // 歌词index清零
//    songInfo.lrcIndex = 0;
    
    // 控制界面设置
    [_detailController playStateRecover];
    
    // 播放结束通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(finishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:_musicPlayer.play.currentItem];
    
    // 设置Observer更新播放进度
    __weak typeof(self) weakSelf = self;
    _playerTimeObserver = [_musicPlayer.play addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat currentTime = CMTimeGetSeconds(time);
        NSLog(@"当前播放时间：%f", currentTime);
        
        CMTime total = weakSelf.musicPlayer.play.currentItem.duration;
        CGFloat totalTime = CMTimeGetSeconds(total);
        
        // 当前播放时间
        weakSelf.detailController.bottomView.currentTimeLabel.text = [weakSelf.model intToString:(int)currentTime];
        // 总时间
        weakSelf.detailController.bottomView.durationTimeLabel.text =[weakSelf.model intToString:(int)totalTime];
        
        weakSelf.songSlider.value = (float) ( currentTime / totalTime );
        weakSelf.detailController.bottomView.songSlider.value = (float) ( currentTime / totalTime );
        [weakSelf.detailController updateSong:currentTime];
        
        //监听锁屏状态 lock=1则为锁屏状态
        uint64_t locked;
        __block int token = 0;
    notify_register_dispatch("com.apple.springboard.lockstate",&token,dispatch_get_main_queue(),^(int t){
        });
        notify_get_state(token, &locked);
        
        //监听屏幕点亮状态 screenLight = 1则为变暗关闭状态
        uint64_t screenLight;
        __block int lightToken = 0;
        notify_register_dispatch("com.apple.springboard.hasBlankedScreen",&lightToken,dispatch_get_main_queue(),^(int t){
        });
        notify_get_state(lightToken, &screenLight);
        
        BOOL isShowLyricsPoster = NO;
        // NSLog(@"screenLight=%llu locked=%llu",screenLight,locked);
        if (screenLight == 0 && locked == 1) {
            //点亮且锁屏时
            isShowLyricsPoster = YES;
        }else if(screenLight){
            return;
        }
        
        //展示锁屏歌曲信息，上面监听屏幕锁屏和点亮状态的目的是为了提高效率
        [weakSelf showLockScreenTotaltime:totalTime andCurrentTime:currentTime andLyricsPoster:isShowLyricsPoster];
        
    }];
}


#pragma mark - 锁屏播放设置
//展示锁屏歌曲信息：图片、歌词、进度、演唱者
- (void)showLockScreenTotaltime:(float)totalTime andCurrentTime:(float)currentTime andLyricsPoster:(BOOL)isShow{
    
    NSMutableDictionary * songDict = [[NSMutableDictionary alloc] init];
    //设置歌曲题目
    [songDict setObject:_model.playUrl forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [songDict setObject:_model.singer forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [songDict setObject:@"专辑名" forKey:MPMediaItemPropertyAlbumTitle];
    //设置歌曲时长
    [songDict setObject:[NSNumber numberWithDouble:totalTime]  forKey:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    [songDict setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    UIImage * lrcImage = [UIImage imageNamed:@"邓紫棋1"];
    //设置显示的海报图片
    [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:lrcImage]
                 forKey:MPMediaItemPropertyArtwork];
    
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
    
}


#pragma mark - 歌曲播放结束操作
-(void) finishedPlaying {
    [_currentPlaySongImage stopRotating];
    NSLog(@"本歌曲播放结束，准备播放下一首歌曲！");
    [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
    [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
    //    songInfo.playSongIndex = songInfo.playSongIndex + 1;
    [self nextButtonAction:nil];
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
