//
//  MoreTabContentViewController.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "MoreTabContentViewController.h"

@interface MoreTabContentViewController ()

@end

@implementation MoreTabContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // set title
        self.title = NSLocalizedString(@"more tab content view navigation title", nil);
        
        // set tab bar item image and title
        self.tabBarItem.image = [UIImage imageNamed:@"img_tab_more.png"];
        self.tabBarItem.title = NSLocalizedString(@"more tab item title", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
