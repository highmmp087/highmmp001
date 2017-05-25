//
//  RecordedHistoryUiView.h
//  PupZzz
//
//  Created by RichMan on 12/19/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordedHistoryUiView : UIView<UITableViewDataSource, UITableViewDelegate>{
    NSArray *cellViews;

}

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic, assign) NSArray *recordedHistoryList;
+(id)customView;
@end
