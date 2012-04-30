//
//  NSString+Utility.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

- (BOOL) endsWith:(NSString*) end;
- (BOOL) startsWith:(NSString*) start;
- (NSString*) stripTags;

@end
