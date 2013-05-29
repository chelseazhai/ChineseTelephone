//
//  CallRecordHistoryListTabContentView.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "CallRecordHistoryListTabContentView.h"

#import <CommonToolkit/CommonToolkit.h>

@implementation CallRecordHistoryListTabContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set title
        self.title = NSLocalizedString(@"call record history list tab content view navigation title", nil);
        
        // set tab bar item with title, image and tag
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"call record history list tab item title", nil) image:[UIImage imageNamed:@"img_tab_callrecord"] tag:0];
        
        // set call record history list table view dataSource and delegate
        self.dataSource = self;
        self.delegate = self;
        
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


// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Call record cell";
    
    // get contact list table view cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == _cell) {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    _cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    _cell.textLabel.text = @"张山";
    _cell.detailTextLabel.text = @"13770823456";
    
    return _cell;
}

@end
