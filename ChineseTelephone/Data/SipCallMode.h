//
//  SipCallMode.h
//  ChineseTelephone
//
//  Created by Ares on 13-6-5.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#ifndef ChineseTelephone_SipCallMode_h
#define ChineseTelephone_SipCallMode_h

// sip call mode
typedef enum{
    // direct dial and callback
	DIRECT_CALL, CALLBACK
} SipCallMode;

// outgoing call call mode
typedef enum{
    OUTGOINGCALL_DIRECT_CALL = DIRECT_CALL,
    OUTGOINGCALL_CALLBACK = CALLBACK,
    OUTGOINGCALL_Phone_CALL
} OutgoingCallCallMode;

#endif
