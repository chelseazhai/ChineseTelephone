//
//  CallRecordHistoryListTabContentViewController.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-29.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "CallRecordHistoryListTabContentViewController.h"

#import <CommonToolkit/CommonToolkit.h>

#import "CallRecordHistoryListTabContentView.h"

@interface CallRecordHistoryListTabContentViewController ()

@end

@implementation CallRecordHistoryListTabContentViewController

- (id)init{
    return [super initWithCompatibleView:[[CallRecordHistoryListTabContentView alloc] init]];
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

- (void)viewWillAppear:(BOOL)animated{
    // get call record history list tab content view
    CallRecordHistoryListTabContentView *_callRecordHistoryListTabContentView = (CallRecordHistoryListTabContentView *)self.view;
    
    // get all call records from database and reload call record list table view data
    [_callRecordHistoryListTabContentView getCallRecordsFromDB];
    [_callRecordHistoryListTabContentView reloadData];
}

@end
