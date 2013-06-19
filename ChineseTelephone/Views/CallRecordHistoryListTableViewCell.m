//
//  CallRecordHistoryListTableViewCell.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-19.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "CallRecordHistoryListTableViewCell.h"

// tableViewCell margin
#define MARGIN  8.0
// tableViewCell padding
#define PADDING 4.0

// cell call type imageView width and height
#define CALLTYPEIMGVIEW_WIDTH7HEIGHT  36.0
// cell call name label height
#define CALLNAMELABEL_HEIGHT 22.0
// cell call phone label height
#define CALLPHONELABEL_HEIGHT   18.0
// cell call created date label width
#define CALLCREATEDDATELABEL_WIDTH  80.0

// cell created date label text color
#define CALLCREATEDDATELABEL_TEXTCOLOR  [UIColor colorWithIntegerRed:36 integerGreen:112 integerBlue:216 alpha:1.0]

// accessory button view width
#define ACCESSORYBUTTONVIEW_WIDTH   (1.2 * MARGIN + 30.0)

@implementation CallRecordHistoryListTableViewCell

@synthesize callType = _mCallType;
@synthesize callName = _mCallName;
@synthesize callPhone = _mCallPhone;
@synthesize callCreatedDate = _mCallCreatedDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // init contentView subviews
        // call record call type image view
        _mCallTypeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN / 2, MARGIN, CALLTYPEIMGVIEW_WIDTH7HEIGHT, CALLTYPEIMGVIEW_WIDTH7HEIGHT)];
        
        // set cell content view background color clear
        _mCallTypeImgView.backgroundColor = [UIColor clearColor];
        
        // add to content view
        [self.contentView addSubview:_mCallTypeImgView];
        
        // call record call name label
        _mCallNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mCallTypeImgView.frame.origin.x + _mCallTypeImgView.frame.size.width + 3 * PADDING, MARGIN / 2, self.frame.size.width - MARGIN - (_mCallTypeImgView.frame.size.width + 3 * PADDING + CALLCREATEDDATELABEL_WIDTH + ACCESSORYBUTTONVIEW_WIDTH), CALLNAMELABEL_HEIGHT)];
        
        // set text font
        _mCallNameLabel.font = [UIFont systemFontOfSize:17.0];
        
        // set cell content view background color clear
        _mCallNameLabel.backgroundColor = [UIColor clearColor];
        
        // add to content view
        [self.contentView addSubview:_mCallNameLabel];
        
        // call record call phone label
        _mCallPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mCallNameLabel.frame.origin.x, _mCallNameLabel.frame.origin.y + _mCallNameLabel.frame.size.height + PADDING, _mCallNameLabel.frame.size.width, CALLPHONELABEL_HEIGHT)];
        
        // set text color and font
        _mCallPhoneLabel.textColor = [UIColor lightGrayColor];
        _mCallPhoneLabel.font = [UIFont systemFontOfSize:14.0];
        
        // set cell content view background color clear
        _mCallPhoneLabel.backgroundColor = [UIColor clearColor];
        
        // add to content view
        [self.contentView addSubview:_mCallPhoneLabel];
        
        // call record call created date label
        _mCallCreatedDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - MARGIN / 2 - ACCESSORYBUTTONVIEW_WIDTH - CALLCREATEDDATELABEL_WIDTH, MARGIN, CALLCREATEDDATELABEL_WIDTH, CALLTYPEIMGVIEW_WIDTH7HEIGHT)];
        
        // set text color and font
        _mCallCreatedDateLabel.textColor = CALLCREATEDDATELABEL_TEXTCOLOR;
        _mCallCreatedDateLabel.textAlignment = NSTextAlignmentRight;
        _mCallCreatedDateLabel.font = [UIFont systemFontOfSize:16.0];
        
        // set cell content view background color clear
        _mCallCreatedDateLabel.backgroundColor = [UIColor clearColor];
        
        // add to content view
        [self.contentView addSubview:_mCallCreatedDateLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCallType:(CallRecordCallType)callType{
    // set call type
    _mCallType = callType;
    
    // define call type image view image
    UIImage *_callTypeImage;
    
    // check call type and get its image
    switch (_mCallType) {
        case INCOMINGCALL:
            _callTypeImage = nil;
            break;
            
        case MISSED_INCOMINGCALL:
            _callTypeImage = nil;
            break;
            
        case OUTGOINGCALL:
        case CALLBACKCALL:
        default:
            _callTypeImage = [UIImage imageNamed:@"img_outgoingcall"];
            break;
    }
    
    // set call type image view image
    _mCallTypeImgView.image = _callTypeImage;
}

- (void)setCallName:(NSString *)callName{
    // set call name
    _mCallName = nil == callName || [@"" isEqualToString:callName] ? NSLocalizedString(@"call record without call name", nil) : callName;
    
    // set call name label text
    _mCallNameLabel.text = _mCallName;
}

- (void)setCallPhone:(NSString *)callPhone{
    // set call phone and call phone label text
    _mCallPhoneLabel.text = _mCallPhone = callPhone;
}

- (void)setCallCreatedDate:(NSDate *)callCreatedDate{
    // set call created date
    _mCallCreatedDate = callCreatedDate;
    
    // get local current date
    //NSDate *_localCurrentDate = [NSDate date];
    
    // define call created date format
    NSDateFormatter *_dateFormat = [[NSDateFormatter alloc] init];
    [_dateFormat setDateFormat:@"yy-MM-dd"];
    [_dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    
    // set call created date label text
    _mCallCreatedDateLabel.text = [_dateFormat stringFromDate:callCreatedDate];
}

+ (CGFloat)cellHeight{
    // set tableViewCell default height
    return 2 * /*top margin*/MARGIN + /*call type image view height*/CALLTYPEIMGVIEW_WIDTH7HEIGHT;
}

@end
