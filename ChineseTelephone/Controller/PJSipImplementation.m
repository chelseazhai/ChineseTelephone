//
//  PJSipImplementation.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "PJSipImplementation.h"

@implementation PJSipImplementation

- (id)init{
    self = [super init];
    if (self) {
        // init sip implementation using self
        _mSipImpl = self;
    }
    return self;
}

- (BOOL)makeSipVoiceCall:(NSString *)calleeName phone:(NSString *)calleePhone{
    //
    
    return YES;
}

- (BOOL)hangupSipVoiceCall{
    //
    
    return YES;
}

@end
