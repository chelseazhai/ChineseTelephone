//
//  OutgoingCallView.h
//  ChineseTelephone
//
//  Created by Ares on 13-5-31.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SipCallMode.h"

@interface OutgoingCallView : UIView {
    // sip call mode
    SipCallMode _mSipCallMode;
    
    // sip callee
    NSString *_mSipCallee;
    
    // present subviews
    // header view
    // callee label
    UILabel *_mCalleeLabel;
    // call status label
    UILabel *_mCallStatusLabel;
    
    // center views
    // call controller grid view
    UIView *_mCallControllerGridView;
    // keyboard grid view
    UIView *_mKeyboardGridView;
    // call back view
    UIView *_mCallbackView;
    
    // footer view
    // footer view
    UIView *_mFooterView;
    // hangup button
    UIButton *_mHangupButton;
    // hide keyboard button
    UIButton *_mHideKeyboardButton;
}

// set outgoing call sip call mode and callee
- (void)setCallMode:(SipCallMode)callMode callee:(NSString *)callee;

@end
