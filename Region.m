// 
//  Region.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "Region.h"


@implementation Region 

@dynamic name;
@dynamic code;
@dynamic offset;

- (void) sync {
	systemTime = [[NSDate date] timeIntervalSince1970];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.%@.mobileservice.blizzard.com/enrollment/time.htm",self.code]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection && !receivedData) {
		receivedData = [[NSMutableData data] retain];
	} 
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"Received %d bytes",receivedData.length);
	uint64_t milliseconds = 0;
	[receivedData getBytes:&milliseconds length:8];
	milliseconds = CFSwapInt64BigToHost(milliseconds);
	
	NSTimeInterval seconds = milliseconds / 1000.0;
	
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	
	self.offset = [NSNumber numberWithDouble:seconds-(systemTime+now)/2.0];
}

- (void) dealloc {
	if(receivedData) [receivedData release];
	[super dealloc];
}

@end



