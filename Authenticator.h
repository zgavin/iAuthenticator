//
//  Authenticator.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <CommonCrypto/CommonHMAC.h>



@class Region;

@interface Authenticator :  NSManagedObject  
{
	NSString * const ENROLL_MODULUS;
	uint8_t enroll_key[37];
	NSMutableData * receivedData;
}

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * serial;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Region * region;

- (NSString*) token;
- (NSString*) tokenAtTimeinterval: (NSTimeInterval) time;
- (void) enroll;

@end



