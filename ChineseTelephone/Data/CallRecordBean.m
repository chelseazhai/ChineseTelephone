//
//  CallRecordBean.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-19.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "CallRecordBean.h"

@implementation CallRecordBean

@synthesize rowId = _rowId;
@synthesize name = _name;
@synthesize phone = _phone;
@synthesize date = _date;
@synthesize duration = _duration;
@synthesize callType = _callType;

- (NSString *)description{
    return [NSString stringWithFormat:@"CallRecordBean description: call record row id = %lld, name = %@, phone = %@, date = %@, duration = %ld and call type = %d", _rowId, _name, _phone, _date, _duration, _callType];
}

@end
