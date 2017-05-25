//
//  AppController.m
//  WebServiceSample
//
//  Created by RichMan on 10/18/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "AppController.h"


static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    self = [super init];
    if (self) {
        
        _dataArr = @[[NSMutableDictionary
                     dictionaryWithDictionary:@{@"image":@"img_sound1",@"title":@"Heartbeat", @"time":@"10:00", @"sound":@"sound1", @"status":@"off"}],
                    [NSMutableDictionary
                     dictionaryWithDictionary:@{@"image":@"img_sound2",@"title":@"Womb Heartbeat", @"time":@"10:00", @"sound":@"sound2", @"status":@"off"}],
                    [NSMutableDictionary
                     dictionaryWithDictionary:@{@"image":@"img_sound3",@"title":@"Moms Snore", @"time":@"10:00", @"sound":@"sound3", @"status":@"off"}],
                    [NSMutableDictionary
                     dictionaryWithDictionary:@{@"image":@"img_sound4",@"title":@"Creek Crickets", @"time":@"10:00", @"sound":@"sound4", @"status":@"off"}],
                    [NSMutableDictionary
                     dictionaryWithDictionary:@{@"image":@"img_sound5",@"title":@"Meddow Mello", @"time":@"10:00", @"sound":@"sound5", @"status":@"off"}]];
        _viewBorderColor = RGBA(185, 227, 255, 1);
        _selectedRecFileName =@"";
    
    }
    return self;
}

@end
