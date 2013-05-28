//
//  ContactListTableViewCell.h
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

@interface ContactListTableViewCell : UITableViewCell {
    // contact photo imageView photo image
    UIImage *_mPhotoImg;
    // contact display name label text
    NSString *_mDisplayName;
    // contact full name array
    NSArray *_mFullNames;
    // contact phone numbers array
    NSArray *_mPhoneNumbersArray;
    
    // phone number matching index array
    NSArray *_mPhoneNumberMatchingIndexs;
    // name matching index array
    NSArray *_mNameMatchingIndexs;
    
    // contact photo imageView
    UIImageView *_mPhotoImgView;
    // contact display name label
    UIAttributedLabel *_mDisplayNameLabel;
    // contact phone numbers display label
    UILabel *_mPhoneNumbersLabel;
    // contact phone numbers display attributed label parent view
    UIView *_mPhoneNumbersAttributedLabelParentView;
}

@property (nonatomic, retain) UIImage *photoImg;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSArray *fullNames;
@property (nonatomic, retain) NSArray *phoneNumbersArray;

@property (nonatomic, retain) NSArray *phoneNumberMatchingIndexs;
@property (nonatomic, retain) NSArray *nameMatchingIndexs;

// get the height of the contacts list tableViewCell with contactBean object
+ (CGFloat)cellHeightWithContact:(ContactBean *)pContact;

@end
