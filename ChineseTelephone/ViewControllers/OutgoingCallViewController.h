//
//  OutgoingCallViewController.h
//  ChineseTelephone
//
//  Created by Ares on 13-5-31.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SipCallMode.h"

#import "SipInviteStateChangedProtocol.h"

#import "ISipProtocol.h"

@interface OutgoingCallViewController : UIViewController

// set outgoing call sip call mode, phone and its ownnership
- (void)setCallMode:(SipCallMode)callMode phone:(NSString *)phone ownnership:(NSString *)ownnership;

// set sip protocol implementation
- (void)setSipImplementation:(id<ISipProtocol>)sipImplementation;

// get sip invite state changed implementation
- (id<SipInviteStateChangedProtocol>)getSipInviteStateChangedImplementation;

// get callback sip voice call request processor
- (id)getCallbackSipVoiceCallRequestProcessor;

@end
