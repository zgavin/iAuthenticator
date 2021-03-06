// 
//  Authenticator.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "Authenticator+Custom.h"

#import "Region.h"
#import <stdlib.h>
#import "tommath.h"
#import "NSString+Hex.h"

NSString* const AUTHENTICATOR_UPDATE_NOTIFICATION = @"AUTHENTICATOR_UPDATE_NOTIFICATION";

const unsigned char public_modulus[] = {0x95,0x5e,0x4b,0xd9,0x89,0xf3,0x91,0x7d,0x2f,0x15,0x54,0x4a,0x7e,0x05,0x04,0xeb,0x9d,0x7b,0xb6,0x6b,0x6f,0x8a,0x2f,0xe4,0x70,0xe4,0x53,0xc7,0x79,0x20,0x0e,0x5e,0x3a,0xd2,0xe4,0x3a,0x02,0xd0,0x6c,0x4a,0xdb,0xd8,0xd3,0x28,0xf1,0xa4,0x26,0xb8,0x36,0x58,0xe8,0x8b,0xfd,0x94,0x9b,0x2a,0xf4,0xea,0xf3,0x00,0x54,0x67,0x3a,0x14,0x19,0xa2,0x50,0xfa,0x4c,0xc1,0x27,0x8d,0x12,0x85,0x5b,0x5b,0x25,0x81,0x8d,0x16,0x2c,0x6e,0x6e,0xe2,0xab,0x4a,0x35,0x0d,0x40,0x1d,0x78,0xf6,0xdd,0xb9,0x97,0x11,0xe7,0x26,0x26,0xb4,0x8b,0xd8,0xb5,0xb0,0xb7,0xf3,0xac,0xf9,0xea,0x3c,0x9e,0x00,0x05,0xfe,0xe5,0x9e,0x19,0x13,0x6c,0xdb,0x7c,0x83,0xf2,0xab,0x8b,0x0a,0x2a,0x99};
const unsigned char public_exponent[] = {0x01,0x01};

@implementation Authenticator (Custom)

- (NSString*) token {
	NSDate* date = [NSDate date];
	NSTimeInterval now = [date timeIntervalSince1970];
	return [self tokenAtTimeinterval:now];
}

- (NSString*) tokenAtTimeinterval: (NSTimeInterval) timeInterval {
	uint8_t mac[20];
	uint8_t to_sign[8];
	long interval = ((int) (timeInterval + [[self.region offset] doubleValue])) / 30;
	
	/* Encode counter */
	for (int i = sizeof(to_sign) - 1; i >= 0; i--) {
		to_sign[i] = interval & 0xff;
		interval >>= 8;
	}
	
	NSData* hex_key  = [self.key parseHex];
	CCHmac(kCCHmacAlgSHA1, hex_key.bytes, hex_key.length, to_sign, sizeof(to_sign), mac);
	
	int offset = mac[19] & 0x0F;
	long long selectedInt = ((mac[offset] & 0x7f) << 24) | ((mac[offset + 1] & 0xff) << 16) | ((mac[offset + 2] & 0xff) << 8) | (mac[offset + 3] & 0xff);
	return [NSString stringWithFormat:@"%08d", (int) selectedInt % 100000000];
}

- (void) enroll {
	[self enrollWithCompletionBlock:nil];
}

- (void) enrollWithCompletionBlock:(void(^)()) callback {
	NSMutableData *data = [NSMutableData dataWithLength:56];
	
	uint8_t function_code[1];
	function_code[0] = 0x01;
	[data replaceBytesInRange:NSMakeRange(0, 1) withBytes:function_code];
	
	int enroll_size = 37;
	uint8_t enroll_key[enroll_size];
	
  
  
	for (int i=0; i< enroll_size; i++) {
		enroll_key[i] = arc4random() % 256;
	}
	
	[data replaceBytesInRange:NSMakeRange( 1,37) withBytes:enroll_key];
	[data replaceBytesInRange:NSMakeRange(38, 2) withBytes:[self.region.code dataUsingEncoding:NSUTF8StringEncoding].bytes];
	[data replaceBytesInRange:NSMakeRange(40,16) withBytes:[@"Motorola RAZR v3" dataUsingEncoding:NSUTF8StringEncoding].bytes];
	
	mp_int result, message, exponent, modulus;
	
	const unsigned char *message_bytes = data.bytes;
	mp_init(&result);
	mp_init(&message);
	mp_init(&exponent);
	mp_init(&modulus);
	
	mp_read_unsigned_bin(&message,message_bytes,data.length);
	mp_read_unsigned_bin(&exponent,public_exponent, 2);
	mp_read_unsigned_bin(&modulus,public_modulus,128);
	mp_exptmod(&message,&exponent,&modulus,&result);
	
	int length = mp_unsigned_bin_size(&result);
	unsigned char output[length];
	mp_to_unsigned_bin (&result, output);
	
	NSData *body = [NSData dataWithBytes:output length:length];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.%@.mobileservice.blizzard.com/enrollment/enroll.htm",self.region.code]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPBody:body];
	[request setHTTPMethod:@"POST"];
	[request addValue:@"128" forHTTPHeaderField:@"Content-length"];
	[request addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-type"];
	
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error){
		NSLog(@"Received %d bytes",receivedData.length);
		uint64_t milliseconds = 0;
		
		[receivedData getBytes:&milliseconds length:8];
		NSLog(@"%@",[NSData dataWithBytes:&milliseconds length:8]);
		milliseconds = CFSwapInt64BigToHost(milliseconds);
		
		NSTimeInterval seconds = milliseconds / 10.0;
		
		NSLog(@"Time: %f",seconds);
		
		uint8_t enroll_key[37];
		[data getBytes:enroll_key range:NSMakeRange(1, 37)];
		
		uint8_t xor[37];
		[receivedData getBytes:xor range:NSMakeRange(8, 37)];
		
		for (int i=0; i<sizeof(xor); i++) {
			xor[i] ^= enroll_key[i];
		}
		
		NSMutableString *new_key = [NSMutableString	stringWithString:@""];
		for (int i=0; i<20; i++) {
			[new_key appendFormat:@"%02x",xor[i]];
		}
		
		NSString *new_serial = [[NSString alloc] initWithBytes:&xor[20] length:17 encoding:NSUTF8StringEncoding];
		
		NSLog(@"Serial: %@",new_serial);
		NSLog(@"Key: %@", new_key);
		
		self.serial = new_serial;
		self.key = new_key;
		if(![self name] || [self name].length == 0) {
			[self setName:new_serial];
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:@"AuthenticatorEnrolled" object:self];
		
		if(callback) callback();
	}];
	
}

@end
