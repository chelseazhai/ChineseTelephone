//
//  CallRecordDetailInfoView.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-19.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "CallRecordDetailInfoView.h"

#import <CommonToolkit/CommonToolkit.h>

#import <objc/message.h>

#import "SipUtils.h"

#import <QuartzCore/QuartzCore.h>

// subview weight and total sum weight
#define MARGIN_TOP7BOTTOM_WEIGHT    4
#define MARGIN_LEFT7RIGHT_WEIGHT    3
#define CALLCONTACTVIEW_WEIGHT  22
#define CALLSTATUSVIEW_WEIGHT   17
#define CONTROLLERVIEW_WEIGHT   55
#define TOTALSUMWEIGHT  100.0

// call contact photo imageView width and height
#define CALLCONTACTPHOTOIMAGEVIEW_WIDTH7HEIGHT  88.0

// call contact default photo
#define CALLCONTACTDEFAULTPHOTO [UIImage imageNamed:@"img_default_gray_avatar"]

// call contact group view subview weight and total sum weight
#define CALLCONTACTVIEW_MARGIN_TOP7BOTTOM_WEIGHT    1
#define CALLCONTACTPHOTOIMAGEVIEW_WIDTHWEIGHT   4
#define CALLNAMELABEL_WIDTHWEIGHT   6
#define CALLCONTACT_TOTALSUMWEIGHT   10.0

// call name label text font size
#define CALLNAMELABELTEXTFONTSIZE   22.0

// call status group view subview weight and total sum weight
#define CALLSTATUSVIEW_MARGIN_TOP_WEIGHT    1
#define CALLTYPENAMELABEL_WIDTHWEIGHT   4
#define CALLCREATEDDATEDAYLABEL_WIDTHWEIGHT 6
#define CALLCREATEDDATETIMELABEL_WIDTHWEIGHT    2
#define CALLDURATION6RESULTLABEL_WIDTHWEIGHT    8
#define CALLSTATUS_TOTALSUMWEIGHT   10.0

// call record controller name and action selector key
#define CALLRECORDCONTROLLER_NAME_KEY   @"name"
#define CALLRECORDCONTROLLER_ACTIONSELECTOR_KEY @"actionSelector"

// call record controller names and action selectors array
#define CALLRECORDCONTROLLER_NAMES7ACTIONSELECTORS  [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:NSLocalizedString(@"call record direct call the call phone", nil), _mCallPhone], CALLRECORDCONTROLLER_NAME_KEY, NSStringFromSelector(@selector(makeDirectCall)), CALLRECORDCONTROLLER_ACTIONSELECTOR_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:NSLocalizedString(@"call record callback call the call phone", nil), _mCallPhone], CALLRECORDCONTROLLER_NAME_KEY, NSStringFromSelector(@selector(makeCallbackCall)), CALLRECORDCONTROLLER_ACTIONSELECTOR_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:NSLocalizedString(@"call record sms the call phone", nil), _mCallPhone], CALLRECORDCONTROLLER_NAME_KEY, NSStringFromSelector(@selector(sendShortMessage)), CALLRECORDCONTROLLER_ACTIONSELECTOR_KEY, nil], nil]

// text font size
#define TEXTFONTSIZE    16.0

// seconds per minute
#define SECONDS_PER_MINUTE  60L

@interface CallRecordDetailInfoView ()

// direct call the call phone of the call record
- (void)makeDirectCall;

// callback call the call phone of the call record
- (void)makeCallbackCall;

// send short message to the call phone of the call record
- (void)sendShortMessage;

@end

@implementation CallRecordDetailInfoView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        // Initialization code
        // set title
        self.title = NSLocalizedString(@"call record detail info view navigation title", nil);
        
        // create and init subviews
        // init call record call contact group view
        UIView *_callContactGroupView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + FILL_PARENT * (MARGIN_LEFT7RIGHT_WEIGHT / TOTALSUMWEIGHT), self.bounds.origin.y + FILL_PARENT * (MARGIN_TOP7BOTTOM_WEIGHT / TOTALSUMWEIGHT), FILL_PARENT * ((TOTALSUMWEIGHT - 2 * MARGIN_LEFT7RIGHT_WEIGHT) / TOTALSUMWEIGHT), FILL_PARENT * (CALLCONTACTVIEW_WEIGHT / TOTALSUMWEIGHT))];
        
        // init call contact phone image view
        _mCallContactPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_callContactGroupView.bounds.origin.x, _callContactGroupView.bounds.origin.x, CALLCONTACTPHOTOIMAGEVIEW_WIDTH7HEIGHT, CALLCONTACTPHOTOIMAGEVIEW_WIDTH7HEIGHT)];
        
        // set content mode
        _mCallContactPhotoImageView.contentMode = UIViewContentModeCenter;
        
        // init call name label
        _mCallNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_callContactGroupView.bounds.origin.x + FILL_PARENT * (CALLCONTACTPHOTOIMAGEVIEW_WIDTHWEIGHT / CALLCONTACT_TOTALSUMWEIGHT), _callContactGroupView.bounds.origin.y, FILL_PARENT * (CALLNAMELABEL_WIDTHWEIGHT / CALLCONTACT_TOTALSUMWEIGHT), FILL_PARENT)];
        
        // set its attributes
        _mCallNameLabel.font = [UIFont boldSystemFontOfSize:CALLNAMELABELTEXTFONTSIZE];
        _mCallNameLabel.backgroundColor = [UIColor clearColor];
        
        // add call contact photo image view and call name label as subviews of call status group view
        [_callContactGroupView addSubview:_mCallContactPhotoImageView];
        [_callContactGroupView addSubview:_mCallNameLabel];
        
        // init call record call status group view
        UIView *_callStatusGroupView = [[UIView alloc] initWithFrame:CGRectMake(_callContactGroupView.frame.origin.x, _callContactGroupView.frame.origin.y + _callContactGroupView.bounds.size.height, _callContactGroupView.bounds.size.width, FILL_PARENT * (CALLSTATUSVIEW_WEIGHT / TOTALSUMWEIGHT))];
        
        // init call type name label
        _mCallTypeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_callStatusGroupView.bounds.origin.x, _callStatusGroupView.bounds.origin.y + FILL_PARENT * (CALLSTATUSVIEW_MARGIN_TOP_WEIGHT / CALLSTATUS_TOTALSUMWEIGHT), FILL_PARENT * (CALLTYPENAMELABEL_WIDTHWEIGHT / CALLSTATUS_TOTALSUMWEIGHT), FILL_PARENT / 2.0)];
        
        // set its attributes
        _mCallTypeNameLabel.font = [UIFont systemFontOfSize:TEXTFONTSIZE];
        _mCallTypeNameLabel.backgroundColor = [UIColor clearColor];
        
        // init call created date day label
        _mCallCreatedDateDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(_callStatusGroupView.bounds.origin.x + _mCallTypeNameLabel.bounds.size.width, _callStatusGroupView.bounds.origin.y + FILL_PARENT * (CALLSTATUSVIEW_MARGIN_TOP_WEIGHT / CALLSTATUS_TOTALSUMWEIGHT), FILL_PARENT * (CALLCREATEDDATEDAYLABEL_WIDTHWEIGHT / CALLSTATUS_TOTALSUMWEIGHT), FILL_PARENT / 2.0)];
        
        // set its attributes
        _mCallCreatedDateDayLabel.textAlignment = NSTextAlignmentRight;
        _mCallCreatedDateDayLabel.font = [UIFont systemFontOfSize:TEXTFONTSIZE];
        _mCallCreatedDateDayLabel.backgroundColor = [UIColor clearColor];
        
        // init call created date time label
        _mCallCreatedDateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_callStatusGroupView.bounds.origin.x, _callStatusGroupView.bounds.origin.y + FILL_PARENT / 2, FILL_PARENT * (CALLCREATEDDATETIMELABEL_WIDTHWEIGHT / CALLSTATUS_TOTALSUMWEIGHT), FILL_PARENT / 2.0)];
        
        // set its attributes
        _mCallCreatedDateTimeLabel.textColor = [UIColor darkGrayColor];
        _mCallCreatedDateTimeLabel.font = [UIFont systemFontOfSize:TEXTFONTSIZE];
        _mCallCreatedDateTimeLabel.backgroundColor = [UIColor clearColor];
        
        // init call duration or result label
        _mCallDuration6ResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(_callStatusGroupView.bounds.origin.x + _mCallCreatedDateTimeLabel.bounds.size.width, _callStatusGroupView.bounds.origin.y + FILL_PARENT / 2, FILL_PARENT * (CALLDURATION6RESULTLABEL_WIDTHWEIGHT / CALLSTATUS_TOTALSUMWEIGHT), FILL_PARENT / 2.0)];
        
        // set its attributes
        _mCallDuration6ResultLabel.textColor = [UIColor darkGrayColor];
        _mCallDuration6ResultLabel.font = [UIFont systemFontOfSize:TEXTFONTSIZE];
        _mCallDuration6ResultLabel.backgroundColor = [UIColor clearColor];
        
        // add call type name, call created date day, time and call duration or result label as subviews of call status group view
        [_callStatusGroupView addSubview:_mCallTypeNameLabel];
        [_callStatusGroupView addSubview:_mCallCreatedDateDayLabel];
        [_callStatusGroupView addSubview:_mCallCreatedDateTimeLabel];
        [_callStatusGroupView addSubview:_mCallDuration6ResultLabel];
        
        // init call record controller group view
        UITableView *_controllerGroupView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, _callContactGroupView.frame.origin.y + FILL_PARENT * ((TOTALSUMWEIGHT - CONTROLLERVIEW_WEIGHT) / TOTALSUMWEIGHT), FILL_PARENT, FILL_PARENT * (CONTROLLERVIEW_WEIGHT / TOTALSUMWEIGHT)) style:UITableViewStyleGrouped];
        
        // clear controller group view background
        _controllerGroupView.backgroundView = nil;
        
        // set call record controller list table view dataSource and delegate
        _controllerGroupView.dataSource = self;
        _controllerGroupView.delegate = self;
        
        // add call record contact, call status and controller group view as subviews
        [self addSubview:_callContactGroupView];
        [self addSubview:_callStatusGroupView];
        [self addSubview:_controllerGroupView];
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

- (void)setCallRecord:(CallRecordBean *)callRecord{
    // save call name and phone
    _mCallName = callRecord.name;
    _mCallPhone = callRecord.phone;
    
    // set call contact photo image view image and call name label text
    if (nil == callRecord.name || [@"" isEqualToString:callRecord.name]) {
        // set call contact photo image view default image
        _mCallContactPhotoImageView.image = CALLCONTACTDEFAULTPHOTO;
        
        // recover photo image view layer
        _mCallContactPhotoImageView.layer.cornerRadius = 0.0;
        _mCallContactPhotoImageView.layer.masksToBounds = NO;
        
        // set call name label text
        _mCallNameLabel.text = NSLocalizedString(@"call record without call name", nil);
    }
    else {
        // set call contact photo image view image
        _mCallContactPhotoImageView.image = CALLCONTACTDEFAULTPHOTO;
        
        // set photo image view layer
        _mCallContactPhotoImageView.layer.cornerRadius = 4.0;
        _mCallContactPhotoImageView.layer.masksToBounds = YES;
        
        // set call name label text
        _mCallNameLabel.text = callRecord.name;
    }
    
    // define call created date format
    NSDateFormatter *_dateFormat = [[NSDateFormatter alloc] init];
    [_dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    
    // set call type name, call created date day, time and duration or result label text
    _mCallTypeNameLabel.text = [CallRecordBean getCallTypeName:callRecord.callType];
    
    [_dateFormat setDateFormat:NSLocalizedString(@"call record call created date format string", nil)];
    _mCallCreatedDateDayLabel.text = [_dateFormat stringFromDate:callRecord.date];
    
    [_dateFormat setDateFormat:@"HH:mm"];
    _mCallCreatedDateTimeLabel.text = [_dateFormat stringFromDate:callRecord.date];
    
    // define call duration or result string
    NSString *_callDuration6ResultString;
    
    // check call type and duration and set call duration or result string
    switch (callRecord.callType) {
        case INCOMINGCALL:
            //
            break;
            
        case MISSED_INCOMINGCALL:
            _callDuration6ResultString = NSLocalizedString(@"call record incoming call missed result", nil);
            break;
            
        case CALLBACKCALL:
            _callDuration6ResultString = NSLocalizedString(@"call record outgoing call callback result", nil);
            break;
            
        case OUTGOINGCALL:
        default:
            // check call duration
            if (0 == callRecord.duration) {
                _callDuration6ResultString = NSLocalizedString(@"call record outgoing call canceled result", nil);
            }
            else if (0 <= callRecord.duration) {
                // check call record duration
                if (callRecord.duration < SECONDS_PER_MINUTE) {
                    _callDuration6ResultString = [NSString stringWithFormat:NSLocalizedString(@"call record call duration seconds", nil), (int)callRecord.duration];
                }
                else {
                    _callDuration6ResultString = [NSString stringWithFormat:NSLocalizedString(@"call record call duration minutes", nil), 0 == callRecord.duration % SECONDS_PER_MINUTE ? callRecord.duration / SECONDS_PER_MINUTE : callRecord.duration / SECONDS_PER_MINUTE + 1];
                }
            }
            else {
                _callDuration6ResultString = NSLocalizedString(@"call record outgoing call failed result", nil);
            }
            break;
    }
    
    // set call duration or result label text
    _mCallDuration6ResultLabel.text = _callDuration6ResultString;
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [CALLRECORDCONTROLLER_NAMES7ACTIONSELECTORS count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Call record controller cell";
    
    // get contact list table view cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    _cell.textLabel.text = [[CALLRECORDCONTROLLER_NAMES7ACTIONSELECTORS objectAtIndex:indexPath.row] objectForKey:CALLRECORDCONTROLLER_NAME_KEY];
    _cell.textLabel.textAlignment = NSTextAlignmentCenter;
    _cell.textLabel.font = [UIFont systemFontOfSize:TEXTFONTSIZE];
    
    return _cell;
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // send message to its processor
    objc_msgSend(self, NSSelectorFromString([[CALLRECORDCONTROLLER_NAMES7ACTIONSELECTORS objectAtIndex:indexPath.row] objectForKey:CALLRECORDCONTROLLER_ACTIONSELECTOR_KEY]));
    
    // deselect the selected row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// inner extension
- (void)makeDirectCall{
    // make direct call with call name and phone
    [SipUtils makeSipVoiceCall:_mCallName phone:_mCallPhone callMode:DIRECT_CALL fromViewController:self.viewControllerRef];
}

- (void)makeCallbackCall{
    // make callback call with call name and phone
    [SipUtils makeSipVoiceCall:_mCallName phone:_mCallPhone callMode:CALLBACK fromViewController:self.viewControllerRef];
}

- (void)sendShortMessage{
    NSLog(@"sendShortMessage");
    
    //
}

@end
