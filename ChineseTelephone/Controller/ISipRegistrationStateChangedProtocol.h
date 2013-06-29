//
//  ISipRegistrationStateChangedProtocol.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-7.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISipRegistrationStateChangedProtocol <NSObject>

@required

// register success
- (void)onRegisterSuccess;

// register failed
- (void)onRegisterFailed;

// unregister success
- (void)onUnRegisterSuccess;

// unregister failed
- (void)onUnRegisterFailed;

@optional

// registering
- (void)onRegistering;

@end
