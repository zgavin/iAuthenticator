//
//  NSURLConnection+AsynchronousRequest.h
//  NPRRadio
//
//  Created by Zachary Gavin on 3/16/12.
//  Copyright (c) 2012 Zachary Gavin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnection (AsynchronousRequest)

+ (void) asyncSimple:(NSString*) url callback:(void(^)(NSData *, NSURLResponse*))block;
+ (void) asyncRequest:(NSURLRequest *)request success:(void(^)(NSData *, NSURLResponse *))successBlock;
+ (void) asyncRequest:(NSURLRequest *)request success:(void(^)(NSData *, NSURLResponse *))successBlock failure:(void(^)(NSData *, NSError *))failureBlock;

@end