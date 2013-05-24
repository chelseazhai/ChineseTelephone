//
//  CallRecordHistoryListTabContentView.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "CallRecordHistoryListTabContentView.h"

#import "CommonToolkit/CommonToolkit.h"

@implementation CallRecordHistoryListTabContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set title
        self.title = NSLocalizedString(@"call record history list tab content view navigation title", nil);
        
        // set tab bar item with title, image and tag
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"call record history list tab item title", nil) image:[UIImage imageNamed:@"img_tab_callrecord.png"] tag:0];
        
        //
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

@end
