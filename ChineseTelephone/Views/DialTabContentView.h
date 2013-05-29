//
//  MoreTabContentView.h
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialTabContentView : UIView {
    // present subviews
    // subview dial number label
    UILabel *_mDialNumberLabel;
    // subview dial number ownnership label
    UILabel *_mDialNumberOwnnershipLabel;
    
    // subview dial button grid view
    UIView *_mDialButtonGridView;
    // subview controller view
    UIView *_mControllerView;
}

@end
