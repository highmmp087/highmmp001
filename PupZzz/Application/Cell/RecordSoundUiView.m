//
//  RecordSoundUiView.m
//  PupZzz
//
//  Created by RichMan on 12/19/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "RecordSoundUiView.h"

@implementation RecordSoundUiView
+(id)customView{
    RecordSoundUiView* recView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                              owner:self
                                                            options:nil] objectAtIndex:0];
    //barcodeView.barcodeImageView = [[UIImageView alloc]init];
    [commonUtils setRoundedRectView:recView.containView withCornerRadius:5.0f];
    
    return recView;
}


@end
