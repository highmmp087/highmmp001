//
//  TimeLoopUiView.h
//  PupZzz
//
//  Created by RichMan on 12/18/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLoopUiView : UIView
@property (weak, nonatomic) IBOutlet UIButton *button10;
@property (weak, nonatomic) IBOutlet UIButton *button30;
@property (weak, nonatomic) IBOutlet UIButton *button45;
@property (weak, nonatomic) IBOutlet UIButton *buttonUnlimit;
@property (weak, nonatomic) IBOutlet UIView *backView10;
@property (weak, nonatomic) IBOutlet UIView *backView45;
@property (weak, nonatomic) IBOutlet UIView *backViewNoLimit;
@property (weak, nonatomic) IBOutlet UIView *backView30;
@property (weak, nonatomic) IBOutlet UIImageView *optionImageView10;
@property (weak, nonatomic) IBOutlet UIImageView *optionImageView30;
@property (weak, nonatomic) IBOutlet UIImageView *optionImageView45;
@property (weak, nonatomic) IBOutlet UIImageView *optionImageViewNoLimit;

+(id)customView;
@end
