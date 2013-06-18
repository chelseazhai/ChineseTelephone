//
//  OutgoingCallGenerator.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-5.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "OutgoingCallGenerator.h"

#import <CommonToolkit/CommonToolkit.h>

#import "SipCallMode.h"

#import "SipCallDialModeSelector.h"

#import "SipUtils.h"

@interface OutgoingCallGenerator ()

// check contact for generating an new outgoing call
- (void)checkContact4GenNewOutgongCall:(OutgoingCallCallMode)callMode;

// new outgoing call call select action sheet button clicked event selector
- (void)newOutgoingCallCallModeSelectActionSheet:(UIActionSheet *)pActionSheet clickedButtonAtIndex:(NSInteger)pButtonIndex;

// contact phone numbers select action sheet button clicked event selector
- (void)contactPhonesSelectActionSheet:(UIActionSheet *)pActionSheet clickedButtonAtIndex:(NSInteger)pButtonIndex;

// generate an new outgoing call with phone and call mode
- (void)generateNewOutgoingCall:(NSString *)phone callMode:(OutgoingCallCallMode)callMode;

@end

@implementation OutgoingCallGenerator

- (id)initWithDependentView:(UIView *)dependentView andViewController:(UIViewController *)dependentViewController{
    self = [super init];
    if (self) {
        // save generate an new outgoing call operation dependent view and view controller
        _mGenNewOutgoingCallOperationDependentView = dependentView;
        _mGenNewOutgoingCallOperationDependentViewController = dependentViewController;
    }
    return self;
}

- (OutgoingCallGenerator *)setDialNumberLabel4ClearingText7PreviousDialPhone4Saving:(UILabel *)need2clearTextDialNumberLabel previousDialPhone:(NSMutableString *)storagePreviousDialPhone{
    // save need to clear text dial number label and storage previous dial phone
    _mNeed2ClearTextDialNumberLabel = need2clearTextDialNumberLabel;
    _mStoragePreviousDialPhone = storagePreviousDialPhone;
    
    return self;
}

- (void)generateNewOutgoingCall:(NSString *)contactName phones:(NSArray *)contactPhones{
    // get internet connection reachability
    Reachability *_reachabilityForInternetConnection = [Reachability reachabilityForInternetConnection];
    
    // check there is or not active network currently
    if ([_reachabilityForInternetConnection isReachable]) {
        // save contact info: display name and phone numbers
        _mContactName = contactName;
        _mContactPhones = contactPhones;
        
        // get and check sip call dial mode select pattern
        switch ([SipCallDialModeSelector getSipCallDialModeSelectPattern]) {
            case DIRECT_DIAL_DEFAULT:
                [self checkContact4GenNewOutgongCall:OUTGOINGCALL_DIRECT_CALL];
                break;
                
            case CALLBACK_DEFAULT:
                [self checkContact4GenNewOutgongCall:OUTGOINGCALL_CALLBACK];
                break;
                
            case AUTO_SELECT:
                // get and check current reachability network status
                switch ([_reachabilityForInternetConnection currentReachabilityStatus]) {
                    case ReachableViaWWAN:
                        [self checkContact4GenNewOutgongCall:OUTGOINGCALL_CALLBACK];
                        break;
                        
                    case ReachableViaWiFi:
                        [self checkContact4GenNewOutgongCall:OUTGOINGCALL_DIRECT_CALL];
                        break;
                        
                    case NotReachable:
                    default:
                        NSLog(@"generate an new outgoing call error, because here is no active network currently");
                        break;
                }
                break;
                
            case MANUAL_SELECT:
            default:
                {
                    // define outgoing call call mode select phones for selecting string
                    NSString *_phones4selectingString;
                    
                    // check contact phone array and generate phones for selecting string
                    if (1 == contactPhones.count) {
                        _phones4selectingString = [contactPhones objectAtIndex:0];
                        
                        // check and update contact name
                        if (nil == contactName) {
                            contactName = _phones4selectingString;
                        }
                    }
                    else {
                        _phones4selectingString = [NSString stringWithFormat:NSLocalizedString(@"outgoing call call mode phones for selecting string format", nil), contactPhones.count];
                    }
                    
                    // define new outgoing call call mode select action and show it
                    UIActionSheet *_newOutgoingCallCallModeSelectActionSheet = [[UIActionSheet alloc] initWithContent:[NSArray arrayWithObjects:[NSString stringWithFormat:NSLocalizedString(@"outgoing call direct call call mode string format", nil), _phones4selectingString], [NSString stringWithFormat:NSLocalizedString(@"outgoing call callback call mode string format", nil), _phones4selectingString], [NSString stringWithFormat:NSLocalizedString(@"outgoing call phone call call mode string format", nil), _phones4selectingString], nil] andTitleFormat:NSLocalizedString(@"outgoing call call mode select title string format", nil), contactName];
                    
                    // set actionSheet processor and button clicked event selector
                    _newOutgoingCallCallModeSelectActionSheet.processor = self;
                    _newOutgoingCallCallModeSelectActionSheet.buttonClickedEventSelector = @selector(newOutgoingCallCallModeSelectActionSheet:clickedButtonAtIndex:);
                    
                    // show actionSheet
                    [_newOutgoingCallCallModeSelectActionSheet showInView:_mGenNewOutgoingCallOperationDependentView];
                }
                break;
        }
    }
    else {
        NSLog(@"There is no active and available reachable network");
        
        // show there is no active and available network currently alertView
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"no active and available network currently alertView title", nil) message:NSLocalizedString(@"no active and available network currently alertView message", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"no active and available network currently alertView cancel button title", nil) otherButtonTitles:NSLocalizedString(@"no active and available network currently alertView setting button title", nil), nil] show];
    }
}

// UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // check cancel button index
    if (alertView.cancelButtonIndex != buttonIndex) {
        NSLog(@"network setting");
        
        //
    }
}

// inner extension
- (void)checkContact4GenNewOutgongCall:(OutgoingCallCallMode)callMode{
    // check contact phone array
    if (1 == _mContactPhones.count) {
        // generate an new outgoing call with phone and call mode
        [self generateNewOutgoingCall:[_mContactPhones objectAtIndex:0] callMode:callMode];
    }
    else {
        // define contact phone call mode string
        NSString *_contactPhoneCallModeString;
        
        // check call mode and generate contact phone call mode string
        switch (callMode) {
            case OUTGOINGCALL_CALLBACK:
                _contactPhoneCallModeString = NSLocalizedString(@"outgoing call callback call mode string", nil);
                break;
                
            case OUTGOINGCALL_Phone_CALL:
                _contactPhoneCallModeString = NSLocalizedString(@"outgoing call phone call call mode string", nil);
                break;
                
            case OUTGOINGCALL_DIRECT_CALL:
            default:
                _contactPhoneCallModeString = NSLocalizedString(@"outgoing call direct call call mode string", nil);
                break;
        }
        
        // define contact phone numbers select action sheet and show it
        UIActionSheet *_contactPhonesSelectActionSheet = [[UIActionSheet alloc] initWithContent:_mContactPhones andTitleFormat:[NSString stringWithFormat:NSLocalizedString(@"outgoing call contact phone numbers select title format", nil), _mContactName, _contactPhoneCallModeString]];
        
        // set actionSheet processor and button clicked event selector
        _contactPhonesSelectActionSheet.processor = self;
        _contactPhonesSelectActionSheet.buttonClickedEventSelector = @selector(contactPhonesSelectActionSheet:clickedButtonAtIndex:);
        
        // set outgoing call mode as tag
        _contactPhonesSelectActionSheet.tag = callMode;
        
        // show actionSheet
        [_contactPhonesSelectActionSheet showInView:_mGenNewOutgoingCallOperationDependentView];
    }
}

- (void)newOutgoingCallCallModeSelectActionSheet:(UIActionSheet *)pActionSheet clickedButtonAtIndex:(NSInteger)pButtonIndex{
    // check select button index
    switch (pButtonIndex) {
        case 1:
            // check contact for generating an new outgoing call: manual callback
            [self checkContact4GenNewOutgongCall:OUTGOINGCALL_CALLBACK];
            break;
            
        case 2:
            // check contact for generating an new outgoing call: manual phone call
            [self checkContact4GenNewOutgongCall:OUTGOINGCALL_Phone_CALL];
            break;
        
        case 0:
        default:
            // check contact for generating an new outgoing call: manual direct dial
            [self checkContact4GenNewOutgongCall:OUTGOINGCALL_DIRECT_CALL];
            break;
    }
}

- (void)contactPhonesSelectActionSheet:(UIActionSheet *)pActionSheet clickedButtonAtIndex:(NSInteger)pButtonIndex{
    // generate an new outgoing call with phone and call mode
    [self generateNewOutgoingCall:[_mContactPhones objectAtIndex:pButtonIndex] callMode:(OutgoingCallCallMode)pActionSheet.tag];
}

- (void)generateNewOutgoingCall:(NSString *)phone callMode:(OutgoingCallCallMode)callMode{
    // check outgoing call call mode
    if (OUTGOINGCALL_Phone_CALL == callMode) {
        // phone call
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phone]]];
    }
    else {
        // make sip voice call
        [SipUtils makeSipVoiceCall:_mContactName phone:phone callMode:(SipCallMode)callMode fromViewController:_mGenNewOutgoingCallOperationDependentViewController];
    }
    
    // check need to clear text dial number label
    if (nil != _mNeed2ClearTextDialNumberLabel && nil != _mStoragePreviousDialPhone) {
        // save previous dial phone and clear dial number label text
        _mNeed2ClearTextDialNumberLabel.text = @"";
        [_mStoragePreviousDialPhone appendString:phone];
    }
}

@end
