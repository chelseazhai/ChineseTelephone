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
        // init sip implementation protocol implementation using self
        _mSipImplementationProtocolImpl = self;
    }
    return self;
}

// ISipProtocol
- (void)registerSipAccount:(SipRegistrationBean *)sipAccount stateChangedProtocolImpl:(id<ISipRegistrationStateChangedProtocol>)sipRegistrationStateChangedProtocolImpl{
    NSLog(@"PJSipImplementation - registerSipAccount, sip account = %@ and sip registration state changed protocol implementation = %@", sipAccount, sipRegistrationStateChangedProtocolImpl);
    
    //
}

- (void)unregisterSipAccount:(id<ISipRegistrationStateChangedProtocol>)sipRegistrationStateChangedProtocolImpl{
    NSLog(@"PJSipImplementation - unregisterSipAccount, sip registration state changed protocol implementation = %@", sipRegistrationStateChangedProtocolImpl);
    
    //
}

- (void)muteSipVoiceCall{
    NSLog(@"PJSipImplementation - muteSipVoiceCall");
    
    //
}

- (void)unmuteSipVoiceCall{
    NSLog(@"PJSipImplementation - unmuteSipVoiceCall");
    
    //
}

- (void)sendDTMF:(NSString *)dtmfCode{
    NSLog(@"PJSipImplementation - sendDTMF - dtmf code = %@", dtmfCode);
    
    //
}

- (void)destroySipEngine{
    NSLog(@"PJSipImplementation - destroySipEngine");
    
    //
}

// ISipImplementationProtocol
- (BOOL)makeSipVoiceCall:(NSString *)calleeName phone:(NSString *)calleePhone stateChangedProtocolImpl:(id<ISipInviteStateChangedProtocol>)stateChangedProtocolImpl{
    NSLog(@"PJSipImplementation - makeSipVoiceCall - callee name = %@, callee phone = %@ and state changed protocol implementation = %@", calleeName, calleePhone, stateChangedProtocolImpl);
    
    //
    
    return YES;
}

- (BOOL)hangupSipVoiceCall{
    NSLog(@"PJSipImplementation - hangupSipVoiceCall");
    
    //
    
    return YES;
}

@end
