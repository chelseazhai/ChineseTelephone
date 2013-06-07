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

// outgoing call dial mode strings
#define OUTGOINGCALL_DAILMODE_STRINGS   [NSArray arrayWithObjects:NSLocalizedString(@"outgoing call direct dial dial mode", nil), NSLocalizedString(@"outgoing call callback dial mode", nil), NSLocalizedString(@"outgoing call phone call dial mode", nil), nil]

@interface OutgoingCallGenerator ()

// check contact for generating an new outgoing call
- (void)checkContact4GenNewOutgongCall:(SipCallMode)callMode dialModeselectPattern:(SipCallDialModeSelectPattern)dialModeSelectPattern;

// dial mode select action sheet button clicked event selector
- (void)dialModeSelectActionSheet:(UIActionSheet *)pActionSheet clickedButtonAtIndex:(NSInteger)pButtonIndex;

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
                [self checkContact4GenNewOutgongCall:DIRECT_CALL dialModeselectPattern:DIRECT_DIAL_DEFAULT];
                break;
                
            case CALLBACK_DEFAULT:
                [self checkContact4GenNewOutgongCall:CALLBACK dialModeselectPattern:CALLBACK_DEFAULT];
                break;
                
            case AUTO_SELECT:
                // get and check current reachability network status
                switch ([_reachabilityForInternetConnection currentReachabilityStatus]) {
                    case ReachableViaWWAN:
                        [self checkContact4GenNewOutgongCall:CALLBACK dialModeselectPattern:AUTO_SELECT];
                        break;
                        
                    case ReachableViaWiFi:
                        [self checkContact4GenNewOutgongCall:DIRECT_CALL dialModeselectPattern:AUTO_SELECT];
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
                    // define contact phone dial mode select action and show it
                    UIActionSheet *_dialModeSelectActionSheet = [[UIActionSheet alloc] initWithContent:OUTGOINGCALL_DAILMODE_STRINGS andTitleFormat:@"123"];
                    
                    // set actionSheet processor and button clicked event selector
                    _dialModeSelectActionSheet.processor = self;
                    _dialModeSelectActionSheet.buttonClickedEventSelector = @selector(dialModeSelectActionSheet:clickedButtonAtIndex:);
                    
                    // show actionSheet
                    [_dialModeSelectActionSheet showInView:_mGenNewOutgoingCallOperationDependentView];
                }
                break;
        }
    }
    else {
        NSLog(@"Not reachable");
    }
    
//    // test by ares
//    // create and init outgoing call view controller
//    OutgoingCallViewController *_outgoingCallViewController = [[OutgoingCallViewController alloc] init];
//    
//    // set outgoing call sip call mode, phone and its ownnership
//    [_outgoingCallViewController setCallMode:CALLBACK phone:[contactPhones objectAtIndex:0] ownnership:contactName];
//    
//    // goto outgoing call view controller
//    [_mGenNewOutgoingCallOperationDependentViewController presentModalViewController:_outgoingCallViewController animated:YES];
}

// inner extension
- (void)checkContact4GenNewOutgongCall:(SipCallMode)callMode dialModeselectPattern:(SipCallDialModeSelectPattern)dialModeSelectPattern{
    //
}

- (void)dialModeSelectActionSheet:(UIActionSheet *)pActionSheet clickedButtonAtIndex:(NSInteger)pButtonIndex{
    // check select button index
    switch (pButtonIndex) {
        case 1:
            NSLog(@"callback");
            break;
            
        case 2:
            NSLog(@"phone call");
            break;
        
        case 0:
        default:
            NSLog(@"direct dial");
            break;
    }
}

@end
