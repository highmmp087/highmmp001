//
//  MainCell.m
//  Pup Zzz's
//
//  Created by RichMan on 12/16/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "MainCell.h"
#import "TimeLoopUiView.h"

@implementation MainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([_cellSwitch isOn]) {
        //NSLog(@"its on!");
        [[appController.dataArr objectAtIndex:_cellRow] setObject:@"on" forKey:@"status"];
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(audioPlayingTime)
                                                userInfo:nil
                                                 repeats:YES];
        
    } else {
        // NSLog(@"its off!");
        [[appController.dataArr objectAtIndex:_cellRow] setObject:@"off" forKey:@"status"];
        [_audioPlayer stop];
        [_timer invalidate];
        
    }
    stringTime = _remaintimelabel.text;
    
    [commonUtils setRoundedRectBorderView:_mainCellBackview withBorderWidth:1.0f withBorderColor:appController.viewBorderColor  withBorderRadius:5.0f];
    //[commonUtils cropCircleImage:_cellimageView];
    //[commonUtils setCircleBorderImage:_cellimageView withBorderWidth:1.0f withBorderColor:appController.viewBorderColor];
    [commonUtils setRoundedRectBorderView:_cellimageView withBorderWidth:1.0f withBorderColor:[UIColor clearColor] withBorderRadius:5.0f];
}

-(void)setUrl:(NSString*)path{
    _audioPath = path;
    NSURL *soundUrl = [NSURL URLWithString:_audioPath];
//    NSLog(@"url===>%@",soundUrl);
//    NSLog(@"path ====>%@", path);
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [_audioPlayer setNumberOfLoops:-1];
    

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
- (IBAction)onClickAudioSwitch:(id)sender {
        UISwitch* audioSwitch =(UISwitch*)sender;
    if ([audioSwitch isOn]) {
        //NSLog(@"its on!");
        [[appController.dataArr objectAtIndex:_cellRow] setObject:@"on" forKey:@"status"];
        [_audioPlayer prepareToPlay];
        [_audioPlayer setVolume:0.5f];
        [_audioPlayer play];
        if([stringTime isEqualToString:@"No Limit"]) return;
         _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(audioPlayingTime)
                                                    userInfo:nil
                                                     repeats:YES];
        
    } else {
        // NSLog(@"its off!");
        [[appController.dataArr objectAtIndex:_cellRow] setObject:@"off" forKey:@"status"];
        [_audioPlayer stop];
        [_timer invalidate];
        //[[appController.dataArr objectAtIndex:_cellRow] setObject:@"10:00" forKey:@"time"];
        _remaintimelabel.text = stringTime;
        [self setTime:stringTime];
    }

}

-(void)audioPlayingTime{
    if(_audioLoopTime == 0){
        [_audioPlayer stop];
        [_timer invalidate];
        [[appController.dataArr objectAtIndex:_cellRow] setObject:@"10:00" forKey:@"time"];
         _remaintimelabel.text = stringTime;
        [[appController.dataArr objectAtIndex:_cellRow] setObject:@"off" forKey:@"status"];
        [_cellSwitch setOn:NO];
         [self setTime:stringTime];
    }else{
        
        if(_timerIsPaused){
            
        }else {
           
            if([stringTime isEqualToString:@"No Limit"]) return;
           
            -- _audioLoopTime;
            NSInteger mins = _audioLoopTime/60;
            NSInteger seconds = _audioLoopTime - mins*60;
            NSString *remainTime = [NSString stringWithFormat:@"%02li:%02li", (long)mins, (long)seconds];
            //NSLog(@"remainTime==>%@",remainTime);
            //[[appController.dataArr objectAtIndex:_cellRow] setObject:remainTime forKey:@"time"];
            _remaintimelabel.text = remainTime;
            

        }
        
        
       
        
        
    }
    
}
-(void) recordAudioProcess {
    if([_cellSwitch isOn]){
        if(_recordFlag){
            [_audioPlayer pause];
            _timerIsPaused = YES;
        }else {
            [_audioPlayer play];
            _timerIsPaused = NO;
        }
        
    }
    
    
}

- (IBAction)onClickTimeMenu:(id)sender {
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
- (IBAction)setVolume:(id)sender {
    [_audioPlayer setVolume:_volumslide.value];
}

-(void) selectTimeLoop10{
    [_timeLoopView.optionImageView10 setHighlighted:YES];
    [_timeLoopView.optionImageView30 setHighlighted:NO];
    [_timeLoopView.optionImageView45 setHighlighted:NO];
    [_timeLoopView.optionImageViewNoLimit setHighlighted:NO];
    [self setTime:@"10:00"];
    _remaintimelabel.text = @"10:00";
    
}
-(void) selectTimeLoop30{
    [_timeLoopView.optionImageView10 setHighlighted:NO];
    [_timeLoopView.optionImageView30 setHighlighted:YES];
    [_timeLoopView.optionImageView45 setHighlighted:NO];
    [_timeLoopView.optionImageViewNoLimit setHighlighted:NO];
    [self setTime:@"30:00"];
    _remaintimelabel.text = @"30:00";
}
-(void) selectTimeLoop45{
    [_timeLoopView.optionImageView10 setHighlighted:NO];
    [_timeLoopView.optionImageView30 setHighlighted:NO];
    [_timeLoopView.optionImageView45 setHighlighted:YES];
    [_timeLoopView.optionImageViewNoLimit setHighlighted:NO];
    [self setTime:@"45:00"];
    _remaintimelabel.text = @"45:00";

}
-(void) selectTimeLoopNoLimit{
    [_timeLoopView.optionImageView10 setHighlighted:NO];
    [_timeLoopView.optionImageView30 setHighlighted:NO];
    [_timeLoopView.optionImageView45 setHighlighted:NO];
    [_timeLoopView.optionImageViewNoLimit setHighlighted:YES];
    [self setTime:@"No Limit"];
    _remaintimelabel.text = @"No Limit";
}


@end
