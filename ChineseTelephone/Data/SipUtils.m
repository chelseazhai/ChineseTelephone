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

@interface SipUtils ()

// get sip implementation
+ (id<ISipProtocol>)getSipImplementation;

@end

@implementation SipUtils

+ (void)registerSipAccount:(SipRegistrationBean *)sipAccount stateChangedProtocolImpl:(id<ISipRegistrationStateChangedProtocol>)stateChangedProtocolImpl{
    [[self getSipImplementation] registerSipAccount:sipAccount stateChangedProtocolImpl:stateChangedProtocolImpl];
}

+ (void)unregisterSipAccount:(id<ISipRegistrationStateChangedProtocol>)stateChangedProtocolImpl{
    [[self getSipImplementation] unregisterSipAccount:stateChangedProtocolImpl];
}

+(void)makeSipVoiceCall:(NSString *)callee phone:(NSString *)phone callMode:(SipCallMode)callMode fromViewController:(UIViewController *)sponsorViewController{
    [[self getSipImplementation] makeSipVoiceCall:callee phone:phone callMode:callMode fromViewController:sponsorViewController];
}

+(void)destroySipEngine{
    [[self getSipImplementation] destroySipEngine];
}

// inner extension
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

@end
