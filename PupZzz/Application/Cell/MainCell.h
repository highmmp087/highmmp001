//
//  MainCell.h
//  Pup Zzz's
//
//  Created by RichMan on 12/16/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TimeLoopUiView.h"
@interface MainCell : UITableViewCell{
    NSString* stringTime;
   }
@property (weak, nonatomic) IBOutlet UIImageView *cellimageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;
@property (weak, nonatomic) IBOutlet UIButton *btncriceltime;
@property (weak, nonatomic) IBOutlet UISlider *volumslide;
@property (weak, nonatomic) IBOutlet UILabel *remaintimelabel;
@property (weak, nonatomic) IBOutlet UIView *mainCellBackview;

@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSString* audioPath;
@property (nonatomic, strong) TimeLoopUiView* timeLoopView;
@property (nonatomic, assign) NSInteger audioLoopTime;
@property (nonatomic, assign) NSInteger cellRow;
@property (nonatomic, assign) BOOL timerIsPaused, recordFlag;



-(void)setUrl:(NSString*)path;
-(void)setTime:(NSString*)time;
-(void)recordAudioProcess;
@end
