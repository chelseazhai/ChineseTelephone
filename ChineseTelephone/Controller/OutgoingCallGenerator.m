//
//  OutgoingCallGenerator.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-5.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "OutgoingCallGenerator.h"

// test by ares
#import "OutgoingCallViewController.h"

@implementation OutgoingCallGenerator

- (id)initWithDependentViewController:(UIViewController *)dependentViewController{
    self = [super init];
    if (self) {
        // save generate an new outgoing call operation dependent view controller
        _mGenNewOutgoingCallOperationDependentViewController = dependentViewController;
    }
    return self;
}

- (void)setDependentViewController:(UIViewController *)dependentViewController{
    _mGenNewOutgoingCallOperationDependentViewController = dependentViewController;
}

- (void)generateNewOutgoingCall:(NSString *)contactName phones:(NSArray *)contactPhones{
    // test by ares
    // create and init outgoing call view controller
    OutgoingCallViewController *_outgoingCallViewController = [[OutgoingCallViewController alloc] init];
    
    // set outgoing call sip call mode, phone and its ownnership
    [_outgoingCallViewController setCallMode:CALLBACK phone:[contactPhones objectAtIndex:0] ownnership:contactName];
    
    // goto outgoing call view controller
    [_mGenNewOutgoingCallOperationDependentViewController presentModalViewController:_outgoingCallViewController animated:YES];
}

@end
