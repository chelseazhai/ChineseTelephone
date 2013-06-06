//
//  OutgoingCallControllerButton.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-5.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "OutgoingCallControllerButton.h"

#import <CommonToolkit/CommonToolkit.h>

// button image and title paddding
#define IMG7TITLE_PADDING   10.0

@implementation OutgoingCallControllerButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImage:(UIImage *)image andTitle:(NSString *)title{
    // set image
    [self setImage:image];
    
    // set title and title color
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    // set image and title edge insets
    [self setImageEdgeInsets:UIEdgeInsetsMake(- ([title stringPixelHeightByFontSize:16.0 andIsBold:NO] + IMG7TITLE_PADDING / 2.0), 0.0, 0.0, - self.titleLabel.bounds.size.width)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.bounds.origin.y + image.size.height + IMG7TITLE_PADDING, - image.size.width, 0.0, 0.0)];
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
