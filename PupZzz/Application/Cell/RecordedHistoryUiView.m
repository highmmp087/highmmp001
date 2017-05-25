//
//  RecordedHistoryUiView.m
//  PupZzz
//
//  Created by RichMan on 12/19/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "RecordedHistoryUiView.h"
#import "RecordedHistoryTableViewCell.h"

@implementation RecordedHistoryUiView
+(id)customView{
    RecordedHistoryUiView* recView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                owner:self
                                                              options:nil] objectAtIndex:0];
    //barcodeView.barcodeImageView = [[UIImageView alloc]init];
    [commonUtils setRoundedRectView:recView withCornerRadius:5.0f];
    
    return recView;
}



- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recordedHistoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil];
    RecordedHistoryTableViewCell *cell = nibArray.firstObject;
    cell.fileNameLabel.text = [_recordedHistoryList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    appController.selectedRecFileName = [appController.recordArr objectAtIndex:indexPath.row];
}

@end
