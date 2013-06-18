//
//  MoreTabContentView.h
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

// number button group row and column
#define NUMBERBUTTONGROUP_ROW 4
#define NUMBERBUTTONGROUP_COLUMN  3

// number button value, image and dtmf sound tone id key
#define NUMBERBUTTON_VALUE_KEY  @"value"
#define NUMBERBUTTON_IMAGE_KEY  @"image"
#define NUMBERBUTTON_DTMFTONEID_KEY @"dtmfToneId"

// number button values, images and dtmf sound tone ids array
#define NUMBERBUTTON_VALUES7IMAGES7DTMFSOUNDTONEIDS  [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"1", NUMBERBUTTON_VALUE_KEY, [UIImage imageNamed:@"img_dial_1_btn"], NUMBERBUTTON_IMAGE_KEY, @"1", NUMBERBUTTON_DTMFTONEID_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:@"2", NUMBERBUTTON_VALUE_KEY, [UIImage imageNamed:@"img_dial_2_btn"], NUMBERBUTTON_IMAGE_KEY, @"2", NUMBERBUTTON_DTMFTONEID_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:@"3", NUMBERBUTTON_VALUE_KEY, [UIImage imageNamed:@"img_dial_3_btn"], NUMBERBUTTON_IMAGE_KEY, @"3", NUMBERBUTTON_DTMFTONEID_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:@"4", NUMBERBUTTON_VALUE_KEY, [UIImage imageNamed:@"img_dial_4_btn"], NUMBERBUTTON_IMAGE_KEY, @"4", NUMBERBUTTON_DTMFTONEID_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:@"5", NUMBERBUTTON_VALUE_KEY, [UIImage imageNamed:@"img_dial_5_btn"], NUMBERBUTTON_IMAGE_KEY, @"5", NUMBERBUTTON_DTMFTONEID_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:@"6", NUMBERBUTTON_VALUE_KEY, [UIImage imageNamed:@"img_dial_6_btn"], NUMBERBUTTON_IMAGE_KEY, @"6", NUMBERBUTTON_DTMFTONEID_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:@"7", NUMBERBUTTON_VALUE_KEY, [UIImage imageNamed:@"img_dial_7_btn"], NUMBERBUTTON_IMAGE_KEY, @"7", NUMBERBUTTON_DTMFTONEID_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:@"8", NUMBERBUTTON_VALUE_KEY, [UIImage imageNamed:@"img_dial_8_btn"], NUMBERBUTTON_IMAGE_KEY, @"8", NUMBERBUTTON_DTMFTONEID_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:@"9", NUMBERBUTTON_VALUE_KEY, [UIImage imageNamed:@"img_dial_9_btn"], NUMBERBUTTON_IMAGE_KEY, @"9", NUMBERBUTTON_DTMFTONEID_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:@"*", NUMBERBUTTON_VALUE_KEY, [UIImage imageNamed:@"img_dial_star_btn"], NUMBERBUTTON_IMAGE_KEY, @"10", NUMBERBUTTON_DTMFTONEID_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:@"0", NUMBERBUTTON_VALUE_KEY, [UIImage imageNamed:@"img_dial_0_btn"], NUMBERBUTTON_IMAGE_KEY, @"0", NUMBERBUTTON_DTMFTONEID_KEY, nil], [NSDictionary dictionaryWithObjectsAndKeys:@"#", NUMBERBUTTON_VALUE_KEY, [UIImage imageNamed:@"img_dial_pound_btn"], NUMBERBUTTON_IMAGE_KEY, @"11", NUMBERBUTTON_DTMFTONEID_KEY, nil], nil]

@interface DialTabContentView : UIView <UIViewGestureRecognizerDelegate, ABNewPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate> {
    // previous dial phone
    NSMutableString *_mPreviousDialPhone;
    
    // present subviews
    // dial number and its ownnership label
    // subview dial number label
    UILabel *_mDialNumberLabel;
    // subview dial number ownnership label
    UILabel *_mDialNumberOwnnershipLabel;
    
    // dial number button grid view
    // subview zero dial number button
    UIButton *_mZeroDialNumberButton;
    
    // controller view
    // subview clear dial number button
    UIButton *_mClearDialNumberButton;
}

@end
