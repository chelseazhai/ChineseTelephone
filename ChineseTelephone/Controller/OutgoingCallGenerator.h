//
//  OutgoingCallGenerator.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-5.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutgoingCallGenerator : NSObject {
    // generate an new outgoing call operation dependent view controller
	UIViewController *_mGenNewOutgoingCallOperationDependentViewController;
}

// init with generate an new outgoing call operation dependent view controller
- (id)initWithDependentViewController:(UIViewController *)dependentViewController;

// set generate an new outgoing call operation dependent view controller
- (void)setDependentViewController:(UIViewController *)dependentViewController;

// generate an new outgoing call with contact
- (void)generateNewOutgoingCall:(NSString *)contactName phones:(NSArray *)contactPhones;

@end
