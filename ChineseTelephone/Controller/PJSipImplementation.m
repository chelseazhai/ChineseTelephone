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
    //
}

- (void)unregisterSipAccount:(id<SipRegistrationStateChangedProtocol>)sipRegistrationStateChangedProtocolImpl{
    //
}

- (BOOL)makeSipVoiceCall:(NSString *)calleeName phone:(NSString *)calleePhone stateChangedProtocolImpl:(id<SipInviteStateChangedProtocol>)stateChangedProtocolImpl{
    NSLog(@"sip invite state changed protocol implementation = %@", stateChangedProtocolImpl);
    
    //
    
    return YES;
}

- (BOOL)hangupSipVoiceCall{
    //
    
    return YES;
}

- (void)muteSipVoiceCall{
    //
}

- (void)unmuteSipVoiceCall{
    //
}

- (void)sendDTMF:(NSString *)dtmfCode{
    //
}

- (void)destroySipEngine{
    //
}

@end
