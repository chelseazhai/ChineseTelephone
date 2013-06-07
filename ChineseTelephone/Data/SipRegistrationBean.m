//
//  SipRegistrationBean.m
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "SipRegistrationBean.h"

@implementation SipRegistrationBean

@synthesize serverAddr = _serverAddr;
@synthesize userName = _userName;
@synthesize password = _password;
@synthesize domain = _domain;
@synthesize realm = _realm;
@synthesize port = _port;

- (id)init{
    self = [super init];
    if (self) {
        // set sip port default value, 5060
        _port = 5060;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"SipRegistrationBean description: sip server address = %@, user name = %@, password = %@, domain = %@, realm = %@ and port = %d", _serverAddr, _userName, _password, _domain, _realm, _port];
}

@end
