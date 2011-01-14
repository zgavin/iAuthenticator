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
	int seconds = time - fmod(time,30);
	NSString* string = [NSString stringWithFormat:@"%d",seconds];
	NSString* output = [string  substringFromIndex:[string length]-8];
	/*
	long time = (long) timeInterval / 30000L;
	
	byte[] src = {0,0,0,0,0,0,0,0};
	byteBuffer.clear();		
	System.arraycopy(byteBuffer.putInt((int)time).array(), 0, src, 4, 4);
	
	if(key.length() != 40) return @"Invalid Key";
	
	byte[] key = hexStringToByteArray(secret.toLowerCase());
	
	SecretKeySpec signingKey = new SecretKeySpec(key, HMAC_SHA1_ALGORITHM);
	Mac mac = Mac.getInstance(HMAC_SHA1_ALGORITHM);
	mac.init(signingKey);
	byte[] rawhmac = mac.doFinal(src);
	byte[] authCode = new byte[4];
	System.arraycopy(rawhmac, rawhmac[19] & 0x0F, authCode, 0, 4);
	byteBuffer.clear();
	byteBuffer.put(authCode);
	byteBuffer.rewind();
	int code = byteBuffer.getInt() & 0x7FFFFFFF;
	double modulo = Math.pow(10d, DIGITS);
	code = (int)((double)code % modulo);
	return [NSString stringWithFormat:"%08d", code];
	return output;*/
	return output
}

@end
