//
//  MoreTabContentView.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "DialTabContentView.h"

#import <CommonToolkit/CommonToolkit.h>

// subview weight and total sum weight
#define DIALNUMBERLABEL_WEIGHT  6
#define DIALBUTTONGRIDVIEW_WEIGHT   20
#define CONTROLLERVIEW_WEIGHT   5
#define TOTALSUMWEIGHT  31.0

// dial number label observer "text" key
#define DIALNUMBERLABEL_OBSERVER_TEXT_KEY   @"text"

// dial number ownnership weight
#define DIALNUMBER_OWNNERSHIPLABEL_WEIGHT    1 / 4.0

// dial button group row and column
#define DIALBUTTONGROUP_ROW 4
#define DIALBUTTONGROUP_COLUMN  3

// dial button images
#define DIALBUTTON_IMAGES   [NSArray arrayWithObjects:[UIImage imageNamed:@"img_dial_1_btn"], [UIImage imageNamed:@"img_dial_2_btn"], [UIImage imageNamed:@"img_dial_3_btn"], [UIImage imageNamed:@"img_dial_4_btn"], [UIImage imageNamed:@"img_dial_5_btn"], [UIImage imageNamed:@"img_dial_6_btn"], [UIImage imageNamed:@"img_dial_7_btn"], [UIImage imageNamed:@"img_dial_8_btn"], [UIImage imageNamed:@"img_dial_9_btn"], [UIImage imageNamed:@"img_dial_star_btn"], [UIImage imageNamed:@"img_dial_0_btn"], [UIImage imageNamed:@"img_dial_pound_btn"], nil]

// controller view sum weight
#define CONTROLLERVIEW_SUMWEIGHT    3.0

@interface DialTabContentView ()

// dial button clicked
- (void)dialButtonClicked:(UIButton *)dialButton;

// add new contact with phone number to address book
- (void)addNewContact2ABWithPhoneNumber;

// call with dial number
- (void)callWithDialNumber;

// clear dial number
- (void)clearDialNumber;

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
        _mDialNumberLabel.textColor = [UIColor whiteColor];
        _mDialNumberLabel.textAlignment = NSTextAlignmentCenter;
        _mDialNumberLabel.text = @"18001582338";
        _mDialNumberLabel.font = [UIFont boldSystemFontOfSize:42.0];
        _mDialNumberLabel.backgroundImg = [UIImage compatibleImageNamed:@"img_dialnumberlabel_bg"];
        
        // add observer for key "text"
        [_mDialNumberLabel addObserver:self forKeyPath:DIALNUMBERLABEL_OBSERVER_TEXT_KEY options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        // init dial number ownnership label
        _mDialNumberOwnnershipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_dialNumber7OwnnershipView.bounds.origin.x, _dialNumber7OwnnershipView.bounds.origin.y + FILL_PARENT * (1 - DIALNUMBER_OWNNERSHIPLABEL_WEIGHT), FILL_PARENT, FILL_PARENT * DIALNUMBER_OWNNERSHIPLABEL_WEIGHT)];
        
        // set its attributes
        _mDialNumberOwnnershipLabel.textColor = [UIColor whiteColor];
        _mDialNumberOwnnershipLabel.textAlignment = NSTextAlignmentCenter;
        _mDialNumberOwnnershipLabel.text = @"翟绍虎";
        _mDialNumberOwnnershipLabel.font = [UIFont systemFontOfSize:14.0];
        _mDialNumberOwnnershipLabel.backgroundColor = [UIColor clearColor];
        
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
            [_dialButton setImage:[DIALBUTTON_IMAGES objectAtIndex:i] forState:UIControlStateNormal];
            [_dialButton setImage:[DIALBUTTON_IMAGES objectAtIndex:i] forState:UIControlStateHighlighted];
            
            // set tag
            _dialButton.tag = i;
            
            // add action selector and its response target for event
            [_dialButton addTarget:self action:@selector(dialButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
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
        UIImage *_addNewContactWithPhone2ABButtonImg = [UIImage imageNamed:@"img_newcontact_btn"];
        [_addNewContactWithPhone2ABButton setImage:_addNewContactWithPhone2ABButtonImg forState:UIControlStateNormal];
        [_addNewContactWithPhone2ABButton setImage:_addNewContactWithPhone2ABButtonImg forState:UIControlStateHighlighted];
        
        // add action selector and its response target for event
        [_addNewContactWithPhone2ABButton addTarget:self action:@selector(addNewContact2ABWithPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
        
        // init call with dial number button
        UIButton *_callWithDialNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        _callWithDialNumberButton.frame = CGRectMake(_controllerView.bounds.origin.x + _addNewContactWithPhone2ABButton.bounds.size.width, _controllerView.bounds.origin.y, FILL_PARENT / CONTROLLERVIEW_SUMWEIGHT, FILL_PARENT);
        
        // set background image, image for normal and highlighted state
        [_callWithDialNumberButton setBackgroundImage:[UIImage imageNamed:@"img_callbtn_normal_bg"] forState:UIControlStateNormal];
        [_callWithDialNumberButton setBackgroundImage:[UIImage imageNamed:@"img_callbtn_highlighted_bg"] forState:UIControlStateHighlighted];
        UIImage *_callWithDialNumberButtonImg = [UIImage imageNamed:@"img_callbtn"];
        [_callWithDialNumberButton setImage:_callWithDialNumberButtonImg forState:UIControlStateNormal];
        [_callWithDialNumberButton setImage:_callWithDialNumberButtonImg forState:UIControlStateHighlighted];
        
        // add action selector and its response target for event
        [_callWithDialNumberButton addTarget:self action:@selector(callWithDialNumber) forControlEvents:UIControlEventTouchUpInside];
        
        // init clear dial number button
        UIButton *_clearDialNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        _clearDialNumberButton.frame = CGRectMake(_controllerView.bounds.origin.x + _callWithDialNumberButton.bounds.size.width + _addNewContactWithPhone2ABButton.bounds.size.width, _controllerView.bounds.origin.y, FILL_PARENT / CONTROLLERVIEW_SUMWEIGHT, FILL_PARENT);
        
        // set background image, image for normal and highlighted state
        [_clearDialNumberButton setBackgroundImage:_addNewContact6clearDialNumberBtnBgNormalImg forState:UIControlStateNormal];
        [_clearDialNumberButton setBackgroundImage:_dialBtnBgHighlightedImg forState:UIControlStateHighlighted];
        UIImage *_clearDialNumberButtonImg = [UIImage imageNamed:@"img_cleardialphone_btn"];
        [_clearDialNumberButton setImage:_clearDialNumberButtonImg forState:UIControlStateNormal];
        [_clearDialNumberButton setImage:_clearDialNumberButtonImg forState:UIControlStateHighlighted];
        
        // add action selector and its response target for event
        [_clearDialNumberButton addTarget:self action:@selector(clearDialNumber) forControlEvents:UIControlEventTouchUpInside];
        
        // add add new contact with phone to address book, call with dial number and clear dial phone button as subviews of controller view
        [_controllerView addSubview:_addNewContactWithPhone2ABButton];
        [_controllerView addSubview:_callWithDialNumberButton];
        [_controllerView addSubview:_clearDialNumberButton];
        
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

// observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"key path = %@, object = %@ and changed info = %@", keyPath, object, change);
    
    //
    [change objectForKey:NSKeyValueChangeNewKey];
    [change objectForKey:NSKeyValueChangeOldKey];
}

// inner extension
- (void)dialButtonClicked:(UIButton *)dialButton{
    NSLog(@"Dial button = %@ clicked, its tag = %d", dialButton, dialButton.tag);
    
    _mDialNumberLabel.text = @"13770662051";
}

- (void)addNewContact2ABWithPhoneNumber{
    NSLog(@"Add new contact with phone number to address book");
}

- (void)callWithDialNumber{
    NSLog(@"Call with dial number");
}

- (void)clearDialNumber{
    NSLog(@"Clear dial number");
}

@end
