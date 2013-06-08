//
//  SipBaseImplementation.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ISipProtocol.h"

#import "SipInviteStateChangedProtocol.h"

// sip implementation protocol
@protocol SipImplementationProtocol <NSObject>

@required

// make a sip voice call
- (BOOL)makeSipVoiceCall:(NSString *)calleeName phone:(NSString *)calleePhone stateChangedProtocolImpl:(id<SipInviteStateChangedProtocol>)stateChangedProtocolImpl;

// hangup current sip voice call
- (BOOL)hangupSipVoiceCall;

@end




@interface SipBaseImplementation : NSObject <ISipProtocol> {
    // sip implementation protocol implementation
    id<SipImplementationProtocol> _mSipImplementationProtocolImpl;
}

@end
