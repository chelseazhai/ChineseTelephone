//
//  OutgoingCallView.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-31.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "OutgoingCallView.h"

#import <CommonToolkit/CommonToolkit.h>

#import "OutgoingCallControllerButton.h"

// hearder and footer view height
#define HEADER6FOOTERVIEW_HEIGHT   96.0 

// header view's callee, call status label weight and sum weight
#define HEADERVIEW_CALLEELABEL_WEIGHT   4
#define HEADERVIEW_CALLSTATUSLABEL_WEIGHT   3
#define HEADERVIEW_TOTALSUMWEIGHT   6.0

// center view boarder color
#define CENTERVIEW_BOARDERCOLOR [UIColor colorWithIntegerRed:220 integerGreen:220 integerBlue:220 alpha:1.0]

// callee, and call status label font size
#define CALLEELABEL_FONTSIZE    34.0
#define CALLSTATUSLABEL_FONTSIZE    20.0

// call controller grid view weight and sum weight
#define CALLCONTROLLERGRIDVIEW_WEIGHT   6
#define CALLCONTROLLERGRIDVIEW_TOTALSUMWEIGHT   8.0

// call controller button group row and column
#define CALLCONTROLLERBUTTONGROUP_ROW   2
#define CALLCONTROLLERBUTTONGROUP_COLUMN    2

// call controller buton title, image and action selector key
#define CALLCONTROLLERBUTTON_TITLE_KEY  @"title"
#define CALLCONTROLLERBUTTON_IMAGE_KEY  @"image"
#define CALLCONTROLLERBUTTON_ACTIONSELECTOR_KEY @"actionSelector"

// call controller buton titles, images and action selectors array
#define CALLCONTROLLERBUTTON_TITLES7IMAGES7ACTIONSELECTORS  [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"outgoing call call controller contacts button title", nil), CALLCONTROLLERBUTTON_TITLE_KEY, [UIImage compatibleImageNamed:@"img_callcontroller_contactsbtn"], CALLCONTROLLERBUTTON_IMAGE_KEY, NSStringFromSelector(@selector(showContactList)), CALLCONTROLLERBUTTON_ACTIONSELECTOR_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"outgoing call call controller keyboard button title", nil), CALLCONTROLLERBUTTON_TITLE_KEY, [UIImage compatibleImageNamed:@"img_callcontroller_keyboardbtn"], CALLCONTROLLERBUTTON_IMAGE_KEY, NSStringFromSelector(@selector(showKeyboard)), CALLCONTROLLERBUTTON_ACTIONSELECTOR_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"outgoing call call controller mute button title", nil), CALLCONTROLLERBUTTON_TITLE_KEY, [UIImage compatibleImageNamed:@"img_callcontroller_mutebtn"], CALLCONTROLLERBUTTON_IMAGE_KEY, NSStringFromSelector(@selector(mute)), CALLCONTROLLERBUTTON_ACTIONSELECTOR_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"outgoing call call controller speaker button title", nil), CALLCONTROLLERBUTTON_TITLE_KEY, [UIImage compatibleImageNamed:@"img_callcontroller_speakerbtn"], CALLCONTROLLERBUTTON_IMAGE_KEY, NSStringFromSelector(@selector(handsfree)), CALLCONTROLLERBUTTON_ACTIONSELECTOR_KEY, nil], nil]

// keyboard grid view weight and sum weight
#define KEYBOARDGRIDVIEW_WEIGHT 10
#define KEYBOARDGRIDVIEW_TOTALSUMWEIGHT 12.0

// call back view width, height weight and sum weight
#define CALLBACKVIEW_WIDTHWEIGHT    7
#define CALLBACKVIEW_HEIGHTWEIGHT   8
#define CALLBACKVIEW_TOTALSUMWEIGHT 10.0

// footer view's hangup, hide keyboard button width, height weight and sum weight
#define FOOTERVIEW_HANGUPLONGBUTTON_WIDTHWEIGHT 28
#define FOOTERVIEW_HANGUPSHORTBUTTON_WIDTHWEIGHT    13
#define FOOTERVIEW_HIDEKEYBOARDBUTTON_WIDTHWEIGHT   13
#define FOOTERVIEW_HANGUP6HIDEKEYBOARDBUTTON_HEIGHTWEIGHT   18
#define FOOTERVIEW_TOTALSUMWEIGHT   36.0

@interface OutgoingCallView ()

// show contact list
- (void)showContactList;

// show keyboard grid view
- (void)showKeyboard;

// mute current outgoing sip call
- (void)mute;

// handsfree current outgoing call
- (void)handsfree;

// generate hangup button draw rectangle
- (CGRect)genHangupButtonDrawRect:(BOOL)beResized;

// get hangup button background image
- (UIImage *)getHangupButtonBackgroundImg;

// hangup current outgoing sip call
- (void)hangup;

// hide keyboard grid view
- (void)hideKeyboard;

@end

@implementation OutgoingCallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background image
        self.backgroundColor = [UIColor greenColor];
        
        // create and init subviews
        // init hearer view
        UIView *_headerView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, HEADER6FOOTERVIEW_HEIGHT)];
        
        // set header view background image
        _headerView.backgroundImg = [UIImage imageNamed:@"img_outgoingcall_headerview_bg"];
        
        // init callee label
        _mCalleeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerView.bounds.origin.x, _headerView.bounds.origin.y, FILL_PARENT, FILL_PARENT * (HEADERVIEW_CALLEELABEL_WEIGHT / HEADERVIEW_TOTALSUMWEIGHT))];
        
        // set its attributes
        _mCalleeLabel.textColor = [UIColor whiteColor];
        _mCalleeLabel.textAlignment = NSTextAlignmentCenter;
        _mCalleeLabel.font = [UIFont boldSystemFontOfSize:CALLEELABEL_FONTSIZE];
        _mCalleeLabel.backgroundColor = [UIColor clearColor];
        
        // init call status label
        _mCallStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerView.bounds.origin.x, _headerView.bounds.origin.y + FILL_PARENT * ((HEADERVIEW_TOTALSUMWEIGHT - HEADERVIEW_CALLSTATUSLABEL_WEIGHT) / HEADERVIEW_TOTALSUMWEIGHT), FILL_PARENT, FILL_PARENT * (HEADERVIEW_CALLSTATUSLABEL_WEIGHT / HEADERVIEW_TOTALSUMWEIGHT))];
        
        // set its attributes
        _mCallStatusLabel.text = NSLocalizedString(@"outgoing call calling status", nil);
        _mCallStatusLabel.textColor = [UIColor whiteColor];
        _mCallStatusLabel.textAlignment = NSTextAlignmentCenter;
        _mCallStatusLabel.font = [UIFont systemFontOfSize:CALLSTATUSLABEL_FONTSIZE];
        _mCallStatusLabel.backgroundColor = [UIColor clearColor];
        
        // add callee and call status label as subviews of header view
        [_headerView addSubview:_mCalleeLabel];
        [_headerView addSubview:_mCallStatusLabel];
        
//        // test by ares
//        CGRect _rectangle;
        
        // init center view
        UIView *_centerView = [[UIView alloc] initWithFrame:/*_rectangle =*/ CGRectMakeWithFormat([NSNumber numberWithFloat:self.bounds.origin.x], [NSNumber numberWithFloat:(self.bounds.origin.y + _headerView.bounds.size.height)], [NSNumber numberWithFloat:FILL_PARENT], [NSValue valueWithCString:/*[[NSString stringWithFormat:@"%s-%d-%d", FILL_PARENT_STRING, (int)HEADERVIEW_HEIGHT, (int)FOOTERVIEW_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]*/"FILL_PARENT-96-96"])];
        
        // init call controller grid view
        _mCallControllerGridView = [[UIView alloc] initWithFrame:CGRectMake(_centerView.bounds.origin.x + FILL_PARENT * ((CALLCONTROLLERGRIDVIEW_TOTALSUMWEIGHT - CALLCONTROLLERGRIDVIEW_WEIGHT) / (2 * CALLCONTROLLERGRIDVIEW_TOTALSUMWEIGHT)), _centerView.bounds.origin.y + FILL_PARENT * ((CALLCONTROLLERGRIDVIEW_TOTALSUMWEIGHT - CALLCONTROLLERGRIDVIEW_WEIGHT) / (2 * CALLCONTROLLERGRIDVIEW_TOTALSUMWEIGHT)), FILL_PARENT * (CALLCONTROLLERGRIDVIEW_WEIGHT / CALLCONTROLLERGRIDVIEW_TOTALSUMWEIGHT), FILL_PARENT * (CALLCONTROLLERGRIDVIEW_WEIGHT / CALLCONTROLLERGRIDVIEW_TOTALSUMWEIGHT))];
        
        // init each call controller button
        for (int i = 0; i < [CALLCONTROLLERBUTTON_TITLES7IMAGES7ACTIONSELECTORS count]; i++) {
            // init call controller button
            OutgoingCallControllerButton *_callControllerButton = [[OutgoingCallControllerButton alloc] initWithFrame:CGRectMake(_mCallControllerGridView.bounds.origin.x + (i % CALLCONTROLLERBUTTONGROUP_COLUMN) * (FILL_PARENT / CALLCONTROLLERBUTTONGROUP_COLUMN), _mCallControllerGridView.bounds.origin.y + (i / CALLCONTROLLERBUTTONGROUP_COLUMN) * (FILL_PARENT / CALLCONTROLLERBUTTONGROUP_ROW), FILL_PARENT / CALLCONTROLLERBUTTONGROUP_COLUMN, FILL_PARENT / CALLCONTROLLERBUTTONGROUP_ROW)];
            
            // set background image for normal and highlighted state
            [_callControllerButton setBackgroundImage:[UIImage imageNamed:@"img_callcontrollerbtn_normal_bg"] forState:UIControlStateNormal];
            [_callControllerButton setBackgroundImage:[UIImage imageNamed:@"img_callcontrollerbtn_highlighted_bg"] forState:UIControlStateHighlighted];
            
            // get call controller button title, image and action selector dictionary
            NSDictionary *_callControllerButtonTitle7Image7ActionSelectorDic = [CALLCONTROLLERBUTTON_TITLES7IMAGES7ACTIONSELECTORS objectAtIndex:i];
            
            // set image and title
            [_callControllerButton setImage:[_callControllerButtonTitle7Image7ActionSelectorDic objectForKey:CALLCONTROLLERBUTTON_IMAGE_KEY] andTitle:[_callControllerButtonTitle7Image7ActionSelectorDic objectForKey:CALLCONTROLLERBUTTON_TITLE_KEY]];
            
            // add action selector and its response target for event
            [_callControllerButton addTarget:self action:NSSelectorFromString([_callControllerButtonTitle7Image7ActionSelectorDic objectForKey:CALLCONTROLLERBUTTON_ACTIONSELECTOR_KEY]) forControlEvents:UIControlEventTouchUpInside];
            
            // add call controller button as subviews of call controller button group view
            [_mCallControllerGridView addSubview:_callControllerButton];
        }
        
        // init keyboard grid view
        _mKeyboardGridView = [[UIView alloc] initWithFrame:CGRectMake(_centerView.bounds.origin.x + FILL_PARENT * ((KEYBOARDGRIDVIEW_TOTALSUMWEIGHT - KEYBOARDGRIDVIEW_WEIGHT) / (2 * KEYBOARDGRIDVIEW_TOTALSUMWEIGHT)), _centerView.bounds.origin.y + FILL_PARENT * ((KEYBOARDGRIDVIEW_TOTALSUMWEIGHT - KEYBOARDGRIDVIEW_WEIGHT) / (2 * KEYBOARDGRIDVIEW_TOTALSUMWEIGHT)), FILL_PARENT * (KEYBOARDGRIDVIEW_WEIGHT / KEYBOARDGRIDVIEW_TOTALSUMWEIGHT), FILL_PARENT * (KEYBOARDGRIDVIEW_WEIGHT / KEYBOARDGRIDVIEW_TOTALSUMWEIGHT))];
        
        _mKeyboardGridView.backgroundColor = [UIColor orangeColor];
        
        // hidden first
        _mKeyboardGridView.hidden = YES;
        
        // init call back view
        _mCallbackView = [[UIView alloc] initWithFrame:CGRectMake(_centerView.bounds.origin.x + FILL_PARENT * ((CALLBACKVIEW_TOTALSUMWEIGHT - CALLBACKVIEW_WIDTHWEIGHT) / (2 * CALLBACKVIEW_TOTALSUMWEIGHT)), _centerView.bounds.origin.y + FILL_PARENT * ((CALLBACKVIEW_TOTALSUMWEIGHT - CALLBACKVIEW_HEIGHTWEIGHT) / (2 * CALLBACKVIEW_TOTALSUMWEIGHT)), FILL_PARENT * (CALLBACKVIEW_WIDTHWEIGHT / CALLBACKVIEW_TOTALSUMWEIGHT), FILL_PARENT * (CALLBACKVIEW_HEIGHTWEIGHT / CALLBACKVIEW_TOTALSUMWEIGHT))];
        
        _mCallbackView.backgroundColor = [UIColor purpleColor];
        
        // add call controller, keyboard grid view and call back view as subviews of center view
        [_centerView addSubview:_mCallControllerGridView];
        [_centerView addSubview:_mKeyboardGridView];
        [_centerView addSubview:_mCallbackView];
        
        // set all center subviews cornor radius and border
        // get and check all subviews of center view
        NSArray *_centerViewAllSubviews = _centerView.subviews;
        if (nil != _centerViewAllSubviews) {
            for (int i = 0; i < _centerViewAllSubviews.count; i++) {
                // get each subView of center view
                UIView *_centerViewSubview = [_centerViewAllSubviews objectAtIndex:i];
                
                // set cornor radius and border
                [_centerViewSubview setCornerRadius:10.0];
                [_centerViewSubview setBorderWithWidth:2.0 andColor:CENTERVIEW_BOARDERCOLOR];
            }
        }
        
//        // test by ares
//        NSLog(@"%f -- %f", _centerView.frame.origin.y, _rectangle.origin.y);
        
        // init footer view
        _mFooterView = [[UIView alloc] initWithFrame:CGRectMakeWithFormat([NSNumber numberWithFloat:self.bounds.origin.x], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d", FILL_PARENT_STRING, (int)HEADER6FOOTERVIEW_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:FILL_PARENT], [NSNumber numberWithFloat:HEADER6FOOTERVIEW_HEIGHT])];
        
        // set footer view background image
        _mFooterView.backgroundImg = [UIImage imageNamed:@"img_outgoingcall_footerview_bg"];
        
        // init hangup button
        _mHangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        [_mHangupButton setFrame:[self genHangupButtonDrawRect:NO]];
        
        // set background image for normal state
        [_mHangupButton setBackgroundImage:[self getHangupButtonBackgroundImg] forState:UIControlStateNormal];
        
        // add action selector and its response target for event
        [_mHangupButton addTarget:self action:@selector(hangup) forControlEvents:UIControlEventTouchUpInside];
        
        // init hide keyboard button
        _mHideKeyboardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_mHideKeyboardButton setFrame:CGRectMake(_mFooterView.bounds.origin.x + FILL_PARENT * ((FOOTERVIEW_TOTALSUMWEIGHT + FOOTERVIEW_HANGUPLONGBUTTON_WIDTHWEIGHT - 2 * FOOTERVIEW_HIDEKEYBOARDBUTTON_WIDTHWEIGHT) / (2 * FOOTERVIEW_TOTALSUMWEIGHT)), _mFooterView.bounds.origin.y + FILL_PARENT * ((FOOTERVIEW_TOTALSUMWEIGHT - FOOTERVIEW_HANGUP6HIDEKEYBOARDBUTTON_HEIGHTWEIGHT) / (2 * FOOTERVIEW_TOTALSUMWEIGHT)), FILL_PARENT * (FOOTERVIEW_HIDEKEYBOARDBUTTON_WIDTHWEIGHT / FOOTERVIEW_TOTALSUMWEIGHT), FILL_PARENT * (FOOTERVIEW_HANGUP6HIDEKEYBOARDBUTTON_HEIGHTWEIGHT / FOOTERVIEW_TOTALSUMWEIGHT))];
        
        // set background image for normal state
        [_mHideKeyboardButton setBackgroundImage:[UIImage imageNamed:@"img_hidekeyboardbtn_normal_bg"] forState:UIControlStateNormal];
        [_mHideKeyboardButton setBackgroundImage:[UIImage imageNamed:@"img_hidekeyboardbtn_highlighted_bg"] forState:UIControlStateHighlighted];
        
        // add action selector and its response target for event
        [_mHideKeyboardButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
        
        // hidden first
        _mHideKeyboardButton.hidden = YES;
        
        // add hangup and hide keyboard button as subviews of footer view
        [_mFooterView addSubview:_mHangupButton];
        [_mFooterView addSubview:_mHideKeyboardButton];
        
        // add header, center and footer view as subviews of outgoing call view
        [self addSubview:_headerView];
        [self addSubview:_centerView];
        [self addSubview:_mFooterView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews{
    // resize all subviews
    [self resizesSubviews];
    
//    // test by ares
//    if ([self respondsToSelector:@selector(constraints)]) {
//        NSLog(@"%@", [self constraints]);
//    }
}

- (void)setCallMode:(SipCallMode)callMode callee:(NSString *)callee{
    // check call mode and show correct center view
    switch (callMode) {
        case CALLBACK:
            // hide call controller grid view and show call back view
            if (![_mCallControllerGridView isHidden]) {
                _mCallControllerGridView.hidden = YES;
            }
            if ([_mCallbackView isHidden]) {
                _mCallbackView.hidden = NO;
            }
            break;
            
        case DIRECT_CALL:
        default:
            // show call controller grid view and hide call back view
            if ([_mCallControllerGridView isHidden]) {
                _mCallControllerGridView.hidden = NO;
            }
            if (![_mCallbackView isHidden]) {
                _mCallbackView.hidden = YES;
            }
            break;
    }
    
    // update callee label text
    _mCalleeLabel.text = callee;
}

// inner extension
- (void)showContactList{
    NSLog(@"show contacts list not implementation");
}

- (void)showKeyboard{
    // hide call controller grid view and show keyboard grid view
    _mCallControllerGridView.hidden = YES;
    _mKeyboardGridView.hidden = NO;
    
    // show hide keyboard button
    _mHideKeyboardButton.hidden = NO;
    
    // update hangup button frame and background image for normal state
    [_mHangupButton setFrame:[self genHangupButtonDrawRect:YES]];
    [_mHangupButton setBackgroundImage:[self getHangupButtonBackgroundImg] forState:UIControlStateNormal];
}

- (void)mute{
    NSLog(@"mute not implementation");
}

- (void)handsfree{
    NSLog(@"handsfree not implementation");
}

- (CGRect)genHangupButtonDrawRect:(BOOL)beResized{
    CGRect _hangupButtonDrawRectangle;
    
    // check hangup button if or not be resized and generate hangup button draw rectangle
    if (beResized) {
        _hangupButtonDrawRectangle.origin.x = _mHangupButton.frame.origin.x;
        _hangupButtonDrawRectangle.origin.y = _mHangupButton.frame.origin.y;
        _hangupButtonDrawRectangle.size.width = (nil == _mHideKeyboardButton || [_mHideKeyboardButton isHidden] ? FOOTERVIEW_HANGUPLONGBUTTON_WIDTHWEIGHT / (float)FOOTERVIEW_HANGUPSHORTBUTTON_WIDTHWEIGHT : FOOTERVIEW_HANGUPSHORTBUTTON_WIDTHWEIGHT / (float)FOOTERVIEW_HANGUPLONGBUTTON_WIDTHWEIGHT) * _mHangupButton.frame.size.width;
        _hangupButtonDrawRectangle.size.height = _mHangupButton.frame.size.height;
    }
    else{
        _hangupButtonDrawRectangle.origin.x = _mFooterView.bounds.origin.x + FILL_PARENT * ((FOOTERVIEW_TOTALSUMWEIGHT - FOOTERVIEW_HANGUPLONGBUTTON_WIDTHWEIGHT) / (2 * FOOTERVIEW_TOTALSUMWEIGHT));
        _hangupButtonDrawRectangle.origin.y = _mFooterView.bounds.origin.y + FILL_PARENT * ((FOOTERVIEW_TOTALSUMWEIGHT - FOOTERVIEW_HANGUP6HIDEKEYBOARDBUTTON_HEIGHTWEIGHT) / (2 * FOOTERVIEW_TOTALSUMWEIGHT));
        _hangupButtonDrawRectangle.size.width = FILL_PARENT * ((nil == _mHideKeyboardButton || [_mHideKeyboardButton isHidden] ? FOOTERVIEW_HANGUPLONGBUTTON_WIDTHWEIGHT : FOOTERVIEW_HANGUPSHORTBUTTON_WIDTHWEIGHT) / FOOTERVIEW_TOTALSUMWEIGHT);
        _hangupButtonDrawRectangle.size.height = FILL_PARENT * (FOOTERVIEW_HANGUP6HIDEKEYBOARDBUTTON_HEIGHTWEIGHT / FOOTERVIEW_TOTALSUMWEIGHT);
    }
    
    return _hangupButtonDrawRectangle;
}

- (UIImage *)getHangupButtonBackgroundImg{
    return [UIImage imageNamed:nil == _mHideKeyboardButton || [_mHideKeyboardButton isHidden] ? @"img_hangup_longbtn_normal_bg" : @"img_hangup_shortbtn_normal_bg"];
}

- (void)hangup{
    // test by ares
    NSLog(@"system current setting language = %@", [DeviceUtils systemSettingLanguage]);
    
    // dismiss outgoing call view
    [self.viewControllerRef dismissModalViewControllerAnimated:YES];
}

- (void)hideKeyboard{
    // hide keyboard grid view and show call controller grid view
    _mKeyboardGridView.hidden = YES;
    _mCallControllerGridView.hidden = NO;
    
    // hide hide keyboard button
    _mHideKeyboardButton.hidden = YES;
    
    // update hangup button frame and background image for normal state
    [_mHangupButton setFrame:[self genHangupButtonDrawRect:YES]];
    [_mHangupButton setBackgroundImage:[self getHangupButtonBackgroundImg] forState:UIControlStateNormal];
}

@end
