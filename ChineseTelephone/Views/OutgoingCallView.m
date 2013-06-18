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

#import "DialTabContentView.h"

#import "SipBaseImplementation.h"

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
#define CALLCONTROLLERBUTTON_TITLES7IMAGES7ACTIONSELECTORS  [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"outgoing call call controller contacts button title", nil), CALLCONTROLLERBUTTON_TITLE_KEY, [UIImage compatibleImageNamed:@"img_callcontroller_contactsbtn"], CALLCONTROLLERBUTTON_IMAGE_KEY, NSStringFromSelector(@selector(showContactList)), CALLCONTROLLERBUTTON_ACTIONSELECTOR_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"outgoing call call controller keyboard button title", nil), CALLCONTROLLERBUTTON_TITLE_KEY, [UIImage compatibleImageNamed:@"img_callcontroller_keyboardbtn"], CALLCONTROLLERBUTTON_IMAGE_KEY, NSStringFromSelector(@selector(showKeyboard)), CALLCONTROLLERBUTTON_ACTIONSELECTOR_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"outgoing call call controller mute button title", nil), CALLCONTROLLERBUTTON_TITLE_KEY, [UIImage compatibleImageNamed:@"img_callcontroller_mutebtn"], CALLCONTROLLERBUTTON_IMAGE_KEY, NSStringFromSelector(@selector(mute6unmute:)), CALLCONTROLLERBUTTON_ACTIONSELECTOR_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"outgoing call call controller speaker button title", nil), CALLCONTROLLERBUTTON_TITLE_KEY, [UIImage compatibleImageNamed:@"img_callcontroller_speakerbtn"], CALLCONTROLLERBUTTON_IMAGE_KEY, NSStringFromSelector(@selector(handsfree6cancelHandsfree:)), CALLCONTROLLERBUTTON_ACTIONSELECTOR_KEY, nil], nil]

// keyboard grid view weight and sum weight
#define KEYBOARDGRIDVIEW_WEIGHT 10
#define KEYBOARDGRIDVIEW_TOTALSUMWEIGHT 12.0

// show or hide keyboard grid view animation duration
#define SHOW6HIDEKEYBOARDGRIDVIEW_ANIMATIONDURATION 0.7f

// callback view width, height weight and sum weight
#define CALLBACKVIEW_WIDTHWEIGHT    7
#define CALLBACKVIEW_HEIGHTWEIGHT   8
#define CALLBACKVIEW_TOTALSUMWEIGHT 10.0

// callback call request result image view, label width and height weight and sum weight
#define CALLBACKVIEW_REQUESTRESULTIMAGEVIEW_WEIGHT 8
#define CALLBACKVIEW_REQUESTRESULTLABEL_HEIGHTWEIGHT   12
#define CALLBACKVIEW_REQUESTRESULTLABEL_WIDTHWEIGHT    18
#define CALLBACKVIEW_REQUESTRESULT_TOTALSUMWEIGHT   20.0

// callback call request result label font size
#define CALLBACKVIEW_REQUESTRESULTLABEL_FONTSIZE   18.0

// footer view's hangup, hide keyboard button width, height weight and sum weight
#define FOOTERVIEW_HANGUPLONGBUTTON_WIDTHWEIGHT 28
#define FOOTERVIEW_HANGUPSHORTBUTTON_WIDTHWEIGHT    13
#define FOOTERVIEW_HIDEKEYBOARDBUTTON_WIDTHWEIGHT   13
#define FOOTERVIEW_HANGUP6HIDEKEYBOARDBUTTON_HEIGHTWEIGHT   18
#define FOOTERVIEW_TOTALSUMWEIGHT   36.0

// initiative and passive terminate delay
#define INITIATIVETERMINATE_DELAY   0.5
#define PASSIVETERMINATE_DELAY  0.7

// sip voice call failed call duration
#define SIPVOICECALL_CALLFAILED_CALLDURATION    -1L

// sip voice call terminated type
typedef NS_ENUM(NSInteger, SipVoiceCallTerminatedType){
    // initiative or passive
    INITIATIVE, PASSIVE
};

@interface OutgoingCallView ()

// set call controller button background image for normal and highlighted state
- (void)setCallControllerButtonBackgroundImage:(UIButton *)callControllerButton;

// show contact list
- (void)showContactList;

// show keyboard grid view
- (void)showKeyboard;

// mute or unmute current outgoing sip call
- (void)mute6unmute:(UIButton *)muteButton;

// handsfree or cancel handsfree current outgoing call
- (void)handsfree6cancelHandsfree:(UIButton *)handsfreeButton;

// generate hangup button draw rectangle
- (CGRect)genHangupButtonDrawRect:(BOOL)beResized;

// get hangup button background image
- (UIImage *)getHangupButtonBackgroundImg;

// get hangup button image
- (UIImage *)getHangupButtonImg;

// hangup current outgoing sip call
- (void)hangup;

// terminate sip voice call
- (void)terminateSipVoiceCall:(SipVoiceCallTerminatedType)terminatedType;

// dismiss outgoing call view
- (void)dismissOutgoingCallView;

// keyboard number button clicked
- (void)keyboardNumberButtonClicked:(UIButton *)keyboardNumberButton;

// hide keyboard grid view
- (void)hideKeyboard;

// back for waiting callback call
- (void)back4waitingCallbackCall;

// send callback sip voice call successful
- (void)sendCallbackSipVoiceCallSuccessful;

// send callback sip voice call failure
- (void)sendCallbackSipVoiceCallFailure;

// show callback view and update callback call request result label text and image view image with response result
- (void)showCallbackViewAndUpdateSubviews:(BOOL)isSucceed;

// outgoing call enter to background
- (void)outgoingCallEnter2Background;

@end

@implementation OutgoingCallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background image
        self.backgroundImg = [UIImage compatibleImageNamed:@"img_outgoingcall_bg"];
        
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
            [self setCallControllerButtonBackgroundImage:_callControllerButton];
            
            // get call controller button title, image and action selector dictionary
            NSDictionary *_callControllerButtonTitle7Image7ActionSelectorDic = [CALLCONTROLLERBUTTON_TITLES7IMAGES7ACTIONSELECTORS objectAtIndex:i];
            
            // set image and title
            [_callControllerButton setImage:[_callControllerButtonTitle7Image7ActionSelectorDic objectForKey:CALLCONTROLLERBUTTON_IMAGE_KEY] andTitle:[_callControllerButtonTitle7Image7ActionSelectorDic objectForKey:CALLCONTROLLERBUTTON_TITLE_KEY]];
            
            // add action selector and its response target for event
            if ([CALLCONTROLLERBUTTON_TITLES7IMAGES7ACTIONSELECTORS count] / 2 <= i) {
                // mute and handsfree using touches
                [_callControllerButton addTouchTarget:self action:NSSelectorFromString([_callControllerButtonTitle7Image7ActionSelectorDic objectForKey:CALLCONTROLLERBUTTON_ACTIONSELECTOR_KEY])];
            }
            else {
                [_callControllerButton addTarget:self action:NSSelectorFromString([_callControllerButtonTitle7Image7ActionSelectorDic objectForKey:CALLCONTROLLERBUTTON_ACTIONSELECTOR_KEY]) forControlEvents:UIControlEventTouchUpInside];
            }
            
            // add call controller button as subviews of call controller button group view
            [_mCallControllerGridView addSubview:_callControllerButton];
        }
        
        // init keyboard grid view
        _mKeyboardGridView = [[UIView alloc] initWithFrame:CGRectMake(_centerView.bounds.origin.x + FILL_PARENT * ((KEYBOARDGRIDVIEW_TOTALSUMWEIGHT - KEYBOARDGRIDVIEW_WEIGHT) / (2 * KEYBOARDGRIDVIEW_TOTALSUMWEIGHT)), _centerView.bounds.origin.y + FILL_PARENT * ((KEYBOARDGRIDVIEW_TOTALSUMWEIGHT - KEYBOARDGRIDVIEW_WEIGHT) / (2 * KEYBOARDGRIDVIEW_TOTALSUMWEIGHT)), FILL_PARENT * (KEYBOARDGRIDVIEW_WEIGHT / KEYBOARDGRIDVIEW_TOTALSUMWEIGHT), FILL_PARENT * (KEYBOARDGRIDVIEW_WEIGHT / KEYBOARDGRIDVIEW_TOTALSUMWEIGHT))];
        
        // get keyboard number button background normal and highlighted image
        UIImage *_keyboardNumberBtnBgNormalImg = [UIImage imageNamed:@"img_callcontrollerbtn_normal_bg"];
        UIImage *_keyboardNumberBtnBgHighlightedImg = [UIImage imageNamed:@"img_callcontrollerbtn_highlighted_bg"];
        
        // init each keyboard number button
        for (int i = 0; i < [NUMBERBUTTON_VALUES7IMAGES7DTMFSOUNDTONEIDS count]; i++) {
            // init keyboard number button
            UIButton *_keyboardNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            // set its frame
            _keyboardNumberButton.frame = CGRectMake(_mKeyboardGridView.bounds.origin.x + (i % NUMBERBUTTONGROUP_COLUMN) * (FILL_PARENT / NUMBERBUTTONGROUP_COLUMN), _mKeyboardGridView.bounds.origin.y + (i / NUMBERBUTTONGROUP_COLUMN) * (FILL_PARENT / NUMBERBUTTONGROUP_ROW), FILL_PARENT / NUMBERBUTTONGROUP_COLUMN, FILL_PARENT / NUMBERBUTTONGROUP_ROW);
            
            // set background image, image for normal and highlighted state
            [_keyboardNumberButton setBackgroundImage:_keyboardNumberBtnBgNormalImg forState:UIControlStateNormal];
            [_keyboardNumberButton setBackgroundImage:_keyboardNumberBtnBgHighlightedImg forState:UIControlStateHighlighted];
            [_keyboardNumberButton setImage:[[NUMBERBUTTON_VALUES7IMAGES7DTMFSOUNDTONEIDS objectAtIndex:i] objectForKey:NUMBERBUTTON_IMAGE_KEY]];
            
            // set tag
            _keyboardNumberButton.tag = i;
            
            // add action selector and its response target for event
            [_keyboardNumberButton addTarget:self action:@selector(keyboardNumberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            // add keyboard number button as subviews of keyboard group view
            [_mKeyboardGridView addSubview:_keyboardNumberButton];
        }
        
        // hidden first
        _mKeyboardGridView.hidden = YES;
        
        // init callback view
        _mCallbackView = [[UIView alloc] initWithFrame:CGRectMake(_centerView.bounds.origin.x + FILL_PARENT * ((CALLBACKVIEW_TOTALSUMWEIGHT - CALLBACKVIEW_WIDTHWEIGHT) / (2 * CALLBACKVIEW_TOTALSUMWEIGHT)), _centerView.bounds.origin.y + FILL_PARENT * ((CALLBACKVIEW_TOTALSUMWEIGHT - CALLBACKVIEW_HEIGHTWEIGHT) / (2 * CALLBACKVIEW_TOTALSUMWEIGHT)), FILL_PARENT * (CALLBACKVIEW_WIDTHWEIGHT / CALLBACKVIEW_TOTALSUMWEIGHT), FILL_PARENT * (CALLBACKVIEW_HEIGHTWEIGHT / CALLBACKVIEW_TOTALSUMWEIGHT))];
        
        // set background image
        _mCallbackView.backgroundImg = [UIImage imageNamed:@"img_callbackview_bg"];
        
        // init callback call request result image view
        UIImageView *_callbackCallRequestResultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_mCallbackView.bounds.origin.x, _mCallbackView.bounds.origin.y, FILL_PARENT, FILL_PARENT * (CALLBACKVIEW_REQUESTRESULTIMAGEVIEW_WEIGHT / CALLBACKVIEW_REQUESTRESULT_TOTALSUMWEIGHT))];
        
        // set content mode
        _callbackCallRequestResultImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        // init callback call request result label
        UILabel *_callbackCallRequestResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mCallbackView.bounds.origin.x + FILL_PARENT * ((CALLBACKVIEW_REQUESTRESULT_TOTALSUMWEIGHT - CALLBACKVIEW_REQUESTRESULTLABEL_WIDTHWEIGHT) / (2 * CALLBACKVIEW_REQUESTRESULT_TOTALSUMWEIGHT)), _mCallbackView.bounds.origin.y + _callbackCallRequestResultImageView.bounds.size.height, FILL_PARENT * (CALLBACKVIEW_REQUESTRESULTLABEL_WIDTHWEIGHT / CALLBACKVIEW_REQUESTRESULT_TOTALSUMWEIGHT), FILL_PARENT * (CALLBACKVIEW_REQUESTRESULTLABEL_HEIGHTWEIGHT / CALLBACKVIEW_REQUESTRESULT_TOTALSUMWEIGHT))];
        
        // set its attributes
        _callbackCallRequestResultLabel.textColor = [UIColor whiteColor];
        _callbackCallRequestResultLabel.textAlignment = NSTextAlignmentCenter;
        _callbackCallRequestResultLabel.font = [UIFont systemFontOfSize:CALLBACKVIEW_REQUESTRESULTLABEL_FONTSIZE];
        _callbackCallRequestResultLabel.backgroundColor = [UIColor clearColor];
        
        // add callback call request result image view and label as subviews of callback view
        [_mCallbackView addSubview:_callbackCallRequestResultImageView];
        [_mCallbackView addSubview:_callbackCallRequestResultLabel];
        
        // hidden first
        _mCallbackView.hidden = YES;
        
        // add call controller, keyboard grid view and callback view as subviews of center view
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
        
        // set image for normal and highlighted state
        [_mHangupButton setImage:[self getHangupButtonImg]];
        
        // add action selector and its response target for event
        [_mHangupButton addTarget:self action:@selector(hangup) forControlEvents:UIControlEventTouchUpInside];
        
        // init hide keyboard button
        _mHideKeyboardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set its frame
        [_mHideKeyboardButton setFrame:CGRectMake(_mFooterView.bounds.origin.x + FILL_PARENT * ((FOOTERVIEW_TOTALSUMWEIGHT + FOOTERVIEW_HANGUPLONGBUTTON_WIDTHWEIGHT - 2 * FOOTERVIEW_HIDEKEYBOARDBUTTON_WIDTHWEIGHT) / (2 * FOOTERVIEW_TOTALSUMWEIGHT)), _mFooterView.bounds.origin.y + FILL_PARENT * ((FOOTERVIEW_TOTALSUMWEIGHT - FOOTERVIEW_HANGUP6HIDEKEYBOARDBUTTON_HEIGHTWEIGHT) / (2 * FOOTERVIEW_TOTALSUMWEIGHT)), FILL_PARENT * (FOOTERVIEW_HIDEKEYBOARDBUTTON_WIDTHWEIGHT / FOOTERVIEW_TOTALSUMWEIGHT), FILL_PARENT * (FOOTERVIEW_HANGUP6HIDEKEYBOARDBUTTON_HEIGHTWEIGHT / FOOTERVIEW_TOTALSUMWEIGHT))];
        
        // set background image for normal state
        [_mHideKeyboardButton setBackgroundImage:[UIImage imageNamed:@"img_hidekeyboardbtn_normal_bg"] forState:UIControlStateNormal];
        [_mHideKeyboardButton setBackgroundImage:[UIImage imageNamed:@"img_hidekeyboardbtn_highlighted_bg"] forState:UIControlStateHighlighted];
        
        // set image for normal and highlighted state
        [_mHideKeyboardButton setImage:[UIImage ImageWithLanguageNamed:@"img_hidekeyboardbtn"]];
        
        // add action selector and its response target for event
        [_mHideKeyboardButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
        
        // hidden first
        _mHideKeyboardButton.hidden = YES;
        
        // init back for waiting callback call button
        _mBack4waitingCallbackCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        [_mBack4waitingCallbackCallButton setFrame:_mHangupButton.frame];
        
        // set background image for normal state
        [_mBack4waitingCallbackCallButton setBackgroundImage:[UIImage imageNamed:@"img_back4waitingcallbackcallbtn_bg"] forState:UIControlStateNormal];
        
        // set image for normal and highlighted state
        [_mBack4waitingCallbackCallButton setImage:[UIImage ImageWithLanguageNamed:@"img_back4waitingcallbackcallbtn"]];
        
        // add action selector and its response target for event
        [_mBack4waitingCallbackCallButton addTarget:self action:@selector(back4waitingCallbackCall) forControlEvents:UIControlEventTouchUpInside];
        
        // add hangup, hide keyboard and back for waiting callback call button as subviews of footer view
        [_mFooterView addSubview:_mHangupButton];
        [_mFooterView addSubview:_mHideKeyboardButton];
        [_mFooterView addSubview:_mBack4waitingCallbackCallButton];
        
        // add header, center and footer view as subviews of outgoing call view
        [self addSubview:_headerView];
        [self addSubview:_centerView];
        [self addSubview:_mFooterView];
        
        // add outgoing call enter to background observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outgoingCallEnter2Background) name:UIApplicationDidEnterBackgroundNotification object:nil];
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

- (SEL)callbackSipVoiceCallHttpReqFinishedRespSelector{
    return @selector(sendCallbackSipVoiceCallSuccessful);
}

- (SEL)CallbackSipVoiceCallHttpReqFailedRespSelector{
    return @selector(sendCallbackSipVoiceCallFailure);
}

- (void)setCallMode:(SipCallMode)callMode callee:(NSString *)callee phone:(NSString *)phone{
    // save sip call phone
    _mSipCallPhone = phone;
    
    // check call mode and show correct center view
    switch (callMode) {
        case CALLBACK:
            // hide call controller grid view
            if (![_mCallControllerGridView isHidden]) {
                _mCallControllerGridView.hidden = YES;
            }
            
            // hide hangup current outgoing call button and show back for waiting callback call button
            if (![_mHangupButton isHidden]) {
                _mHangupButton.hidden = YES;
            }
            if ([_mBack4waitingCallbackCallButton isHidden]) {
                _mBack4waitingCallbackCallButton.hidden = NO;
            }
            break;
            
        case DIRECT_CALL:
        default:
            // show call controller grid view
            if ([_mCallControllerGridView isHidden]) {
                _mCallControllerGridView.hidden = NO;
            }
            
            // show hangup current outgoing call button and hide back for waiting callback call button
            if ([_mHangupButton isHidden]) {
                _mHangupButton.hidden = NO;
            }
            if (![_mBack4waitingCallbackCallButton isHidden]) {
                _mBack4waitingCallbackCallButton.hidden = YES;
            }
            break;
    }
    
    // save callee and update callee label text
    _mCalleeLabel.text = _mCallee = callee;
    
    // set sip voice call is establishing
    _mSipVoiceCallIsEstablished = NO;
}

- (void)setSipImplementation:(id<ISipProtocol>)sipImplementation{
    _mSipImplementation = sipImplementation;
}

// SipInviteStateChangedProtocol
- (void)onCallInitializing{
    // update call state label text, calling
    _mCallStatusLabel.text = NSLocalizedString(@"outgoing call calling status", nil);
    
    // set sip voice call is establishing
    _mSipVoiceCallIsEstablished = NO;
}

- (void)onCallEarlyMedia{
    // update call state label text, calling
    _mCallStatusLabel.text = NSLocalizedString(@"outgoing call early media or remote ring", nil);
    
    // set sip voice call is establishing
    _mSipVoiceCallIsEstablished = NO;
}

- (void)onCallRemoteRinging{
    [self onCallEarlyMedia];
}

- (void)onCallSpeaking{
    // set sip voice call is established
    _mSipVoiceCallIsEstablished = YES;
    
    //
}

- (void)onCallFailed{
    // update call state label text, call failed
    _mCallStatusLabel.text = NSLocalizedString(@"outgoing call call failed status", nil);
    
    // set sip voice call is establishing
    _mSipVoiceCallIsEstablished = NO;
    
    // update call failed call record with call log id
    [((SipBaseImplementation *)_mSipImplementation) updateSipVoiceCallDuration:SIPVOICECALL_CALLFAILED_CALLDURATION];
    
    // terminate current sip voice call after 0.7 seconds
    [self performSelector:@selector(onCallTerminated) withObject:[NSNumber numberWithInteger:INITIATIVE] afterDelay:PASSIVETERMINATE_DELAY];
}

- (void)onCallTerminating{
    // update call state label text, call terminating
    _mCallStatusLabel.text = NSLocalizedString(@"outgoing call terminating status", nil);
    
    // terminate current sip voice call after 0.7 seconds
    [self performSelector:@selector(onCallTerminated) withObject:[NSNumber numberWithInteger:INITIATIVE] afterDelay:PASSIVETERMINATE_DELAY];
}

- (void)onCallTerminated{
    // terminate current sip voice call
    [self terminateSipVoiceCall:PASSIVE];
}

// inner extension
- (void)setCallControllerButtonBackgroundImage:(UIButton *)callControllerButton{
    // check call controller button and set background image for normal, highlighted state
    if (callControllerButton.tag) {
        [callControllerButton setBackgroundImage:[UIImage imageNamed:@"img_callcontrollerbtn_highlighted_bg"] forState:UIControlStateNormal];
        [callControllerButton setBackgroundImage:[UIImage imageNamed:@"img_callcontrollerbtn_normal_bg"] forState:UIControlStateHighlighted];
    }
    else {
        [callControllerButton setBackgroundImage:[UIImage imageNamed:@"img_callcontrollerbtn_normal_bg"] forState:UIControlStateNormal];
        [callControllerButton setBackgroundImage:[UIImage imageNamed:@"img_callcontrollerbtn_highlighted_bg"] forState:UIControlStateHighlighted];
    }
}

- (void)showContactList{
    NSLog(@"show contacts list not implementation");
    
    //
}

- (void)showKeyboard{
    // hide call controller grid view and show keyboard grid view with animation
    [UIView transitionFromView:_mCallControllerGridView toView:_mKeyboardGridView duration:SHOW6HIDEKEYBOARDGRIDVIEW_ANIMATIONDURATION options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionShowHideTransitionViews | UIViewAnimationOptionCurveEaseInOut completion:nil];
    
    // show hide keyboard button
    _mHideKeyboardButton.hidden = NO;
    
    // update hangup button frame, background image and image for normal state
    [_mHangupButton setFrame:[self genHangupButtonDrawRect:YES]];
    [_mHangupButton setBackgroundImage:[self getHangupButtonBackgroundImg] forState:UIControlStateNormal];
    [_mHangupButton setImage:[self getHangupButtonImg]];
}

- (void)mute6unmute:(UIButton *)muteButton{
    // get and check current sip voice call is muted
    if (muteButton.tag) {
        // set current sip voice call is unmuted and unmute it
        muteButton.tag = FALSE;
        [_mSipImplementation unmuteSipVoiceCall];
    }
    else {
        // set current sip voice call is muted and mute it
        muteButton.tag = TRUE;
        [_mSipImplementation muteSipVoiceCall];
    }
    
    // update mute button background image
    [self setCallControllerButtonBackgroundImage:muteButton];
}

- (void)handsfree6cancelHandsfree:(UIButton *)handsfreeButton{
    // get and check current sip voice call is handsfreed
    if (handsfreeButton.tag) {
        // set current sip voice call using earphone
        handsfreeButton.tag = FALSE;
        [_mSipImplementation setSipVoiceCallUsingEarphone];
    }
    else {
        // set current sip voice call using loudspeaker
        handsfreeButton.tag = TRUE;
        [_mSipImplementation setSipVoiceCallUsingLoudspeaker];
    }
    
    // update handsfree button background image
    [self setCallControllerButtonBackgroundImage:handsfreeButton];
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
    return [UIImage imageNamed:nil == _mHideKeyboardButton || [_mHideKeyboardButton isHidden] ? @"img_hangup_longbtn_bg" : @"img_hangup_shortbtn_bg"];
}

- (UIImage *)getHangupButtonImg{
    return [UIImage ImageWithLanguageNamed:nil == _mHideKeyboardButton || [_mHideKeyboardButton isHidden] ? @"img_hangup_longbtn" : @"img_hangup_shortbtn"];
}

- (void)hangup{
    // update call status with terminating
    _mCallStatusLabel.text = NSLocalizedString(@"outgoing call terminating status", nil);
    
    // terminate current sip voice call after 0.5 seconds
    [self performSelector:@selector(terminateSipVoiceCall:) withObject:[NSNumber numberWithInteger:INITIATIVE] afterDelay:INITIATIVETERMINATE_DELAY];
}

- (void)terminateSipVoiceCall:(SipVoiceCallTerminatedType)terminatedType{
    // update call status with terminated
    _mCallStatusLabel.text = NSLocalizedString(@"outgoing call terminated status", nil);
    
    // get call duration: seconds
    // test by ares
    long _callDuration = 100L;
    
    // check sip voice call terminated type
    switch (terminatedType) {
        case INITIATIVE:
            // hangup current sip voice call
            if (![_mSipImplementation hangupSipVoiceCall:_callDuration]) {
                // force dismiss outgoing call view
				[self dismissOutgoingCallView];
                
				// return immediately
				return;
            }
            break;
            
        case PASSIVE:
        default:
            // check sip voice call is established
            if (_mSipVoiceCallIsEstablished) {
                // update sip voice call duration
                [((SipBaseImplementation *)_mSipImplementation) updateSipVoiceCallDuration:_callDuration];
            }
            break;
    }
    
    // dismiss outgoing call view after 0.7 seconds
    [self performSelector:@selector(dismissOutgoingCallView) withObject:nil afterDelay:PASSIVETERMINATE_DELAY];
}

- (void)dismissOutgoingCallView{
    // dismiss outgoing call view using its view controller
    [self.viewControllerRef dismissModalViewControllerAnimated:YES];
}

- (void)keyboardNumberButtonClicked:(UIButton *)keyboardNumberButton{
    // play dtmf sound
    [AudioServicesUtils playDTMFSound:((NSString *)[[NUMBERBUTTON_VALUES7IMAGES7DTMFSOUNDTONEIDS objectAtIndex:keyboardNumberButton.tag] objectForKey:NUMBERBUTTON_DTMFTONEID_KEY]).integerValue];
    
    // get clicked keyboard number button value
    NSString *_clickedKeyboardNumberButtonValue = [[NUMBERBUTTON_VALUES7IMAGES7DTMFSOUNDTONEIDS objectAtIndex:keyboardNumberButton.tag] objectForKey:NUMBERBUTTON_VALUE_KEY];
    
    // compare callee label text with callee and update callee label text
    if ([_mCallee isEqualToString:_mCalleeLabel.text]) {
        _mCalleeLabel.text = _clickedKeyboardNumberButtonValue;
    }
    else {
        _mCalleeLabel.text = [_mCalleeLabel.text stringByAppendingString:_clickedKeyboardNumberButtonValue];
    }
    
    // send dtmf signal using sip implementation
    [_mSipImplementation sendDTMF:_clickedKeyboardNumberButtonValue];
}

- (void)hideKeyboard{
    // reset callee label text
    _mCalleeLabel.text = _mCallee;
    
    // hide keyboard grid view and show call controller grid view with animation
    [UIView transitionFromView:_mKeyboardGridView toView:_mCallControllerGridView duration:SHOW6HIDEKEYBOARDGRIDVIEW_ANIMATIONDURATION options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews | UIViewAnimationOptionCurveEaseInOut completion:nil];
    
    // hide hide keyboard button
    _mHideKeyboardButton.hidden = YES;
    
    // update hangup button frame, background image and image for normal state
    [_mHangupButton setFrame:[self genHangupButtonDrawRect:YES]];
    [_mHangupButton setBackgroundImage:[self getHangupButtonBackgroundImg] forState:UIControlStateNormal];
    [_mHangupButton setImage:[self getHangupButtonImg]];
}

- (void)back4waitingCallbackCall{
    // dismiss outgoing call view
    [self dismissOutgoingCallView];
}

- (void)sendCallbackSipVoiceCallSuccessful{
    // show callback view and update its subviews
    [self showCallbackViewAndUpdateSubviews:YES];
}

- (void)sendCallbackSipVoiceCallFailure{
    // show callback view and update its subviews
    [self showCallbackViewAndUpdateSubviews:NO];
}

- (void)showCallbackViewAndUpdateSubviews:(BOOL)isSucceed{
    // update call status label text
    _mCallStatusLabel.text = isSucceed ? NSLocalizedString(@"outgoing call callback succeed status", nil) : NSLocalizedString(@"outgoing call callback failed status", nil);
    
    // get and check callback view all subviews
    NSArray *_callbackViewSubviews = [_mCallbackView subviews];
    if (nil != _callbackViewSubviews) {
        // process each subview
        for (int i = 0; i < _callbackViewSubviews.count; i++) {
            // get and check callback view subview
            UIView *_callbackViewSubview = [_callbackViewSubviews objectAtIndex:i];
            if ([_callbackViewSubview isKindOfClass:[UILabel class]]) {
                // get callback call request response result label
                UILabel *_callbackCallReqRespLabel = (UILabel *)_callbackViewSubview;
                
                // update callback call request response result label text
                _callbackCallReqRespLabel.text = isSucceed ? [NSString stringWithFormat:NSLocalizedString(@"outgoing call callback succeed comment format string", nil), @"8618001582338", _mSipCallPhone] : NSLocalizedString(@"outgoing call callback failed comment", nil);
                
                // get number of lines float
                float _numberOfLinesFloat = [_callbackCallReqRespLabel.text stringPixelLengthByFontSize:CALLBACKVIEW_REQUESTRESULTLABEL_FONTSIZE andIsBold:NO] / _callbackCallReqRespLabel.bounds.size.width;
                
                // update callback call request response result label number of lines
                _callbackCallReqRespLabel.numberOfLines = (int)_numberOfLinesFloat < _numberOfLinesFloat ? (int)_numberOfLinesFloat + 1 : (int)_numberOfLinesFloat;
            }
            else if ([_callbackViewSubview isKindOfClass:[UIImageView class]]) {
                // update callback call request response result image view image
                ((UIImageView *)_callbackViewSubview).image = isSucceed ? [UIImage imageNamed:@"img_sendcallbackcall_succeed"] : [UIImage imageNamed:@"img_sendcallbackcall_failed"];
            }
        }
        
        // show callback view
        if ([_mCallbackView isHidden]) {
            _mCallbackView.hidden = NO;
        }
    }
}

- (void)outgoingCallEnter2Background{
    NSLog(@"outgoing call enter to background");
    
    //
}

@end
