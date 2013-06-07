//
//  SipCallDialModeSelector.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

// key of store sip call dial mode select pattern
#define SIPCALLDIALMODE_SELECTPATTERN_KEY   @"sipCallDialMode_selectPattern_storingKey"

// sip call dial mode select pattern
typedef NS_ENUM(NSInteger, SipCallDialModeSelectPattern){
    // direct dial, callback default, manual and auto select
    DIRECT_DIAL_DEFAULT, CALLBACK_DEFAULT, MANUAL_SELECT, AUTO_SELECT
};

@interface SipCallDialModeSelector : NSObject

// set sip call dial mode select pattern
+ (void)setSipCallDialModeSelectPattern:(SipCallDialModeSelectPattern)sipCallDialModeSelectPattern;

// get sip call dial mode select pattern
+ (SipCallDialModeSelectPattern)getSipCallDialModeSelectPattern;

@end
