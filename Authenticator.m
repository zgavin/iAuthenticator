// 
//  Authenticator.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "Authenticator.h"

#import "Region.h"

@implementation Authenticator 

@dynamic key;
@dynamic serial;
@dynamic name;
@dynamic region;


- (NSString*) token {
	NSDate* date = [NSDate date];
	NSTimeInterval now = [date timeIntervalSince1970];
	return [self tokenAtTimeinterval:now];
}
- (NSString*) tokenAtTimeinterval: (NSTimeInterval) timeInterval {
	uint8_t mac[20];
	uint8_t to_sign[8];
	long interval = (int) timeInterval / 30;
	
	/* Encode counter */
    for (int i = sizeof(to_sign) - 1; i >= 0; i--) {
        to_sign[i] = interval & 0xff;
        interval >>= 8;
    }
	
	NSData* hex_key  = [self.key parseHex];
	
	CCHmac(kCCHmacAlgSHA1, hex_key.bytes, hex_key.length, to_sign, sizeof(to_sign), mac);
	
	int offset = mac[19] & 0x0F;
	long long selectedInt = ((mac[offset] & 0x7f) << 24) | ((mac[offset + 1] & 0xff) << 16) | ((mac[offset + 2] & 0xff) << 8) | (mac[offset + 3] & 0xff);
	return [NSString stringWithFormat:@"%08d",selectedInt % 100000000];
}

@end
