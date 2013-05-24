//
//  MoreTabContentView.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "MoreTabContentView.h"

#import "CommonToolkit/CommonToolkit.h"

@implementation MoreTabContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background color
        self.backgroundColor = [UIColor whiteColor];
        
        // set title
        self.title = NSLocalizedString(@"more tab content view navigation title", nil);
        
        // set tab bar item with title, image and tag
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"more tab item title", nil) image:[UIImage imageNamed:@"img_tab_more.png"] tag:3];
        
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
