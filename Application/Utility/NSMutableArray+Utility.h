//
//  NSMutableArray+Utility.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Utility)

- (id) shift;
- (void) unshift:(id) obj;
- (id) pop;
- (void) push:(id) obj;

@end
