//
//  TimeLoopUiView.m
//  PupZzz
//
//  Created by RichMan on 12/18/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "TimeLoopUiView.h"

@implementation TimeLoopUiView

+(id)customView{
    TimeLoopUiView* timeView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                owner:self
                                                              options:nil] objectAtIndex:0];
    //barcodeView.barcodeImageView = [[UIImageView alloc]init];
    [commonUtils setRoundedRectView:timeView withCornerRadius:timeView.frame.size.height / 20];
    [commonUtils setRoundedRectBorderView:timeView.backView10 withBorderWidth:1.0f withBorderColor:appController.viewBorderColor withBorderRadius:20.f];
    [commonUtils setRoundedRectBorderView:timeView.backView30 withBorderWidth:1.0f withBorderColor:appController.viewBorderColor withBorderRadius:20.f];
    [commonUtils setRoundedRectBorderView:timeView.backView45 withBorderWidth:1.0f withBorderColor:appController.viewBorderColor withBorderRadius:20.f];
    [commonUtils setRoundedRectBorderView:timeView.backViewNoLimit withBorderWidth:1.0f withBorderColor:appController.viewBorderColor withBorderRadius:20.f];
    return timeView;
}


@end
