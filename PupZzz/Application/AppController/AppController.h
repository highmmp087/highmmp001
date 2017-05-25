//
//  AppController.h
//  WebServiceSample
//
//  Created by RichMan on 10/18/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppController : NSObject{
  
}

+ (AppController *)sharedInstance;
// Utility Variables
@property (nonatomic, strong) UIColor *appMainColor;
@property (nonatomic, strong) UIColor *appBackgroundColor;
@property (nonatomic, strong) UIColor *appGradientTopColor, *appGradientBottomColor,*appWaiterBackgroudColor,*viewBorderColor,*appTextColor;

// Phone Contact Array
@property (nonatomic, strong) NSArray *dataArr, *recordArr;
@property (nonatomic, strong) NSString *selectedRecFileName;





@end
