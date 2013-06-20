//
//  CallRecordDetailInfoView.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-19.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CallRecordBean.h"

@interface CallRecordDetailInfoView : UITableView <UITableViewDataSource, UITableViewDelegate> {
    // call record call name and phone
    NSString *_mCallName;
    NSString *_mCallPhone;
    
    // present subviews
    // call contact group view
    // subview call contact photo image view
    UIImageView *_mCallContactPhotoImageView;
    // subview call name label
    UILabel *_mCallNameLabel;
    
    // call status group view
    // subview call type name label
    UILabel *_mCallTypeNameLabel;
    // subview call created date day label
    UILabel *_mCallCreatedDateDayLabel;
    // subview call created date time label
    UILabel *_mCallCreatedDateTimeLabel;
    // subview call duration or result label
    UILabel *_mCallDuration6ResultLabel;
}

// set call record bean for showing
- (void)setCallRecord:(CallRecordBean *)callRecord;

@end
