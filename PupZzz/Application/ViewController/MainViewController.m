//
//  MainViewController.m
//  Pup Zzz's
//
//  Created by RichMan on 12/16/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "MainViewController.h"
#import "MainCell.h"
#import "TimeLoopUiView.h"
#import "RecordSoundUiView.h"
#import "TipsViewController.h"
#import "RecordedHistoryUiView.h"

#import <AVFoundation/AVFoundation.h>
@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    NSMutableArray* selecttimeArray;
    NSUInteger currenteditTag, switchTag;
    NSString *recSoundFilePath;
    NSString * stringTime;
    NSURL *recordedUrl;
    NSArray *recodedSoundArr;
    NSString *basePath;
    BOOL timerIsPaused;
    BOOL recordFlag;
    TipsViewController *tipsVC;
    
   
}
@property (weak, nonatomic) IBOutlet UILabel *recSoundTitleLabel;
@property (weak, nonatomic) IBOutlet UISlider *recVolumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *recButton;
@property (weak, nonatomic) IBOutlet UIButton *recHistoryButton;
@property (weak, nonatomic) IBOutlet UISwitch *recSwitch;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UIView *tableBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *recImageView;
@property (nonatomic, strong) TimeLoopUiView* timeLoopView;
@property (nonatomic, strong) RecordSoundUiView* recView;
@property (nonatomic, strong)RecordedHistoryUiView *recHistoryView;
@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, strong)AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, assign) NSInteger audioLoopTime;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}


-(void)initView{
    [commonUtils setRoundedRectBorderView:_recImageView withBorderWidth:1.0f withBorderColor:[UIColor clearColor] withBorderRadius:5.0f];
    [commonUtils setRoundedRectBorderView:_recBackView withBorderWidth:1.0f withBorderColor:appController.viewBorderColor withBorderRadius:5.0f];
    [commonUtils setRoundedRectBorderButton:_recButton withBorderWidth:1.0f withBorderColor:appController.viewBorderColor withBorderRadius:20.f];
    [commonUtils setRoundedRectBorderButton:_recHistoryButton withBorderWidth:1.0f withBorderColor:appController.viewBorderColor withBorderRadius:20.f];
    
}
-(void)initData{
    recSoundFilePath = [[NSBundle mainBundle] pathForResource:@"Demo" ofType:@"mp3"];
    [self setUrl:recSoundFilePath];
    stringTime = @"10:00";
    [self setTime:stringTime];
    recodedSoundArr = [[NSArray alloc] init];
    basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    timerIsPaused = NO;
    recordFlag = NO;
    //save good girl
    //NSString* googGirlPath = [[NSBundle mainBundle] pathForResource:@"sound6" ofType:@"m4a"];
    recordedUrl = [NSURL fileURLWithPath:recSoundFilePath];
     NSLog(@"filePath==>%@",recordedUrl );
    NSData *audioData = [NSData dataWithContentsOfURL:recordedUrl];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.m4a", basePath ,@"Good girl"];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    NSLog(@"filePath==>%@",filePath );
    [audioData writeToFile:filePath atomically:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainCell* cell = (MainCell*)[tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    [cell setTag:indexPath.row+10000];
    cell.cellRow = indexPath.row;
    NSString* imageName = [[appController.dataArr objectAtIndex:indexPath.row] valueForKey:@"image"];
    [cell.cellimageView setImage:[UIImage imageNamed:imageName]];
    if([[[appController.dataArr objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"on"]){
        cell.cellSwitch.on = YES;
    }else{
        cell.cellSwitch.on = NO;
    }
    
        NSString* soundName = [[appController.dataArr objectAtIndex:indexPath.row] valueForKey:@"sound"];
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"mp3"];
        [cell setUrl:soundFilePath];

   
    
    NSString* remainTimeStr = [[appController.dataArr objectAtIndex:indexPath.row] valueForKey:@"time"];
    [cell setTime:remainTimeStr];
    cell.cellTitle.text = [[appController.dataArr objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.remaintimelabel.text = [[appController.dataArr objectAtIndex:indexPath.row] valueForKey:@"time"];
    if(recordFlag){
        cell.timerIsPaused = YES;
    }else {
        cell.timerIsPaused = NO;
    }
   
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = self.tableBackgroundView.frame;
    
    return frame.size.height/5;
   
}
- (IBAction)onClickRecSwitch:(id)sender {
    if ([_recSwitch isOn]) {
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
        if([stringTime isEqualToString:@"No Limit"]) return;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(audioPlayingTime)
                                                userInfo:nil
                                                 repeats:YES];
        
    } else {
        [_audioPlayer stop];
        [_timer invalidate];
         _remainTimeLabel.text = stringTime;
        [self setTime:stringTime];
    }

}

-(void)audioPlayingTime{
    if(_audioLoopTime == 0){
        [_audioPlayer stop];
        [_timer invalidate];
        _remainTimeLabel.text = stringTime;
        [_recSwitch setOn:NO];
        [self setTime:stringTime];
    }else{
        
        if([stringTime isEqualToString:@"No Limit"]) return;
        if(!timerIsPaused){
            -- _audioLoopTime;
            NSInteger mins = _audioLoopTime/60;
            NSInteger seconds = _audioLoopTime - mins*60;
            NSString *remainTime = [NSString stringWithFormat:@"%02i:%02i", mins, seconds];
            _remainTimeLabel.text = remainTime;
        }
        

      
        
    }
    
}
- (IBAction)setRecVolume:(id)sender {
    [_audioPlayer setVolume:_recVolumeSlider.value];
}
- (IBAction)onClickTimeLoopBtn:(id)sender {
    _timeLoopView = [TimeLoopUiView customView];
    [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeNone];
    if([stringTime isEqualToString:@"10:00"]){
        [_timeLoopView.optionImageView10 setHighlighted:YES];
        [_timeLoopView.optionImageView30 setHighlighted:NO];
        [_timeLoopView.optionImageView45 setHighlighted:NO];
        [_timeLoopView.optionImageViewNoLimit setHighlighted:NO];
        
    }else if([stringTime isEqualToString:@"30:00"]){
        [_timeLoopView.optionImageView10 setHighlighted:NO];
        [_timeLoopView.optionImageView30 setHighlighted:YES];
        [_timeLoopView.optionImageView45 setHighlighted:NO];
        [_timeLoopView.optionImageViewNoLimit setHighlighted:NO];
        
    }else if([stringTime isEqualToString:@"45:00"]){
        [_timeLoopView.optionImageView10 setHighlighted:NO];
        [_timeLoopView.optionImageView30 setHighlighted:NO];
        [_timeLoopView.optionImageView45 setHighlighted:YES];
        [_timeLoopView.optionImageViewNoLimit setHighlighted:NO];
        
    }else {
        [_timeLoopView.optionImageView10 setHighlighted:NO];
        [_timeLoopView.optionImageView30 setHighlighted:NO];
        [_timeLoopView.optionImageView45 setHighlighted:NO];
        [_timeLoopView.optionImageViewNoLimit setHighlighted:YES];
        
    }
    [_timeLoopView.button10 addTarget:self action:@selector(selectTimeLoop10) forControlEvents:UIControlEventTouchUpInside];
    [_timeLoopView.button30 addTarget:self action:@selector(selectTimeLoop30) forControlEvents:UIControlEventTouchUpInside];
    [_timeLoopView.button45 addTarget:self action:@selector(selectTimeLoop45) forControlEvents:UIControlEventTouchUpInside];
    [_timeLoopView.buttonUnlimit addTarget:self action:@selector(selectTimeLoopNoLimit) forControlEvents:UIControlEventTouchUpInside];
    [[KGModal sharedInstance] showWithContentView:_timeLoopView andAnimated:YES];
}
-(void) selectTimeLoop10{
    [_timeLoopView.optionImageView10 setHighlighted:YES];
    [_timeLoopView.optionImageView30 setHighlighted:NO];
    [_timeLoopView.optionImageView45 setHighlighted:NO];
    [_timeLoopView.optionImageViewNoLimit setHighlighted:NO];
    [self setTime:@"10:00"];
    _remainTimeLabel.text = @"10:00";
    
}
-(void) selectTimeLoop30{
    [_timeLoopView.optionImageView10 setHighlighted:NO];
    [_timeLoopView.optionImageView30 setHighlighted:YES];
    [_timeLoopView.optionImageView45 setHighlighted:NO];
    [_timeLoopView.optionImageViewNoLimit setHighlighted:NO];
    [self setTime:@"30:00"];
    _remainTimeLabel.text = @"30:00";
}
-(void) selectTimeLoop45{
    [_timeLoopView.optionImageView10 setHighlighted:NO];
    [_timeLoopView.optionImageView30 setHighlighted:NO];
    [_timeLoopView.optionImageView45 setHighlighted:YES];
    [_timeLoopView.optionImageViewNoLimit setHighlighted:NO];
    [self setTime:@"45:00"];
    _remainTimeLabel.text = @"45:00";
    
}
-(void) selectTimeLoopNoLimit{
    [_timeLoopView.optionImageView10 setHighlighted:NO];
    [_timeLoopView.optionImageView30 setHighlighted:NO];
    [_timeLoopView.optionImageView45 setHighlighted:NO];
    [_timeLoopView.optionImageViewNoLimit setHighlighted:YES];
    [self setTime:@"No Limit"];
    _remainTimeLabel.text = @"No Limit";
}


-(void)setUrl:(NSString*)path{
    
    NSURL *soundUrl = [NSURL URLWithString:path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [_audioPlayer setNumberOfLoops:-1];
    [_audioPlayer setVolume:0.5f];
    
    
}

-(void)setTime:(NSString*)time{
    stringTime = time;
    if([stringTime isEqualToString:@"No Limit"]){
        _audioLoopTime = 1000000000;
       
    }else{
        NSString* minStr = [stringTime substringToIndex:2];
        NSString* secStr = [stringTime substringFromIndex:3];
        //NSLog(@"hour===>%@ , %@",minStr,secStr);
        _audioLoopTime = 60 * [minStr integerValue] + [secStr integerValue];
        
    }
    [[KGModal sharedInstance] hide];
   
}

- (IBAction)showRecordView:(id)sender {
    _recView = [RecordSoundUiView customView];
    [_recView.startButton addTarget:self action:@selector(recordSound) forControlEvents:UIControlEventTouchUpInside];
    [_recView.saveButton addTarget:self action:@selector(saveSound) forControlEvents:UIControlEventTouchUpInside];
    [_recView.cancelButton addTarget:self action:@selector(cancelSound) forControlEvents:UIControlEventTouchUpInside];
    _recView.titleTextField.delegate = self;
//    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [NSString stringWithFormat:@"%@%@", basePath, [self dateString]];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    recordedUrl = [NSURL fileURLWithPath:filePath];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    _recorder = [[AVAudioRecorder alloc] initWithURL:recordedUrl settings:recordSetting error:nil];
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];

    [[KGModal sharedInstance] setTapOutsideToDismiss:NO];
    [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeNone];
    
    [[KGModal sharedInstance] showWithContentView:_recView andAnimated:YES];
    recordFlag = YES;
    [self recordAudioProcess];
    [self cellAudioProcess];

}

-(void) recordSound {
   
   if (!_recorder.recording) {
   AVAudioSession *session = [AVAudioSession sharedInstance];
   [session setActive:YES error:nil];
    
    // Start recording
    [_recorder record];
    [_recView.startButton setTitle:@"STOP" forState:UIControlStateNormal];
    
    } else {
        
        // Pause recording
        [_recorder stop];
        [_recView.startButton setHidden:YES];
        [_recView.saveButton setHidden:NO];
        [_recView.titleBackView setHidden:NO];
        [_recView.titleTextField becomeFirstResponder];
//        NSLog(@"filePathUrl==>%@",recordedUrl);
//        NSLog(@"recorderUrl==>%@",_recorder.url);
        
    }
 
   
   

}
-(void) cellAudioProcess {
    for (int i = 0; i < 5; i++){
       // UIView* view = [[UIView alloc] init];
        //MainCell *cell = (MainCell *)[view viewWithTag:i];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        MainCell *cell = [_mainTable cellForRowAtIndexPath:indexPath];
        cell.recordFlag = recordFlag;
        [cell recordAudioProcess];
        
    }
}

-(void) recordAudioProcess {
    
        if([_recSwitch isOn]){
            if(recordFlag){
                [_audioPlayer pause];
                timerIsPaused = YES;
            }else{
                [_audioPlayer play];
                timerIsPaused = NO;
            }
            
        }
    
}
-(void) saveSound {
    recordFlag = NO;
    [self recordAudioProcess];
    [self cellAudioProcess];
    if([_recView.titleTextField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Attention"
                                                        message: @"Please enter file name!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else{
        NSData *audioData = [NSData dataWithContentsOfURL:recordedUrl];
        //NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.m4a", basePath, _recView.titleTextField.text];
        [audioData writeToFile:filePath atomically:YES];
        if([_recSwitch isOn]){
            [_audioPlayer stop];
            [_recSwitch setOn:NO];
            [_timer invalidate];
            _remainTimeLabel.text = stringTime;
            [self setTime:stringTime];
        }
        [self setUrl:filePath];
        //remove demo
        NSString* demoPath = [NSString stringWithFormat:@"%@/%@.m4a", basePath, @"Demo_123UX"];
        if([[NSFileManager defaultManager] fileExistsAtPath:demoPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:demoPath error:nil];
        }

        _recSoundTitleLabel.text = _recView.titleTextField.text;
        [[KGModal sharedInstance] hide];
    }
    
}
- (NSArray *) getAllFiles {
    //NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [NSString stringWithFormat:@"%@", basePath];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:NULL];
    for (int count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}

-(void) cancelSound {
    [_recorder stop];
//    [self getAllFiles];
    
    recordFlag = NO;
    [self recordAudioProcess];
    [self cellAudioProcess];
    [[KGModal sharedInstance] hide];
}

- (NSString *) dateString
{
    // return a formatted string for a file name
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"ddMMMYY_hhmmssa";
    NSString *audioName = @"Demo_123UX.m4a";
    return [NSString stringWithFormat:@"/%@",audioName];
}
- (IBAction)showRecordedFiles:(id)sender {
    recodedSoundArr = [self getAllFiles];
    appController.recordArr = recodedSoundArr;
    NSLog(@"recordedFiles===>%@",recodedSoundArr);
    
    _recHistoryView = [RecordedHistoryUiView customView];
    _recHistoryView.recordedHistoryList = recodedSoundArr;
    [_recHistoryView.closeButton addTarget:self action:@selector(closeHistoryDiallog) forControlEvents:UIControlEventTouchUpInside];

    [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeNone];
    [[KGModal sharedInstance] setTapOutsideToDismiss:NO];
    [[KGModal sharedInstance] showWithContentView:_recHistoryView andAnimated:YES];
    
}
-(void)closeHistoryDiallog {
    if (![appController.selectedRecFileName isEqualToString:@""]){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", basePath, appController.selectedRecFileName];
        if([_recSwitch isOn]){
            [_audioPlayer stop];
            [_recSwitch setOn:NO];
            [_timer invalidate];
            _remainTimeLabel.text = stringTime;
            [self setTime:stringTime];
        }
        if([appController.selectedRecFileName isEqualToString:@"Good girl.m4a"]){
             [self setUrl:recSoundFilePath];
        }else{
            [self setUrl:filePath];
        }
        
        _recSoundTitleLabel.text = [appController.selectedRecFileName substringToIndex:appController.selectedRecFileName.length-4];
    }
    
    [[KGModal sharedInstance] hide];
}
- (IBAction)onClickLogoButton:(id)sender {
    tipsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TipsViewController"];
    [self.navigationController pushViewController:tipsVC animated:YES];
}
#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return  YES;
}

@end
