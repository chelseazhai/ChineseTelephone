//
//  CallRecordDetailInfoViewController.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-19.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "CallRecordDetailInfoViewController.h"

#import <CommonToolkit/CommonToolkit.h>

#import "CallRecordDetailInfoView.h"

@interface CallRecordDetailInfoViewController ()

@end

@implementation CallRecordDetailInfoViewController

- (id)init{
    return [super initWithCompatibleView:[[CallRecordDetailInfoView alloc] init]];
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

- (CallRecordDetailInfoViewController *)setCallRecord:(CallRecordBean *)callRecord{
    // set call record bean for showing using call record detail info view
    [((CallRecordDetailInfoView *)self.view) setCallRecord:callRecord];
    
    return self;
}

@end
