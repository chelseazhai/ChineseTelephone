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
        
        // init dial number ownnership label
        _mDialNumberOwnnershipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_dialNumber7OwnnershipView.bounds.origin.x, _dialNumber7OwnnershipView.bounds.origin.y + FILL_PARENT * (3 / 4.0), FILL_PARENT, FILL_PARENT * (1 / 4.0))];
        
        // set its attributes
        _mDialNumberOwnnershipLabel.textColor = [UIColor whiteColor];
        _mDialNumberOwnnershipLabel.textAlignment = NSTextAlignmentCenter;
        _mDialNumberOwnnershipLabel.text = @"翟绍虎";
        _mDialNumberOwnnershipLabel.font = [UIFont systemFontOfSize:14.0];
        _mDialNumberOwnnershipLabel.backgroundColor = [UIColor clearColor];
        
        // add dial phone and its ownnership label as subviews
        [_dialNumber7OwnnershipView addSubview:_mDialNumberLabel];
        [_dialNumber7OwnnershipView addSubview:_mDialNumberOwnnershipLabel];
        
        // init dial button grid view
        _mDialButtonGridView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _dialNumber7OwnnershipView.bounds.size.height, FILL_PARENT, FILL_PARENT * (DIALBUTTONGRIDVIEW_WEIGHT / TOTALSUMWEIGHT))];
        
        _mDialButtonGridView.backgroundColor = [UIColor greenColor];
        
        // init controller view
        _mControllerView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + _dialNumber7OwnnershipView.bounds.size.height + _mDialButtonGridView.bounds.size.height, FILL_PARENT, FILL_PARENT * (CONTROLLERVIEW_WEIGHT / TOTALSUMWEIGHT))];
        
        _mControllerView.backgroundColor = [UIColor blueColor];
        
        // add dial phone and its ownnership view, dial button grid view and controller view as subviews
        [self addSubview:_dialNumber7OwnnershipView];
        [self addSubview:_mDialButtonGridView];
        [self addSubview:_mControllerView];
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

@end
