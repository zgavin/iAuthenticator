//
//  NSURLConnection+AsynchronousRequest.m
//  NPRRadio
//
//  Created by Zachary Gavin on 3/16/12.
//  Copyright (c) 2012 Zachary Gavin. All rights reserved.
//

#import "NSURLConnection+AsynchronousRequest.h"

@implementation NSURLConnection (AsynchronousRequest)


+ (void) asyncSimple:(NSString*) url callback:(void(^)(NSData *, NSURLResponse*))block {
	NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
	[NSURLConnection asyncRequest:request success:block];
}

+ (void) asyncRequest:(NSURLRequest *)request success:(void(^)(NSData *, NSURLResponse *))successBlock {
	[NSURLConnection asyncRequest:request success:successBlock failure:nil];
}

+ (void) asyncRequest:(NSURLRequest *)request success:(void(^)(NSData *, NSURLResponse *))successBlock failure:(void(^)(NSData *, NSError *))failureBlock {
	
	dispatch_queue_t queue = dispatch_get_current_queue();
	NSLog(@"Async URL Request: %@", request.URL.absoluteString);
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		
    NSURLResponse *response = nil;
    NSError *error = nil;
		
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
    dispatch_async(queue, ^{
			if (!data) {
				if(failureBlock) failureBlock(data,error);
			} else {
				successBlock(data,response);
			}
		});
	});
}

@end
