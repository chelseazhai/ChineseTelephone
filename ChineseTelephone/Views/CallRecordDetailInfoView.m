//
//  CallRecordDetailInfoView.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-19.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "CallRecordDetailInfoView.h"

#import <CommonToolkit/CommonToolkit.h>

@implementation CallRecordDetailInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background color for test by ares
        self.backgroundColor = [UIColor whiteColor];
        
        // set title
        self.title = NSLocalizedString(@"call record detail info view navigation title", nil);
        
        //
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setCallRecord:(CallRecordBean *)callRecord{
    NSLog(@"call record detail info view, call record = %@", callRecord);
    
    //
}

@end
