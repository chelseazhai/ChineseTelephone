//
//  CallRecordHistoryListTableViewCell.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-19.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CallRecordBean.h"

@interface CallRecordHistoryListTableViewCell : UITableViewCell {
    // call record call type
    CallRecordCallType _mCallType;
    // call record callee or caller name label text
    NSString *_mCallName;
    // call record callee or caller phone label text
    NSString *_mCallPhone;
    // call record call created date label text
    NSDate *_mCallCreatedDate;
    
    // call record call type imageView
    UIImageView *_mCallTypeImgView;
    // call record callee or caller name label
    UILabel *_mCallNameLabel;
    // call record callee or caller phone label
    UILabel *_mCallPhoneLabel;
    // call record call created date label
    UILabel *_mCallCreatedDateLabel;
}

@property (nonatomic, assign) CallRecordCallType callType;
@property (nonatomic, retain) NSString *callName;
@property (nonatomic, retain) NSString *callPhone;
@property (nonatomic, retain) NSDate *callCreatedDate;

// get the height of the call record list tableViewCell
+ (CGFloat)cellHeight;

@end
