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

+ (NSString *)getCallTypeName:(CallRecordCallType)callType{
    NSString *_callTypeName;
    
    // check call type and generate call type name
    switch (callType) {
        case INCOMINGCALL:
        case MISSED_INCOMINGCALL:
            _callTypeName = NSLocalizedString(@"call record incoming call name", nil);
            break;
            
        case CALLBACKCALL:
        case OUTGOINGCALL:
        default:
            _callTypeName = NSLocalizedString(@"call record outgoing call name", nil);
            break;
    }
    
    return _callTypeName;
}

+ (UIImage *)getCallTypeImage:(CallRecordCallType)callType{
    NSString *_callTypeImageName;
    
    // check call type and generate call type image
    switch (callType) {
        case INCOMINGCALL:
            _callTypeImageName = @"img_incomingcall";
            break;
            
        case MISSED_INCOMINGCALL:
            _callTypeImageName = @"img_missedincomingcall";
            break;
            
        case OUTGOINGCALL:
        case CALLBACKCALL:
        default:
            _callTypeImageName = @"img_outgoingcall";
            break;
    }
    
    return [UIImage imageNamed:_callTypeImageName];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"CallRecordBean description: call record row id = %lld, name = %@, phone = %@, date = %@, duration = %ld and call type = %d", _rowId, _name, _phone, _date, _duration, _callType];
}

@end
