//
//  MoreTabContentViewController.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-29.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "MoreTabContentViewController.h"

#import <CommonToolkit/CommonToolkit.h>

#import "MoreTabContentView.h"

@interface MoreTabContentViewController ()

@end

@implementation MoreTabContentViewController

- (id)init{
    return [super initWithCompatibleView:[[MoreTabContentView alloc] init]];
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
