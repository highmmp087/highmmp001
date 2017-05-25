//
//  MainViewController.h
//  Pup Zzz's
//
//  Created by RichMan on 12/16/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *recBackView;

@end
