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
- (void)afterMakeSipVoiceCall:(BOOL)makeCallResult stateChangedProtocolImpl:(id<ISipInviteStateChangedProtocol>)stateChangedProtocolImpl;

@end

@implementation SipBaseImplementation

- (void)updateSipVoiceCallDuration:(long)duration{
    // open Chinese telephone database and checked it
    FMDatabase *_ChineseTelehoneDatabase = [FMDatabase databaseWithPath:[APP_DOCUMENTSPATH stringByAppendingPathComponent:CHINESETELEPHONE_DATABASENAME]];
    if ([_ChineseTelehoneDatabase open]) {
        // update call record call duration which in call records table
        if ([_ChineseTelehoneDatabase executeUpdate:[NSString stringWithFormat:UPDATECALLRECORDDURATIONSTATEMENT, CALLRECORDS_TABLENAME, CALLRECORDSTABLE_DUDATION_FIELDNAME, CALLRECORDSTABLE_ROWID_FIELDNAME], [NSNumber numberWithLong:duration], [NSNumber numberWithLongLong:_mSipVoiceCallLogId]]) {
        }
        else {
            NSLog(@"update call record duration failed, call log id = %lld", _mSipVoiceCallLogId);
        }
    }
    else {
        NSLog(@"open Chinese telephone database failed for update call record duration");
    }
    
    // close Chinese telephone database
    [_ChineseTelehoneDatabase close];
}

// ISipProtocol
- (void)makeSipVoiceCall:(NSString *)callee phone:(NSString *)phone callMode:(SipCallMode)callMode fromViewController:(UIViewController *)sponsorViewController{
    // before make sip voice call
    UIViewController *_outgoingCallViewController = [self beforeMakeSipVoiceCall:callee phone:phone callMode:callMode sponsorViewController:sponsorViewController];
    
    // define sip invite state changed protocol implementation
    id<ISipInviteStateChangedProtocol> _sipInviteStateChangedImplementation;
    
    // check call mode and get make sip voice call result
    BOOL _makeSipVoiceCallResult = NO;
    switch (callMode) {
        case CALLBACK:
            // request callback sip voice call
            _makeSipVoiceCallResult = [self requestCallbackSipVoiceCall:callee phone:phone processorViewController:_outgoingCallViewController];
            break;
            
        case DIRECT_CALL:
        default:
            // set outgoing call view controller sip implementation 
            [((OutgoingCallViewController *)_outgoingCallViewController) setSipImplementation:self];
            
            // make a sip voice call using sip implementation
            _makeSipVoiceCallResult = [_mSipImplementationProtocolImpl makeSipVoiceCall:callee phone:phone stateChangedProtocolImpl:_sipInviteStateChangedImplementation = [((OutgoingCallViewController *)_outgoingCallViewController) getSipInviteStateChangedImplementation]];
            break;
    }
    
    // after make sip voice call
    [self afterMakeSipVoiceCall:_makeSipVoiceCallResult stateChangedProtocolImpl:_sipInviteStateChangedImplementation];
}

- (BOOL)hangupSipVoiceCall:(long)callDuration{
    // after hangup current sip voice call, update current sip voice call
    // call record duration
    [self updateSipVoiceCallDuration:callDuration];
    
    // hangup current sip voice call using sip implementation
    return [_mSipImplementationProtocolImpl hangupSipVoiceCall];
}

- (void)setSipVoiceCallUsingLoudspeaker{
    NSLog(@"SipBaseImplementation - setSipVoiceCallUsingLoudspeaker");
    
    //
}

- (void)setSipVoiceCallUsingEarphone{
    NSLog(@"SipBaseImplementation - setSipVoiceCallUsingEarphone");
    
    //
}

// inner extension
- (UIViewController *)beforeMakeSipVoiceCall:(NSString *)calleeName phone:(NSString *)calleePhone callMode:(SipCallMode)callMode sponsorViewController:(UIViewController *)sponsorViewController{
    // insert sip voice call log
    // open Chinese telephone database and checked it
    FMDatabase *_ChineseTelehoneDatabase = [FMDatabase databaseWithPath:[APP_DOCUMENTSPATH stringByAppendingPathComponent:CHINESETELEPHONE_DATABASENAME]];
    if ([_ChineseTelehoneDatabase open]) {
        // insert one call record record to call records table
        if ([_ChineseTelehoneDatabase executeUpdate:[NSString stringWithFormat:INSERTCALLRECORD2CALLRECORDSTABLESTATEMENT, CALLRECORDS_TABLENAME, CALLRECORDSTABLE_NAME_FIELDNAME, CALLRECORDSTABLE_PHONE_FIELDNAME, CALLRECORDSTABLE_DATE_FIELDNAME, CALLRECORDSTABLE_DUDATION_FIELDNAME, CALLRECORDSTABLE_FLAGS_FIELDNAME], calleeName, calleePhone, [NSDate date], [NSNumber numberWithInt:0], [NSNumber numberWithInt:CALLBACK == callMode ? CALLBACKCALL_CALLRECORDSFLAG : OUTGOINGCALL_CALLRECORDSFLAG]]) {
            
            // save current insert sip voice call log id
            _mSipVoiceCallLogId = _ChineseTelehoneDatabase.lastInsertRowId;
        }
        else {
            NSLog(@"insert new call record failed");
        }
    }
    else {
        NSLog(@"open Chinese telephone database failed for insert new call record");
    }
    
    // close Chinese telephone database
    [_ChineseTelehoneDatabase close];
    
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
    [HttpUtils postRequestWithUrl:@"www.baidu.com" andPostFormat:urlEncoded andParameter:nil andUserInfo:nil andRequestType:asynchronous andProcessor:_callbackSipVoiceCallHttpReqProcessor andFinishedRespSelector:((OutgoingCallView *)_callbackSipVoiceCallHttpReqProcessor).callbackSipVoiceCallHttpReqFinishedRespSelector andFailedRespSelector:((OutgoingCallView *)_callbackSipVoiceCallHttpReqProcessor).callbackSipVoiceCallHttpReqFailedRespSelector];
    
    return YES;
}

- (void)afterMakeSipVoiceCall:(BOOL)makeCallResult stateChangedProtocolImpl:(id<ISipInviteStateChangedProtocol>)stateChangedProtocolImpl{
    // check make call result and update call failed call record with call log id
    if (!makeCallResult) {
        // check sip invite state changed protocol implementation
        if (nil != stateChangedProtocolImpl) {
            // sip voice call failed
            [stateChangedProtocolImpl onCallFailed];
        }
    }
}

@end
