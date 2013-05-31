//
//  MoreTabContentView.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "DialTabContentView.h"

// subview weight and total sum weight
#define DIALNUMBERLABEL_WEIGHT  6
#define DIALBUTTONGRIDVIEW_WEIGHT   20
#define CONTROLLERVIEW_WEIGHT   5
#define TOTALSUMWEIGHT  31.0

// dial number label observer "text" key
#define DIALNUMBERLABEL_OBSERVER_TEXT_KEY   @"text"

// dial number label placeholder font size
#define DIALNUMBERLABEL_PLACEHOLDER_FONTSIZE    30.0

// dial number label text font max size
#define DIALNUMBERLABEL_TEXT_MAXFONTSIZE    42.0

// dial number ownnership label text font size
#define DIALNUMBEROWNNERSHIPLABEL_TEXT_FONTSIZE 14.0

// dial number ownnership weight
#define DIALNUMBEROWNNERSHIPLABEL_WEIGHT    1 / 4.0

// dial button group row and column
#define DIALBUTTONGROUP_ROW 4
#define DIALBUTTONGROUP_COLUMN  3

// zero dial button tag
#define ZERODIALBUTTON_TAG  10

// dial button values and images
#define DIALBUTTON_VALUES   [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"*", @"0", @"#", nil]

// zero dial button shift value
#define ZERODIALBUTTON_SHIFTVALUE   @"+"

#define DIALBUTTON_IMAGES   [NSArray arrayWithObjects:[UIImage imageNamed:@"img_dial_1_btn"], [UIImage imageNamed:@"img_dial_2_btn"], [UIImage imageNamed:@"img_dial_3_btn"], [UIImage imageNamed:@"img_dial_4_btn"], [UIImage imageNamed:@"img_dial_5_btn"], [UIImage imageNamed:@"img_dial_6_btn"], [UIImage imageNamed:@"img_dial_7_btn"], [UIImage imageNamed:@"img_dial_8_btn"], [UIImage imageNamed:@"img_dial_9_btn"], [UIImage imageNamed:@"img_dial_star_btn"], [UIImage imageNamed:@"img_dial_0_btn"], [UIImage imageNamed:@"img_dial_pound_btn"], nil]

// controller view sum weight
#define CONTROLLERVIEW_SUMWEIGHT    3.0

// dial number label text update mode
typedef NS_ENUM(NSInteger, DialNumberLabelTextUpdateMode){
    TEXT_APPEND, TEXT_SUB
};

@interface DialTabContentView ()

@property (nonatomic, readonly) NSString *dialNumber;

// dial button clicked
- (void)dialButtonClicked:(UIButton *)dialButton;

// add new contact with phone number to address book
- (void)addNewContact2ABWithPhoneNumber;

// call with dial number
- (void)callWithDialNumber;

// clear dial number
- (void)clearDialNumber;

// update dial number label text with update type and updated string
- (void)updateDialNumberLabelTextWithUpdateType:(DialNumberLabelTextUpdateMode)updateType string:(NSString *)updatedString;

@end

@implementation DialTabContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set tab bar item with title, image and tag
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"dial tab item title", nil) image:[UIImage imageNamed:@"img_tab_dial"] tag:1];
        
        // create and init subviews
        // init dial number and its ownnership view
        UIView *_dialNumber7OwnnershipView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, FILL_PARENT, FILL_PARENT * (DIALNUMBERLABEL_WEIGHT / TOTALSUMWEIGHT))];
        
        // init dial number label
        _mDialNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_dialNumber7OwnnershipView.bounds.origin.x, _dialNumber7OwnnershipView.bounds.origin.y, FILL_PARENT, FILL_PARENT)];
        
        // set its attributes
        _mDialNumberLabel.textColor = [UIColor lightGrayColor];
        _mDialNumberLabel.textAlignment = NSTextAlignmentCenter;
        _mDialNumberLabel.adjustsFontSizeToFitWidth = YES;
        _mDialNumberLabel.text = NSLocalizedString(@"dial number label placeholder", nil);
        _mDialNumberLabel.font = [UIFont boldSystemFontOfSize:DIALNUMBERLABEL_PLACEHOLDER_FONTSIZE];
        _mDialNumberLabel.backgroundImg = [UIImage compatibleImageNamed:@"img_dialnumberlabel_bg"];
        
        // add observer for key "text"
        [_mDialNumberLabel addObserver:self forKeyPath:DIALNUMBERLABEL_OBSERVER_TEXT_KEY options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        // init dial number ownnership label
        _mDialNumberOwnnershipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_dialNumber7OwnnershipView.bounds.origin.x, _dialNumber7OwnnershipView.bounds.origin.y + FILL_PARENT * (1 - DIALNUMBEROWNNERSHIPLABEL_WEIGHT), FILL_PARENT, FILL_PARENT * DIALNUMBEROWNNERSHIPLABEL_WEIGHT)];
        
        // set its attributes
        _mDialNumberOwnnershipLabel.textColor = [UIColor whiteColor];
        _mDialNumberOwnnershipLabel.textAlignment = NSTextAlignmentCenter;
        _mDialNumberOwnnershipLabel.font = [UIFont systemFontOfSize:DIALNUMBEROWNNERSHIPLABEL_TEXT_FONTSIZE];
        _mDialNumberOwnnershipLabel.backgroundColor = [UIColor clearColor];
        
        // dial number ownnership label hide first
        _mDialNumberOwnnershipLabel.hidden = YES;
        
        // add dial phone and its ownnership label as subviews of dial number and its ownnership view
        [_dialNumber7OwnnershipView addSubview:_mDialNumberLabel];
        [_dialNumber7OwnnershipView addSubview:_mDialNumberOwnnershipLabel];
        
        // get dial button background normal and highlighted image
        UIImage *_dialBtnBgNormalImg = [UIImage imageNamed:@"img_dialbtn_normal_bg"];
        UIImage *_dialBtnBgHighlightedImg = [UIImage imageNamed:@"img_dialbtn_highlighted_bg"];
        
        // init dial button grid view
        UIView *_dialButtonGridView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _dialNumber7OwnnershipView.bounds.size.height, FILL_PARENT, FILL_PARENT * (DIALBUTTONGRIDVIEW_WEIGHT / TOTALSUMWEIGHT))];
        
        // init each dial button
        for (int i = 0; i < [DIALBUTTON_IMAGES count]; i++) {
            // init dial button
            UIButton *_dialButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            // set its frame
            _dialButton.frame = CGRectMake(_dialButtonGridView.bounds.origin.x + (i % DIALBUTTONGROUP_COLUMN) * (FILL_PARENT / DIALBUTTONGROUP_COLUMN), _dialButtonGridView.bounds.origin.y + (i / DIALBUTTONGROUP_COLUMN) * (FILL_PARENT / DIALBUTTONGROUP_ROW), FILL_PARENT / DIALBUTTONGROUP_COLUMN, FILL_PARENT / DIALBUTTONGROUP_ROW);
            
            // set background image, image for normal and highlighted state
            [_dialButton setBackgroundImage:_dialBtnBgNormalImg forState:UIControlStateNormal];
            [_dialButton setBackgroundImage:_dialBtnBgHighlightedImg forState:UIControlStateHighlighted];
            [_dialButton setImage:[DIALBUTTON_IMAGES objectAtIndex:i]];
            
            // set tag
            _dialButton.tag = i;
            
            // add action selector and its response target for event
            [_dialButton addTarget:self action:@selector(dialButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            // add long press gesture for zero dial button
            if (ZERODIALBUTTON_TAG == i) {
                // set zero dial button
                _mZeroDialButton = _dialButton;
                
                // set zero dial button long press gesture recognizer
                _mZeroDialButton.viewGestureRecognizerDelegate = self;
            }
            
            // add dial button as subviews of dial button group view
            [_dialButtonGridView addSubview:_dialButton];
        }
        
        // init controller view
        UIView *_controllerView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _dialNumber7OwnnershipView.bounds.size.height + _dialButtonGridView.bounds.size.height, FILL_PARENT, FILL_PARENT * (CONTROLLERVIEW_WEIGHT / TOTALSUMWEIGHT))];
        
        // get add new contact and clear dial number button background normal image
        UIImage *_addNewContact6clearDialNumberBtnBgNormalImg = [UIImage imageNamed:@"img_addnewcontact6cleardialnumber_btn_normal_bg"];
        
        // init add new contact with phone number to address book button
        UIButton *_addNewContactWithPhone2ABButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        _addNewContactWithPhone2ABButton.frame = CGRectMake(_controllerView.bounds.origin.x, _controllerView.bounds.origin.y, FILL_PARENT / CONTROLLERVIEW_SUMWEIGHT, FILL_PARENT);
        
        // set background image, image for normal and highlighted state
        [_addNewContactWithPhone2ABButton setBackgroundImage:_addNewContact6clearDialNumberBtnBgNormalImg forState:UIControlStateNormal];
        [_addNewContactWithPhone2ABButton setBackgroundImage:_dialBtnBgHighlightedImg forState:UIControlStateHighlighted];
        [_addNewContactWithPhone2ABButton setImage:[UIImage imageNamed:@"img_newcontact_btn"]];
        
        // add action selector and its response target for event
        [_addNewContactWithPhone2ABButton addTarget:self action:@selector(addNewContact2ABWithPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
        
        // init call with dial number button
        UIButton *_callWithDialNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        _callWithDialNumberButton.frame = CGRectMake(_controllerView.bounds.origin.x + _addNewContactWithPhone2ABButton.bounds.size.width, _controllerView.bounds.origin.y, FILL_PARENT / CONTROLLERVIEW_SUMWEIGHT, FILL_PARENT);
        
        // set background image, image for normal and highlighted state
        [_callWithDialNumberButton setBackgroundImage:[UIImage imageNamed:@"img_callbtn_normal_bg"] forState:UIControlStateNormal];
        [_callWithDialNumberButton setBackgroundImage:[UIImage imageNamed:@"img_callbtn_highlighted_bg"] forState:UIControlStateHighlighted];
        [_callWithDialNumberButton setImage:[UIImage imageNamed:@"img_callbtn"]];
        
        // add action selector and its response target for event
        [_callWithDialNumberButton addTarget:self action:@selector(callWithDialNumber) forControlEvents:UIControlEventTouchUpInside];
        
        // init clear dial number button
        _mClearDialNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        _mClearDialNumberButton.frame = CGRectMake(_controllerView.bounds.origin.x + _callWithDialNumberButton.bounds.size.width + _addNewContactWithPhone2ABButton.bounds.size.width, _controllerView.bounds.origin.y, FILL_PARENT / CONTROLLERVIEW_SUMWEIGHT, FILL_PARENT);
        
        // set background image, image for normal and highlighted state
        [_mClearDialNumberButton setBackgroundImage:_addNewContact6clearDialNumberBtnBgNormalImg forState:UIControlStateNormal];
        [_mClearDialNumberButton setBackgroundImage:_dialBtnBgHighlightedImg forState:UIControlStateHighlighted];
        [_mClearDialNumberButton setImage:[UIImage imageNamed:@"img_cleardialphone_btn"]];
        
        // add action selector and its response target for event
        [_mClearDialNumberButton addTarget:self action:@selector(clearDialNumber) forControlEvents:UIControlEventTouchUpInside];
        
        // set clear dial number button long press gesture recognizer
        _mClearDialNumberButton.viewGestureRecognizerDelegate = self;
        
        // add add new contact with phone to address book, call with dial number and clear dial phone button as subviews of controller view
        [_controllerView addSubview:_addNewContactWithPhone2ABButton];
        [_controllerView addSubview:_callWithDialNumberButton];
        [_controllerView addSubview:_mClearDialNumberButton];
        
        // add dial phone and its ownnership view, dial button grid view and controller view as subviews
        [self addSubview:_dialNumber7OwnnershipView];
        [self addSubview:_dialButtonGridView];
        [self addSubview:_controllerView];
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
}

// UIViewGestureRecognizerDelegate
- (GestureType)supportedGestureInView:(UIView *)pView{
    GestureType _ret = longPress;
    
    // check view if it is or not zero dial or clar dial number button
    if (_mZeroDialButton == pView || _mClearDialNumberButton == pView) {
        _ret = longPress;
    }
    else {
        NSLog(@"View = %@ need supported gesture", pView);
    }
    
    return _ret;
}

- (void)view:(UIView *)pView longPressAtPoint:(CGPoint)pPoint andFingerMode:(LongPressFingerMode)pFingerMode{
    // check view
    if (_mZeroDialButton == pView) {
        // update dial number label text
        [self updateDialNumberLabelTextWithUpdateType:TEXT_APPEND string:ZERODIALBUTTON_SHIFTVALUE];
    }
    else if (_mClearDialNumberButton == pView) {
        // clear dial number label text
        _mDialNumberLabel.text = @"";
    }
}

// observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    // check key and object
    if ([DIALNUMBERLABEL_OBSERVER_TEXT_KEY isEqualToString:keyPath] && _mDialNumberLabel == object) {
        // process dial number text changed
        // get old and new text of dial number label
        NSString *_oldText = [change objectForKey:NSKeyValueChangeOldKey];
        NSString *_newText = [change objectForKey:NSKeyValueChangeNewKey];
        
        // update dial number label text color and font size
        if ((nil == _oldText || [@"" isEqualToString:_oldText]) && [NSLocalizedString(@"dial number label placeholder", nil) isEqualToString:_newText]) {
            _mDialNumberLabel.textColor = [UIColor lightGrayColor];
            _mDialNumberLabel.font = [UIFont boldSystemFontOfSize:DIALNUMBERLABEL_PLACEHOLDER_FONTSIZE];
            
            // hide dial number ownnership label
            if (![_mDialNumberOwnnershipLabel isHidden]) {
                _mDialNumberOwnnershipLabel.hidden = YES;
            }
        }
        else if (nil == _newText || [@"" isEqualToString:_newText]) {
            _mDialNumberLabel.text = NSLocalizedString(@"dial number label placeholder", nil);
        }
        else {
            // first dial number exter
            if ([NSLocalizedString(@"dial number label placeholder", nil) isEqualToString:_oldText] && nil != _newText && ![@"" isEqualToString:_newText]) {
                _mDialNumberLabel.textColor = [UIColor whiteColor];
                _mDialNumberLabel.font = [UIFont boldSystemFontOfSize:DIALNUMBERLABEL_TEXT_MAXFONTSIZE];
            }
            
            // check dial number if or not has ownnership
            NSArray *_ownnershipContactsDisplayNameArray = [[AddressBookManager shareAddressBookManager] contactsDisplayNameArrayWithPhoneNumber:_newText];
            if (_newText != [_ownnershipContactsDisplayNameArray objectAtIndex:0]) {
                // set dial number ownnership label text
                _mDialNumberOwnnershipLabel.text = [_ownnershipContactsDisplayNameArray objectAtIndex:0];
                
                // show dial number ownnership label
                if ([_mDialNumberOwnnershipLabel isHidden]) {
                    _mDialNumberOwnnershipLabel.hidden = NO;
                }
            } else {
                // hide dial number ownnership label
                if (![_mDialNumberOwnnershipLabel isHidden]) {
                    _mDialNumberOwnnershipLabel.hidden = YES;
                }
            }
        }
    }
}

// inner extension
- (NSString *)dialNumber{
    // get dial number
    NSString *_dialNumber = _mDialNumberLabel.text;
    
    // check it
    if (nil != _dialNumber && [NSLocalizedString(@"dial number label placeholder", nil) isEqualToString:_dialNumber]) {
        _dialNumber = nil;
    }
    
    return _dialNumber;
}

- (void)dialButtonClicked:(UIButton *)dialButton{
    // update dial number label text
    [self updateDialNumberLabelTextWithUpdateType:TEXT_APPEND string:[DIALBUTTON_VALUES objectAtIndex:dialButton.tag]];
}

- (void)addNewContact2ABWithPhoneNumber{
    NSLog(@"Add new contact with phone number = %@ to address book", self.dialNumber);
}

- (void)callWithDialNumber{
    NSLog(@"Call with dial number = %@", self.dialNumber);
}

- (void)clearDialNumber{
    // update dial number label text
    [self updateDialNumberLabelTextWithUpdateType:TEXT_SUB string:[_mDialNumberLabel.text substringToIndex:_mDialNumberLabel.text.length - 1]];
}

- (void)updateDialNumberLabelTextWithUpdateType:(DialNumberLabelTextUpdateMode)updateType string:(NSString *)updatedString{
    // get, check and update dial number label text
    NSString *_dialNumberLabelText = self.dialNumber;
    
    if (nil != _dialNumberLabelText && ![@"" isEqualToString:_dialNumberLabelText]) {
        // check update type
        switch (updateType) {
            case TEXT_SUB:
                _mDialNumberLabel.text = [_dialNumberLabelText substringToIndex:_dialNumberLabelText.length - 1];
                break;
            
            case TEXT_APPEND:
            default:
                _mDialNumberLabel.text = [_dialNumberLabelText stringByAppendingString:updatedString];
                break;
        }
    }
    else {
        // set updated string as dial number label text when append
        if (TEXT_APPEND == updateType) {
            _mDialNumberLabel.text = updatedString;
        }
    }
}

@end
