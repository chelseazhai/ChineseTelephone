//
//  OutgoingCallControllerButton.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-5.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutgoingCallControllerButton : UIButton {
    // only response touches event flag
    BOOL _mOnlyRespTouches;
    
    // touches target and action selector
    id _mTouchesTarget;
    SEL _mTouchesActionSelector;
}

// add touch target and action selector
- (void)addTouchTarget:(id)target action:(SEL)action;

// set image and title
- (void)setImage:(UIImage *)image andTitle:(NSString *)title;

@end
