//
//  ContactListTabContentViewController.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-29.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ContactListTabContentViewController.h"

#import <CommonToolkit/CommonToolkit.h>

#import "ContactListTabContentView.h"

@interface ContactListTabContentViewController ()

@end

@implementation ContactListTabContentViewController

- (id)init{
    return [super initWithCompatibleView:[[ContactListTabContentView alloc] init]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
