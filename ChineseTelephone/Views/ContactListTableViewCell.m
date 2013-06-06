//
//  ContactListTableViewCell.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ContactListTableViewCell.h"

#import <QuartzCore/QuartzCore.h>

// contact default photo
#define CONTACTDEFAULTPHOTO [UIImage imageNamed:@"img_default_avatar"]

// tableViewCell margin
#define MARGIN  8.0
// tableViewCell padding
#define PADDING 4.0

// cell photo imageView width and height
#define PHOTOIMGVIEW_WIDTH7HEIGHT  44.0
// cell display name label height
#define DISPLAYNAMELABEL_HEIGHT 22.0
// cell phone numbers label default height
#define PHONENUMBERSLABEL_DEFAULTHEIGHT   18.0

// matching text color
#define MATCHINGTEXTCOLOR   [UIColor blueColor]

@implementation ContactListTableViewCell

@synthesize photoImg = _mPhotoImg;
@synthesize displayName = _mDisplayName;
@synthesize fullNames = _mFullNames;
@synthesize phoneNumbersArray = _mPhoneNumbersArray;

@synthesize phoneNumberMatchingIndexs = _mPhoneNumberMatchingIndexs;
@synthesize nameMatchingIndexs = _mNameMatchingIndexs;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // init contentView subviews
        // contact photo image view
        _mPhotoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, PHOTOIMGVIEW_WIDTH7HEIGHT, PHOTOIMGVIEW_WIDTH7HEIGHT)];
        
        // set cell content view background color clear
        _mPhotoImgView.backgroundColor = [UIColor clearColor];
        
        // add to content view
        [self.contentView addSubview:_mPhotoImgView];
        
        // contact display name label
        _mDisplayNameLabel = [[UIAttributedLabel alloc] initWithFrame:CGRectMake(_mPhotoImgView.frame.origin.x + _mPhotoImgView.frame.size.width + 4 * PADDING, MARGIN, self.frame.size.width - 2 * MARGIN - (_mPhotoImgView.frame.size.width + 4 * PADDING), DISPLAYNAMELABEL_HEIGHT)];
        
        // set text font
        _mDisplayNameLabel.font = [UIFont boldSystemFontOfSize:22.0];
        
        // set cell content view background color clear
        _mDisplayNameLabel.backgroundColor = [UIColor clearColor];
        
        // add to content view
        [self.contentView addSubview:_mDisplayNameLabel];
        
        // contact phone numbers label
        _mPhoneNumbersLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mDisplayNameLabel.frame.origin.x, _mDisplayNameLabel.frame.origin.y + _mDisplayNameLabel.frame.size.height + PADDING, _mDisplayNameLabel.frame.size.width, PHONENUMBERSLABEL_DEFAULTHEIGHT)];
        
        // set text color and font
        _mPhoneNumbersLabel.textColor = [UIColor lightGrayColor];
        _mPhoneNumbersLabel.font = [UIFont systemFontOfSize:14.0];
        
        // set cell content view background color clear
        _mPhoneNumbersLabel.backgroundColor = [UIColor clearColor];
        
        // add to content view
        [self.contentView addSubview:_mPhoneNumbersLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPhotoImg:(UIImage *)photoImg{
    // set photo image
    _mPhotoImg = photoImg;
    
    // check photo image
    if (photoImg) {
        // set photo image view image
        _mPhotoImgView.image = photoImg;
        
        // set photo image view layer
        _mPhotoImgView.layer.cornerRadius = 4.0;
        _mPhotoImgView.layer.masksToBounds = YES;
    }
    else {
        // set photo image view default image
        _mPhotoImgView.image = CONTACTDEFAULTPHOTO;
        
        // recover photo image view layer
        _mPhotoImgView.layer.cornerRadius = 0.0;
        _mPhotoImgView.layer.masksToBounds = NO;
    }
}

- (void)setDisplayName:(NSString *)displayName{
    // set display name text
    _mDisplayName = displayName;
    
    // set display name label text
    //_mDisplayNameLabel.text = displayName;
    NSMutableAttributedString *_attributedDisplayName = [NSMutableAttributedString attributedStringWithString:displayName];
    // set font
    [_attributedDisplayName setFont:[UIFont boldSystemFontOfSize:18.0]];
    // set display name attributed label attributed text
    _mDisplayNameLabel.attributedText = _attributedDisplayName;
}

- (void)setPhoneNumbersArray:(NSArray *)phoneNumbersArray{
    // set phone number array
    _mPhoneNumbersArray = phoneNumbersArray;
    
    // set phone number label number of lines
    _mPhoneNumbersLabel.numberOfLines = ([phoneNumbersArray count] == 0) ? 1 : [phoneNumbersArray count];
    
    // update phone number label frame
    _mPhoneNumbersLabel.frame = CGRectMake(_mDisplayNameLabel.frame.origin.x, _mDisplayNameLabel.frame.origin.y + _mDisplayNameLabel.frame.size.height + PADDING, _mDisplayNameLabel.frame.size.width, PHONENUMBERSLABEL_DEFAULTHEIGHT * _mPhoneNumbersLabel.numberOfLines);
    
    // set phone number label text
    _mPhoneNumbersLabel.text = [phoneNumbersArray getContactPhoneNumbersDisplayTextWithStyle:vertical];
}

- (void)setNameMatchingIndexs:(NSArray *)nameMatchingIndexs{
    // set name matching index array
    _mNameMatchingIndexs = nameMatchingIndexs;
    
    // process name matching index array
    if (nameMatchingIndexs) {
        // generate attributed string with display name
        NSMutableAttributedString *_attributedDisplayName = [NSMutableAttributedString attributedStringWithString:_mDisplayName];
        // set font
        [_attributedDisplayName setFont:[UIFont boldSystemFontOfSize:18.0]];
        
        // set attributed display name text color
        /*
         for (NSNumber *_index in nameMatchingIndexs) {
         [_attributedDisplayName setTextColor:MATCHINGTEXTCOLOR range:[_mDisplayName rangeOfString:[[_mDisplayName nameArraySeparatedByCharacter] objectAtIndex:_index.integerValue]]];
         }
         */
        for (NSDictionary *_indexDic in nameMatchingIndexs) {
            // get matching name character index
            NSInteger _nameMatchingCharIndex = 0;
            for (NSInteger _index = 0; _index < [_mFullNames count]; _index++) {
                if (_index < ((NSNumber *)[_indexDic.allKeys objectAtIndex:0]).integerValue && [[_mFullNames objectAtIndex:_index] isEqualToString:[[_mDisplayName nameArraySeparatedByCharacter] objectAtIndex:((NSNumber *)[_indexDic.allKeys objectAtIndex:0]).integerValue]]) {
                    _nameMatchingCharIndex += 1;
                }
            }
            
            // get range of name matching
            NSRange _range = NSRangeFromString([[_mDisplayName rangesOfString:[[_mDisplayName nameArraySeparatedByCharacter] objectAtIndex:((NSNumber *)[_indexDic.allKeys objectAtIndex:0]).integerValue]] objectAtIndex:_nameMatchingCharIndex]);
            
            [_attributedDisplayName setTextColor:MATCHINGTEXTCOLOR range:NSMakeRange(_range.location, NAME_CHARACTER_FULLMATCHING.integerValue == ((NSNumber *)[_indexDic.allValues objectAtIndex:0]).integerValue ? _range.length : ((NSNumber *)[_indexDic.allValues objectAtIndex:0]).integerValue)];
        }
        
        // set display name label attributed text
        _mDisplayNameLabel.attributedText = _attributedDisplayName;
    }
    else {
        // reset display name label text
        self.displayName = _mDisplayName;
    }
}

- (void)setPhoneNumberMatchingIndexs:(NSArray *)phoneNumberMatchingIndexs{
    // set phone number matching index array
    _mPhoneNumberMatchingIndexs = phoneNumberMatchingIndexs;
    
    // process phone numbers matching index array
    if (phoneNumberMatchingIndexs) {
        // set phone number attributed label parent view
        if (_mPhoneNumbersAttributedLabelParentView) {
            for (UIView *_view in _mPhoneNumbersAttributedLabelParentView.subviews) {
                [_view removeFromSuperview];
            }
            [_mPhoneNumbersAttributedLabelParentView removeFromSuperview];
        }
        _mPhoneNumbersAttributedLabelParentView = [[UIView alloc] initWithFrame:_mPhoneNumbersLabel.frame];
        
        // process each phone number
        for (NSInteger _index = 0; _index < [_mPhoneNumbersArray count]; _index++) {
            // generate attributed string with phone number
            NSMutableAttributedString *_attributedPhoneNumber = [NSMutableAttributedString attributedStringWithString:[_mPhoneNumbersArray objectAtIndex:_index]];
            // set font
            [_attributedPhoneNumber setFont:[UIFont systemFontOfSize:14.0]];
            // set attributed phone number text color
            [_attributedPhoneNumber setTextColor:[UIColor lightGrayColor]];
            if ([phoneNumberMatchingIndexs objectAtIndex:_index] && [[phoneNumberMatchingIndexs objectAtIndex:_index] count] > 0) {
                for (NSNumber *__index in [phoneNumberMatchingIndexs objectAtIndex:_index]) {
                    [_attributedPhoneNumber setTextColor:MATCHINGTEXTCOLOR range:NSMakeRange(__index.integerValue, 1)];
                }
            }
            
            // generate each phone number attributed label and add to phone number attributed label parent view
            @autoreleasepool {
                UIAttributedLabel *_phoneNumberAttributedLabel = [[UIAttributedLabel alloc] initWithFrame:CGRectMake(0.0, _index * PHONENUMBERSLABEL_DEFAULTHEIGHT, _mPhoneNumbersLabel.frame.size.width, PHONENUMBERSLABEL_DEFAULTHEIGHT)];
                // set phone number attributed label attributed text
                _phoneNumberAttributedLabel.attributedText = _attributedPhoneNumber;
                // add to phone number attributed label parent view
                [_mPhoneNumbersAttributedLabelParentView addSubview:_phoneNumberAttributedLabel];
            }
        }
        
        // hide phone number label and add phone number attributed label parent view to cell content view
        _mPhoneNumbersLabel.hidden = YES;
        [self.contentView addSubview:_mPhoneNumbersAttributedLabelParentView];
    }
    else {
        // show phone number label and remove phone number attributed label parent view
        _mPhoneNumbersLabel.hidden = NO;
        for (UIView *_view in _mPhoneNumbersAttributedLabelParentView.subviews) {
            [_view removeFromSuperview];
        }
        [_mPhoneNumbersAttributedLabelParentView removeFromSuperview];
    }
}

+ (CGFloat)cellHeightWithContact:(ContactBean *)pContact{
    // set tableViewCell default height
    CGFloat _ret = 2 * /*top margin*/MARGIN + /*photo image view height*/PHOTOIMGVIEW_WIDTH7HEIGHT;
    
    // check phone numbers
    if (pContact.phoneNumbers && [pContact.phoneNumbers count] > 1) {
        _ret += ([pContact.phoneNumbers count] - 1) * PHONENUMBERSLABEL_DEFAULTHEIGHT;
    }
    
    return _ret;
}

@end
