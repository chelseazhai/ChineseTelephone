//
//  SipUtils.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ISipProtocol.h"

#import "PJSipImplementation.h"

#import "SipRegistrationBean.h"

#import "SipRegistrationStateChangedProtocol.h"

#import "SipCallMode.h"

@interface SipUtils : NSObject

// register sip account
+ (void)registerSipAccount:(SipRegistrationBean *)sipAccount stateChangedProtocolImpl:(id<SipRegistrationStateChangedProtocol>)stateChangedProtocolImpl;

// unregister sip account
+ (void)unregisterSipAccount:(id<SipRegistrationStateChangedProtocol>)stateChangedProtocolImpl;

// make sip voice call from view controller
+ (void)makeSipVoiceCall:(NSString *)callee phone:(NSString *)phone callMode:(SipCallMode)callMode fromViewController:(UIViewController *)sponsorViewController;

// destroy sip engine
+ (void)destroySipEngine;

@end
