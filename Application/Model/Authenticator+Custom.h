//
//  Authenticator.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <CommonCrypto/CommonHMAC.h>
#import "Authenticator.h"

extern NSString* const AUTHENTICATOR_UPDATE_NOTIFICATION;

@interface Authenticator (Custom)

- (NSString*) token;
- (NSString*) tokenAtTimeinterval: (NSTimeInterval) time;
- (void) enroll;
- (void) enrollWithCompletionBlock:(void(^)()) callback;

@end



