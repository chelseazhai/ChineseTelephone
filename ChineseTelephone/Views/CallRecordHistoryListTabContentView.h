//
//  CallRecordHistoryListTabContentView.h
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallRecordHistoryListTabContentView : UITableView <UITableViewDataSource, UITableViewDelegate> {
    // call records info array
    NSMutableArray *_mCallRecordsInfoArrayRef;
}

// get call records from sqlite database
- (void)getCallRecordsFromDB;

@end
