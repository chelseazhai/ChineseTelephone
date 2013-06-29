//
//  SipBaseImplementation.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ISipProtocol.h"

#import "ISipInviteStateChangedProtocol.h"

#import <CommonToolkit/CommonToolkit.h>

// sip implementation protocol
@protocol ISipImplementationProtocol <NSObject>

@required

// make a sip voice call
- (BOOL)makeSipVoiceCall:(NSString *)calleeName phone:(NSString *)calleePhone stateChangedProtocolImpl:(id<ISipInviteStateChangedProtocol>)stateChangedProtocolImpl;

// hangup current sip voice call
- (BOOL)hangupSipVoiceCall;

@end




@interface SipBaseImplementation : NSObject <ISipProtocol> {
    // sip implementation protocol implementation
    id<ISipImplementationProtocol> _mSipImplementationProtocolImpl;
    
    // sip voice call log id
	sqlite_int64 _mSipVoiceCallLogId;
}

// update sip voice call call record duration
- (void)updateSipVoiceCallDuration:(long)duration;

@end
