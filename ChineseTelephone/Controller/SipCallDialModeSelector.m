//
//  SipCallDialModeSelector.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SipCallDialModeSelector.h"

@implementation SipCallDialModeSelector

+ (void)setSipCallDialModeSelectPattern:(SipCallDialModeSelectPattern)sipCallDialModeSelectPattern{
    // store using user defaults
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:sipCallDialModeSelectPattern] forKey:SIPCALLDIALMODE_SELECTPATTERN_KEY];
}

+ (SipCallDialModeSelectPattern)getSipCallDialModeSelectPattern{
    // define sip call dial mode select pattern, default is manual select
    SipCallDialModeSelectPattern _sipCallDialModeSelectPattern = MANUAL_SELECT;
    
    // get and check sip call dial mode select pattern number from user defaults
    NSNumber *_sipCallDialModeSelectPatternNumber = [[NSUserDefaults standardUserDefaults] objectForKey:SIPCALLDIALMODE_SELECTPATTERN_KEY];
    if (nil != _sipCallDialModeSelectPatternNumber && DIRECT_DIAL_DEFAULT <= _sipCallDialModeSelectPatternNumber.integerValue && AUTO_SELECT >= _sipCallDialModeSelectPatternNumber.integerValue) {
        _sipCallDialModeSelectPattern = _sipCallDialModeSelectPatternNumber.integerValue;
    }
    
    return _sipCallDialModeSelectPattern;
}

@end
