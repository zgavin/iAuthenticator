//
//  NSArray+Enumerable.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArray+Enumerable.h"


@implementation NSArray (Enumerable)

- (id) find:(BOOL(^)(id)) blk {
  for(id obj in self) {
    if(blk(obj)) return obj;
  }
  return nil;
}

- (NSArray*) select:(BOOL(^)(id)) blk {
  NSMutableArray * retArray = [NSMutableArray array];
  for(id obj in self) {
    if(blk(obj)) [retArray addObject:obj];
  }
  return retArray;
}

- (NSArray*) map:(id(^)(id)) blk {
  NSMutableArray * retArray = [NSMutableArray arrayWithCapacity:self.count];
  for(id obj in self) {
		
    [retArray addObject:blk(obj)];
  }
  return retArray;
}

- (id) inject:(id) value withBlock:(id(^)(id,id)) blk {
  for(id obj in self) {
    value = blk(value,obj);
  }
  return value;
}

- (BOOL) any:(BOOL(^)(id)) blk {
  for(id obj in self) {
    if(blk(obj)) return YES;
  }
  return NO;
}

- (BOOL) all:(BOOL(^)(id)) blk {
  for(id obj in self) {
    if(!blk(obj)) return NO;
  }
  return YES;
}

- (id) first {
	return self.count > 0 ? [self objectAtIndex:0] : nil;
}

- (id) last {
	return self.count > 0 ? [self objectAtIndex:self.count-1] : nil;
}

@end
