//
//  MoreTabContentView.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "DialTabContentView.h"

#import "OutgoingCallGenerator.h"

// subview weight and total sum weight
#define DIALNUMBERLABEL_WEIGHT  6
#define DIALNUMBERBUTTONGRIDVIEW_WEIGHT 20
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

// zero dial number button tag and shift value
#define ZERODIALNUMBERBUTTON_TAG  10
#define ZERODIALNUMBERBUTTON_SHIFTVALUE   @"+"

// controller view sum weight
#define CONTROLLERVIEW_SUMWEIGHT    3.0

// dial number label text update mode
typedef NS_ENUM(NSInteger, DialNumberLabelTextUpdateMode){
    TEXT_APPEND, TEXT_SUB
};

// add dial phone to contact in address book mode
typedef NS_ENUM(NSInteger, AddDialPhone2ContactMode){
    NEW_ADDED, APPEND_EXISTED
};

@interface DialTabContentView ()

@property (nonatomic, readonly) NSString *dialNumber;

// dial number button clicked
- (void)dialNumberButtonClicked:(UIButton *)dialNumberButton;

// add new contact with phone number to address book
- (void)addNewContact2ABWithPhoneNumber:(UIButton *)addNewContact2ABWithPhoneNumberButton;

// dial numbers add to new or existed contact select action sheet button clicked event selector
- (void)dialNumberAdd2NewOrExistedContactSelectActionSheet:(UIActionSheet *)pActionSheet clickedButtonAtIndex:(NSInteger)pButtonIndex;

// show address book new person view controller with added phone, mode and appended person if has
- (void)showABNewPersonViewController:(NSString *)phone addedMode:(AddDialPhone2ContactMode)mode appendedPerson:(ABRecordRef)appendedPerson;

// call with dial number
- (void)callWithDialNumber:(UIButton *)dialButton;

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
        
        // set dial number and ownnership view background image
        _dialNumber7OwnnershipView.backgroundImg = [UIImage compatibleImageNamed:@"img_dialnumber7ownnershiplabel_bg"];
        
        // init dial number label
        _mDialNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_dialNumber7OwnnershipView.bounds.origin.x, _dialNumber7OwnnershipView.bounds.origin.y, FILL_PARENT, FILL_PARENT)];
        
        // set its attributes
        _mDialNumberLabel.textColor = [UIColor lightGrayColor];
        _mDialNumberLabel.textAlignment = NSTextAlignmentCenter;
        _mDialNumberLabel.adjustsFontSizeToFitWidth = YES;
        _mDialNumberLabel.text = NSLocalizedString(@"dial number label placeholder", nil);
        _mDialNumberLabel.font = [UIFont boldSystemFontOfSize:DIALNUMBERLABEL_PLACEHOLDER_FONTSIZE];
        _mDialNumberLabel.backgroundColor = [UIColor clearColor];
        
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
        
        // get dial number button background normal and highlighted image
        UIImage *_dialBtnBgNormalImg = [UIImage imageNamed:@"img_dialbtn_normal_bg"];
        UIImage *_dialBtnBgHighlightedImg = [UIImage imageNamed:@"img_dialbtn_highlighted_bg"];
        
        // init dial number button grid view
        UIView *_dialNumberButtonGridView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _dialNumber7OwnnershipView.bounds.size.height, FILL_PARENT, FILL_PARENT * (DIALNUMBERBUTTONGRIDVIEW_WEIGHT / TOTALSUMWEIGHT))];
        
        // init each dial number button
        for (int i = 0; i < [NUMBERBUTTON_VALUES7IMAGES7DTMFSOUNDTONEIDS count]; i++) {
            // init dial number button
            UIButton *_dialNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            // set its frame
            _dialNumberButton.frame = CGRectMake(_dialNumberButtonGridView.bounds.origin.x + (i % NUMBERBUTTONGROUP_COLUMN) * (FILL_PARENT / NUMBERBUTTONGROUP_COLUMN), _dialNumberButtonGridView.bounds.origin.y + (i / NUMBERBUTTONGROUP_COLUMN) * (FILL_PARENT / NUMBERBUTTONGROUP_ROW), FILL_PARENT / NUMBERBUTTONGROUP_COLUMN, FILL_PARENT / NUMBERBUTTONGROUP_ROW);
            
            // set background image, image for normal and highlighted state
            [_dialNumberButton setBackgroundImage:_dialBtnBgNormalImg forState:UIControlStateNormal];
            [_dialNumberButton setBackgroundImage:_dialBtnBgHighlightedImg forState:UIControlStateHighlighted];
            [_dialNumberButton setImage:[[NUMBERBUTTON_VALUES7IMAGES7DTMFSOUNDTONEIDS objectAtIndex:i] objectForKey:NUMBERBUTTON_IMAGE_KEY]];
            
            // set tag
            _dialNumberButton.tag = i;
            
            // add action selector and its response target for event
            [_dialNumberButton addTarget:self action:@selector(dialNumberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            // add long press gesture for zero dial number button
            if (ZERODIALNUMBERBUTTON_TAG == i) {
                // set zero dial number button
                _mZeroDialNumberButton = _dialNumberButton;
                
                // set zero dial number button long press gesture recognizer
                _mZeroDialNumberButton.viewGestureRecognizerDelegate = self;
            }
            
            // add dial number button as subviews of dial number button group view
            [_dialNumberButtonGridView addSubview:_dialNumberButton];
        }
        
        // init controller view
        UIView *_controllerView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _dialNumber7OwnnershipView.bounds.size.height + _dialNumberButtonGridView.bounds.size.height, FILL_PARENT, FILL_PARENT * (CONTROLLERVIEW_WEIGHT / TOTALSUMWEIGHT))];
        
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
        [_addNewContactWithPhone2ABButton addTarget:self action:@selector(addNewContact2ABWithPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
        
        // init call with dial number button
        UIButton *_callWithDialNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        _callWithDialNumberButton.frame = CGRectMake(_controllerView.bounds.origin.x + _addNewContactWithPhone2ABButton.bounds.size.width, _controllerView.bounds.origin.y, FILL_PARENT / CONTROLLERVIEW_SUMWEIGHT, FILL_PARENT);
        
        // set background image, image for normal and highlighted state
        [_callWithDialNumberButton setBackgroundImage:[UIImage imageNamed:@"img_callbtn_normal_bg"] forState:UIControlStateNormal];
        [_callWithDialNumberButton setBackgroundImage:[UIImage imageNamed:@"img_callbtn_highlighted_bg"] forState:UIControlStateHighlighted];
        [_callWithDialNumberButton setImage:[UIImage compatibleImageWithLanguageNamed:@"img_callbtn"]];
        
        // add action selector and its response target for event
        [_callWithDialNumberButton addTarget:self action:@selector(callWithDialNumber:) forControlEvents:UIControlEventTouchUpInside];
        
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
        
        // add dial phone and its ownnership view, dial number button grid view and controller view as subviews
        [self addSubview:_dialNumber7OwnnershipView];
        [self addSubview:_dialNumberButtonGridView];
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
    
    // check view if it is or not zero dial number button or clar dial number button
    if (_mZeroDialNumberButton == pView || _mClearDialNumberButton == pView) {
        _ret = longPress;
    }
    else {
        NSLog(@"View = %@ need supported gesture", pView);
    }
    
    return _ret;
}

- (void)view:(UIView *)pView longPressAtPoint:(CGPoint)pPoint andFingerMode:(LongPressFingerMode)pFingerMode{
    // check view
    if (_mZeroDialNumberButton == pView) {
        // update dial number label text
        [self updateDialNumberLabelTextWithUpdateType:TEXT_APPEND string:ZERODIALNUMBERBUTTON_SHIFTVALUE];
    }
    else if (_mClearDialNumberButton == pView) {
        // clear dial number label text
        _mDialNumberLabel.text = @"";
    }
}

// ABNewPersonViewControllerDelegate
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
//    // check person
//    if (NULL == person) {
//        NSLog(@"CFGetRetainCount(_displayedPerson) = %ld", CFGetRetainCount(newPersonView.displayedPerson));
//        NSLog(@"person = %@ and displayed person = %@", person, newPersonView.displayedPerson);
//        CFRetain(newPersonView.displayedPerson);
//    }
    
    // clear address book new person view controller
    [[AddressBookUIUtils shareAddressBookUIUtils] clearABNewPersonViewController];
    
    // dismiss new person view controller
    [self.viewControllerRef dismissModalViewControllerAnimated:YES];
}

// ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    // dismiss people picker navigation view controller
    [self.viewControllerRef dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    // dismiss people picker navigation view controller
    [self.viewControllerRef dismissModalViewControllerAnimated:NO];
    
    // show address book new person view controller with dial phone and append person
    [self showABNewPersonViewController:self.dialNumber addedMode:APPEND_EXISTED appendedPerson:person];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    // required method that is never called in the perple-only-picking
    return NO;
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
            // first dial number enter
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
        
        // update previous dial phone
        [[_mPreviousDialPhone clear] appendString:_newText];
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

- (void)dialNumberButtonClicked:(UIButton *)dialNumberButton{
    // play dtmf sound
    [AudioServicesUtils playDTMFSound:((NSString *)[[NUMBERBUTTON_VALUES7IMAGES7DTMFSOUNDTONEIDS objectAtIndex:dialNumberButton.tag] objectForKey:NUMBERBUTTON_DTMFTONEID_KEY]).integerValue];
    
    // update dial number label text
    [self updateDialNumberLabelTextWithUpdateType:TEXT_APPEND string:[[NUMBERBUTTON_VALUES7IMAGES7DTMFSOUNDTONEIDS objectAtIndex:dialNumberButton.tag] objectForKey:NUMBERBUTTON_VALUE_KEY]];
}

- (void)addNewContact2ABWithPhoneNumber:(UIButton *)addNewContact2ABWithPhoneNumberButton{
    // check dial number
    if (nil == self.dialNumber || [@"" isEqualToString:self.dialNumber]) {
        // show address book new person view controller
        [self showABNewPersonViewController:nil addedMode:NEW_ADDED appendedPerson:NULL];
    }
    else {
        // define dial numbers add to new or existed contact select action sheet and show it
        UIActionSheet *_dialNumberAdd2NewOrExistedContactSelectActionSheet = [[UIActionSheet alloc] initWithContent:[NSArray arrayWithObjects:NSLocalizedString(@"dial numbers add to new contact button title", nil), NSLocalizedString(@"dial numbers add to existed contact button title", nil), nil] andTitleFormat:NSLocalizedString(@"dial numbers add to new or existed contact select actionSheet title format", nil), self.dialNumber];
        
        // set actionSheet processor and button clicked event selector
        _dialNumberAdd2NewOrExistedContactSelectActionSheet.processor = self;
        _dialNumberAdd2NewOrExistedContactSelectActionSheet.buttonClickedEventSelector = @selector(dialNumberAdd2NewOrExistedContactSelectActionSheet:clickedButtonAtIndex:);
        
        // show actionSheet
        [_dialNumberAdd2NewOrExistedContactSelectActionSheet showInView:addNewContact2ABWithPhoneNumberButton];
    }
}

- (void)dialNumberAdd2NewOrExistedContactSelectActionSheet:(UIActionSheet *)pActionSheet clickedButtonAtIndex:(NSInteger)pButtonIndex{
    // check select button index
    switch (pButtonIndex) {
        case 1:
            {
                // get address book people picker navigation view controller
                ABPeoplePickerNavigationController *_addressBookPeoplePickerNavigationViewController = [AddressBookUIUtils shareAddressBookUIUtils].addressBookPeoplePickerNavigationViewController;
                
                // set people picker navigation view controller navigation bar tint color
                _addressBookPeoplePickerNavigationViewController.navigationBar.tintColor = NAVIGATIONBAR_TINTCOLOR;
                
                // set its people picker delegate
                _addressBookPeoplePickerNavigationViewController.peoplePickerDelegate = self;
                
                // show contact from address book picker navigation view controller
                [self.viewControllerRef presentModalViewController:_addressBookPeoplePickerNavigationViewController animated:YES];
            }
            break;
            
        case 0:
        default:
            // show address book new person view controller with dial phone
            [self showABNewPersonViewController:self.dialNumber addedMode:NEW_ADDED appendedPerson:NULL];
            break;
    }
}

- (void)showABNewPersonViewController:(NSString *)phone addedMode:(AddDialPhone2ContactMode)mode appendedPerson:(ABRecordRef)appendedPerson{
    // get address book new person view controller
    ABNewPersonViewController *_addressBookNewPersonViewController = [AddressBookUIUtils shareAddressBookUIUtils].addressBookNewPersonViewController;
    
    // error
    CFErrorRef error = NULL;
    
    // check added mode
    switch (mode) {
        case APPEND_EXISTED:
            // check added phone and appended person
            if (nil != phone && ![@"" isEqualToString:phone] && NULL != appendedPerson) {
                return;
                
//                // create appended person phone number array copy
//                ABMultiValueRef _appendedPersonPhonesRef = ABMultiValueCreateMutableCopy(ABRecordCopyValue(appendedPerson, kABPersonPhoneProperty));
//                
//                // add the need added phone to phone array with mobile phone label
//                if (ABMultiValueAddValueAndLabel(_appendedPersonPhonesRef, (__bridge CFTypeRef)(phone), kABPersonPhoneMobileLabel, NULL)) {
//                    // add new phone array to the appended contact
//                    ABRecordSetValue(_appendedPersonPhonesRef, kABPersonPhoneProperty, _appendedPersonPhonesRef, &error);
//                }
//                
//                // set displayed person
//                _addressBookNewPersonViewController.displayedPerson = appendedPerson;
            }
            break;
            
        case NEW_ADDED:
        default:
            // check phone
            if (nil != phone && ![@"" isEqualToString:phone]) {
                // create new person
                ABRecordRef _newPerson = ABPersonCreate();
                
                // create new added phone array
                ABMultiValueRef _phones = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                
                // add the need added phone to phone array with mobile phone label
                if (ABMultiValueAddValueAndLabel(_phones, (__bridge CFTypeRef)(phone), kABPersonPhoneMobileLabel, NULL)) {
                    // add phone array to new contact
                    ABRecordSetValue(_newPerson, kABPersonPhoneProperty, _phones, &error);
                    
                    // release new added phones
                    CFRelease(_phones);
                }
                
                // set displayed person
                _addressBookNewPersonViewController.displayedPerson = _newPerson;
                
                // release new person
                CFRelease(_newPerson);
            }
            break;
    }
    
    // set its new person view delegate
    _addressBookNewPersonViewController.newPersonViewDelegate = self;
    
    // show add new contact to address book view controller
    [self.viewControllerRef presentModalViewController:[[UINavigationController alloc] initWithRootViewController:_addressBookNewPersonViewController andBarTintColor:NAVIGATIONBAR_TINTCOLOR] animated:YES];
}

- (void)callWithDialNumber:(UIButton *)dialButton{
    // get and check dial number
    NSString *_dialNumber = self.dialNumber;
    if (nil != _dialNumber && ![@"" isEqualToString:_dialNumber]) {        
        // set dial number label for clearing its text and previous dial phone for saving then generate new outgoing call with contact
        [[[[OutgoingCallGenerator alloc] initWithDependentView:dialButton andViewController:self.viewControllerRef] setDialNumberLabel4ClearingText7PreviousDialPhone4Saving:_mDialNumberLabel previousDialPhone:nil == _mPreviousDialPhone ? _mPreviousDialPhone = [[NSMutableString alloc] init] : [_mPreviousDialPhone clear]] generateNewOutgoingCall:_mDialNumberOwnnershipLabel.text phones:[NSArray arrayWithObject:_dialNumber]];
    }
    else if (nil != _mPreviousDialPhone && ![@"" isEqualToString:_mPreviousDialPhone]) {
        // update dial number label text if there is previous dial phone
        _mDialNumberLabel.text = _mPreviousDialPhone;
    }
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
