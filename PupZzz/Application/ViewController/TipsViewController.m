//
//  TipsViewController.m
//  PupZzz
//
//  Created by RichMan on 12/22/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "TipsViewController.h"

@interface TipsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation TipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

-(void) initView {
    [commonUtils setRoundedRectBorderView:_descriptionTextView withBorderWidth:1.0f withBorderColor:appController.viewBorderColor withBorderRadius:5.0f];
    [commonUtils cropCircleImage:_photoImageView];
}
- (IBAction)onClickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
