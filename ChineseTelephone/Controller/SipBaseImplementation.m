//
//  SipBaseImplementation.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SipBaseImplementation.h"

#import "OutgoingCallViewController.h"

#import "OutgoingCallView.h"

#import <CommonToolkit/CommonToolkit.h>

@interface SipBaseImplementation ()

// before make sip voice call
- (UIViewController *)beforeMakeSipVoiceCall:(NSString *)calleeName phone:(NSString *)calleePhone callMode:(SipCallMode)callMode sponsorViewController:(UIViewController *)sponsorViewController;

// request callback sip voice call
- (BOOL)requestCallbackSipVoiceCall:(NSString *)calleeName phone:(NSString *)calleePhone processorViewController:(UIViewController *)processorViewController;

// after make sip voice call
- (void)afterMakeSipVoiceCall:(BOOL)makeCallResult;

@end

@implementation SipBaseImplementation

- (void)makeSipVoiceCall:(NSString *)callee phone:(NSString *)phone callMode:(SipCallMode)callMode fromViewController:(UIViewController *)sponsorViewController{
    // before make sip voice call
    UIViewController *_outgoingCallViewController = [self beforeMakeSipVoiceCall:callee phone:phone callMode:callMode sponsorViewController:sponsorViewController];
    
    // check call mode and get make sip voice call result
    BOOL _makeSipVoiceCallResult = NO;
    switch (callMode) {
        case CALLBACK:
            // request callback sip voice call
            _makeSipVoiceCallResult = [self requestCallbackSipVoiceCall:callee phone:phone processorViewController:_outgoingCallViewController];
            break;
            
        case DIRECT_CALL:
        default:
            // make a sip voice call using sip implementation
            _makeSipVoiceCallResult = [_mSipImpl makeSipVoiceCall:callee phone:phone];
            break;
    }
    
    // after make sip voice call
    [self afterMakeSipVoiceCall:_makeSipVoiceCallResult];
}

- (BOOL)hangupSipVoiceCall:(long)callDuration{
    //
    
    return NO;
}

- (void)setSipVoiceCallUsingLoudspeaker{
    //
}

- (void)setSipVoiceCallUsingEarphone{
    //
}

// inner extension
- (UIViewController *)beforeMakeSipVoiceCall:(NSString *)calleeName phone:(NSString *)calleePhone callMode:(SipCallMode)callMode sponsorViewController:(UIViewController *)sponsorViewController{
    // create and init outgoing call view controller
    OutgoingCallViewController *_outgoingCallViewController = [[OutgoingCallViewController alloc] init];
    
    // set outgoing call sip call mode, phone and its ownnership
    [_outgoingCallViewController setCallMode:callMode phone:calleePhone ownnership:calleeName];
    
    // goto outgoing call view controller
    [sponsorViewController presentModalViewController:_outgoingCallViewController animated:YES];
    
    return _outgoingCallViewController;
}

- (BOOL)requestCallbackSipVoiceCall:(NSString *)calleeName phone:(NSString *)calleePhone processorViewController:(UIViewController *)processorViewController{
    // get callback sip voice call http request processor
    id _callbackSipVoiceCallHttpReqProcessor = [(OutgoingCallViewController *)processorViewController getCallbackSipVoiceCallRequestProcessor];
    
    // send callback sip voice call http request
    [HttpUtil postRequestWithUrl:@"www.baidu.com" andPostFormat:urlEncoded andParameter:nil andUserInfo:nil andRequestType:asynchronous andProcessor:_callbackSipVoiceCallHttpReqProcessor andFinishedRespSelector:((OutgoingCallView *)_callbackSipVoiceCallHttpReqProcessor).callbackSipVoiceCallHttpReqFinishedRespSelector andFailedRespSelector:((OutgoingCallView *)_callbackSipVoiceCallHttpReqProcessor).CallbackSipVoiceCallHttpReqFailedRespSelector];
    
    return YES;
}

- (void)afterMakeSipVoiceCall:(BOOL)makeCallResult{
    //
}

@end
