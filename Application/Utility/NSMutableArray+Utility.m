//
//  NSMutableArray+Utility.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Utility.h"
#import "NSArray+Enumerable.h"

@implementation NSMutableArray (Utility)

- (id) shift {
	id ret = self.first;
	if(ret) [self removeObjectAtIndex:0];
	return ret;	
}

- (void) unshift:(id) obj {
	[self insertObject:obj atIndex:0];
}

- (id) pop {
	id ret = self.last;
	if(ret) [self removeLastObject];
	return ret;
}

- (void) push:(id) obj {
	[self addObject:obj];
}

@end
