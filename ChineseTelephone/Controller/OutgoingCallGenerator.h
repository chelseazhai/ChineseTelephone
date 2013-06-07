//
//  OutgoingCallGenerator.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-5.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutgoingCallGenerator : NSObject <UIActionSheetDelegate> {
    // generate an new outgoing call operation dependent view and view controller
    UIView *_mGenNewOutgoingCallOperationDependentView;
	UIViewController *_mGenNewOutgoingCallOperationDependentViewController;
    
    // contact info: display name and phone numbers
	NSString *_mContactName;
	NSArray *_mContactPhones;
}

// init with generate an new outgoing call operation dependent view and view controller
- (id)initWithDependentView:(UIView *)dependentView andViewController:(UIViewController *)dependentViewController;

// generate an new outgoing call with contact
- (void)generateNewOutgoingCall:(NSString *)contactName phones:(NSArray *)contactPhones;

@end
