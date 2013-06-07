//
//  SipUtils.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SipUtils.h"

// static singleton instance, sip protocol implementation object
static id<ISipProtocol> sipImplementation;

@implementation SipUtils

+ (id<ISipProtocol>)getSipImplementation{
    if (nil == sipImplementation) {
        @synchronized(self){
            if (nil == sipImplementation) {
                // use pjsip to implement voip
                sipImplementation = [[PJSipImplementation alloc] init];
            }
        }
    }
    
    return sipImplementation;
}

+ (void)registerSipAccount:(SipRegistrationBean *)sipAccount stateChangedProtocolImpl:(id<SipRegistrationStateChangedProtocol>)stateChangedProtocolImpl{
    [[self getSipImplementation] registerSipAccount:sipAccount stateChangedProtocolImpl:stateChangedProtocolImpl];
}

+ (void)unregisterSipAccount:(id<SipRegistrationStateChangedProtocol>)stateChangedProtocolImpl{
    [[self getSipImplementation] unregisterSipAccount:stateChangedProtocolImpl];
}

+(void)makeSipVoiceCall:(NSString *)callee phone:(NSString *)phone callMode:(SipCallMode)callMode{
    [[self getSipImplementation] makeSipVoiceCall:callee phone:phone callMode:callMode];
}

+(void)destroySipEngine{
    [[self getSipImplementation] destroySipEngine];
}

@end
