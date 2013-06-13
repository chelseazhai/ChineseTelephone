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

- (void)registerSipAccount:(SipRegistrationBean *)sipAccount stateChangedProtocolImpl:(id<SipRegistrationStateChangedProtocol>)sipRegistrationStateChangedProtocolImpl{
    NSLog(@"PJSipImplementation - registerSipAccount - sip account = %@", sipAccount);
    
    //
}

- (void)unregisterSipAccount:(id<SipRegistrationStateChangedProtocol>)sipRegistrationStateChangedProtocolImpl{
    NSLog(@"PJSipImplementation - unregisterSipAccount");
    
    //
}

- (BOOL)makeSipVoiceCall:(NSString *)calleeName phone:(NSString *)calleePhone stateChangedProtocolImpl:(id<SipInviteStateChangedProtocol>)stateChangedProtocolImpl{
    NSLog(@"PJSipImplementation - makeSipVoiceCall - callee name = %@, callee phone = %@", calleeName, calleePhone);
    
    //
    
    return YES;
}

- (BOOL)hangupSipVoiceCall{
    NSLog(@"PJSipImplementation - hangupSipVoiceCall");
    
    //
    
    return YES;
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

@end
