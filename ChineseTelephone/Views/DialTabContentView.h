//
//  MoreTabContentView.h
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonToolkit/CommonToolkit.h>

@interface DialTabContentView : UIView <UIViewGestureRecognizerDelegate> {
    // present subviews
    // dial number and its ownnership label
    // subview dial number label
    UILabel *_mDialNumberLabel;
    // subview dial number ownnership label
    UILabel *_mDialNumberOwnnershipLabel;
    
    // dial button grid view
    // subview zero dial button
    UIButton *_mZeroDialButton;
    
    // controller view
    // subview clear dial number button
    UIButton *_mClearDialNumberButton;
}

@end
