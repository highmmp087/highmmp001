//
//  RecordSoundUiView.h
//  PupZzz
//
//  Created by RichMan on 12/19/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordSoundUiView : UIView
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIView *titleBackView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIView *containView;
+(id)customView;

@end
