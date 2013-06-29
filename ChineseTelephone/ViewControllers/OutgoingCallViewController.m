//
//  OutgoingCallViewController.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-31.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "OutgoingCallViewController.h"

#import <CommonToolkit/CommonToolkit.h>

#import "OutgoingCallView.h"

@interface OutgoingCallViewController ()

@end

@implementation OutgoingCallViewController

- (id)init{
    return [super initWithCompatibleView:[[OutgoingCallView alloc] init]];
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

- (void)setCallMode:(SipCallMode)callMode phone:(NSString *)phone ownnership:(NSString *)ownnership{
    // set outgoing call sip call mode and callee
    [((OutgoingCallView *)self.view) setCallMode:callMode callee:nil != ownnership && ![@"" isEqualToString:ownnership] ? ownnership : phone phone:phone];
}

- (void)setSipImplementation:(id<ISipProtocol>)sipImplementation{
    // set outgoing call sip implementation
    [(OutgoingCallView *)self.view setSipImplementation:sipImplementation];
}

- (id<ISipInviteStateChangedProtocol>)getSipInviteStateChangedImplementation{
    return (OutgoingCallView *)self.view;
}

- (id)getCallbackSipVoiceCallRequestProcessor{
    return (OutgoingCallView *)self.view;
}

@end
