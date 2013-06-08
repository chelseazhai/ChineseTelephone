//
//  ISipProtocol.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SipRegistrationBean.h"

#import "SipRegistrationStateChangedProtocol.h"

#import "SipCallMode.h"

@protocol ISipProtocol <NSObject>

@required

// make sip voice call from view controller
- (void)makeSipVoiceCall:(NSString *)callee phone:(NSString *)phone callMode:(SipCallMode)callMode fromViewController:(UIViewController *)sponsorViewController;

// hangup current sip voice call
- (BOOL)hangupSipVoiceCall:(long)callDuration;

// set current sip voice call using loudspeaker
- (void)setSipVoiceCallUsingLoudspeaker;

// set current sip voice call using earphone
- (void)setSipVoiceCallUsingEarphone;

@optional

// register sip account
- (void)registerSipAccount:(SipRegistrationBean *)sipAccount stateChangedProtocolImpl:(id<SipRegistrationStateChangedProtocol>)sipRegistrationStateChangedProtocolImpl;

// unregister sip account
- (void)unregisterSipAccount:(id<SipRegistrationStateChangedProtocol>)sipRegistrationStateChangedProtocolImpl;

// mute current sip voice call
- (void)muteSipVoiceCall;

// unmute current sip voice call
- (void)unmuteSipVoiceCall;

// send dtmf
- (void)sendDTMF:(NSString *)dtmfCode;

// destroy sip engine
- (void)destroySipEngine;

@end
