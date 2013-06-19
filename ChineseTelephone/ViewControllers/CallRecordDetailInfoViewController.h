//
//  CallRecordDetailInfoViewController.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-19.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CallRecordBean.h"

@interface CallRecordDetailInfoViewController : UIViewController

// set call record bean for showing in its view
- (CallRecordDetailInfoViewController *)setCallRecord:(CallRecordBean *)callRecord;

@end
