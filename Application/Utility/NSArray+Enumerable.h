//
//  NSArray+Enumerable.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Enumerable)

- (id) find:(BOOL(^)(id)) blk;
- (NSArray*) select:(BOOL(^)(id)) blk;
- (NSArray*) map:(id(^)(id)) blk;
- (id) inject:(id) value withBlock:(id(^)(id,id)) blk;
- (BOOL) any:(BOOL(^)(id)) blk;
- (BOOL) all:(BOOL(^)(id)) blk;
- (id) first;
- (id) last;

@end