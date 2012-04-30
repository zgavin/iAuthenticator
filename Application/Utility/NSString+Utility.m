//
//  NSString+Utility.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

- (BOOL)startsWith:(NSString *)start {
  return start.length <= self.length && [[self substringToIndex:start.length] isEqualToString:start];
}

- (BOOL)endsWith:(NSString *)end {
  return end.length <= self.length && [[self substringFromIndex:self.length-end.length] isEqualToString:end];
}

- (NSString*) stripTags {
  NSMutableString *html = [NSMutableString stringWithCapacity:[self length]];
	
  NSScanner *scanner = [NSScanner scannerWithString:self];
  NSString *tempText = nil;
	
  while (![scanner isAtEnd]) {
		
    [scanner scanUpToString:@"<" intoString:&tempText];
		
    if (tempText != nil)
      [html appendString:tempText];
		
    [scanner scanUpToString:@">" intoString:NULL];
		
    if (![scanner isAtEnd])
      [scanner setScanLocation:[scanner scanLocation] + 1];
		
    tempText = nil;
		
  }
	
  return html ;
}

@end

