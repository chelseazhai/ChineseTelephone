//
//  SipRegistrationBean.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SipRegistrationBean : NSObject

// sip server
@property (nonatomic, retain) NSString *serverAddr;
// sip user name
@property (nonatomic, retain) NSString *userName;
// sip password
@property (nonatomic, retain) NSString *password;
// sip domain
@property (nonatomic, retain) NSString *domain;
// sip realm
@property (nonatomic, retain) NSString *realm;
// sip port
@property (nonatomic, assign) NSInteger port;

@end
