//
//  OutgoingCallControllerButton.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-5.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "OutgoingCallControllerButton.h"

#import <CommonToolkit/CommonToolkit.h>

#import <objc/message.h>

// button image and title paddding
#define IMG7TITLE_PADDING   10.0

@implementation OutgoingCallControllerButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set only resphonse touches event default value is false
        _mOnlyRespTouches = FALSE;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // check if it is only response touches event
    if (_mOnlyRespTouches) {
        // check touched event type
        if (UIEventTypeTouches == event.type) {
            // check touches target
            if (nil != _mTouchesTarget) {
                // check touches action selector
                if (nil != _mTouchesActionSelector && [_mTouchesTarget respondsToSelector:_mTouchesActionSelector]) {
                    // send message to its processor with param action
                    objc_msgSend(_mTouchesTarget, _mTouchesActionSelector, self);
                }
                else {
                    NSLog(@"Error: outgoing call controller button = %@ can't implement touches action selector = %@", _mTouchesTarget, NSStringFromSelector(_mTouchesActionSelector));
                }
            }
            else{
                NSLog(@"Warning: outgoing call controller button touches target is %@", _mTouchesTarget);
            }
        }
    }
    else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)addTouchTarget:(id)target action:(SEL)action{
    // set it is only response touches event
    _mOnlyRespTouches = YES;
    
    // save touches target and action selector
    _mTouchesTarget = target;
    _mTouchesActionSelector = action;
}

- (void)setImage:(UIImage *)image andTitle:(NSString *)title{
    // set image
    [self setImage:image];
    
    // set title and title color
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    // set image and title edge insets
    [self setImageEdgeInsets:UIEdgeInsetsMake(- ([title stringPixelHeightByFontSize:16.0 andIsBold:NO] + IMG7TITLE_PADDING / 2.0), 0.0, 0.0, - self.titleLabel.bounds.size.width)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.bounds.origin.y + image.size.height + IMG7TITLE_PADDING, - image.size.width, 0.0, 0.0)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
