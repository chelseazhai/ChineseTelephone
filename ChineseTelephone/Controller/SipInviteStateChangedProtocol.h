//
//  SipInviteStateChangedProtocol.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SipInviteStateChangedProtocol <NSObject>

@required

// invite initializing
- (void)onCallInitializing;

// invite early media
- (void)onCallEarlyMedia;

// invite remote ringing
- (void)onCallRemoteRinging;

// invite speaking
- (void)onCallSpeaking;

// invite failed
- (void)onCallFailed;

// invite terminating
- (void)onCallTerminating;

// invite terminated
- (void)onCallTerminated;

@end
